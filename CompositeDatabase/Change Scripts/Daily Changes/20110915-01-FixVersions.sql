	-- Process missing Post Processing if any
	DECLARE versioningCursor CURSOR FAST_FORWARD FOR
	SELECT Locale, MedicalDictionaryId, OldVersionOrdinal, NewVersionOrdinal FROM MedicalDictVerLocaleStatus
	WHERE OldVersionOrdinal IS NOT NULL
		AND VersionStatus = 9
	
	DECLARE @Locale CHAR(3),
			@MedicalDictionaryID INT,
			@FromVersionOrdinal INT,
			@ToVersionOrdinal INT,
			@LocaleID INT,
			@IOROffset INT

	
	OPEN versioningCursor
	FETCH NEXT FROM versioningCursor INTO @Locale, @MedicalDictionaryID, @FromVersionOrdinal, @ToVersionOrdinal
	
	WHILE (@@FETCH_STATUS = 0)
	BEGIN

		SELECT @LocaleID = ID,
			@IOROffset = LocaleOffsetForIOR
		FROM CoderLocaleAddlInfo
		WHERE Locale = @Locale

		-- Finalize the post-processing (update version data with activation details)
		BEGIN TRY
			
			;WITH newVersionCTE (TermUpdateID, ImpactAnalysisChangeTypeId, SuggestionPriorTermID )
			AS
			(
			SELECT 
				NextV.TermUpdateID,
				CASE 
					WHEN PriorV.TermID IS NULL THEN 7 -- Term[text] and Code not found
					ELSE 
						CASE 
							WHEN PriorV.Term = NextV.Term THEN
								CASE
									WHEN PriorV.Code = NextV.Code THEN
										CASE 
											WHEN NextV.IsCurrent = 0 THEN 2  --Obsolete (IsCurrent set to false from true)
											ELSE 3							--ReInstated (IsCurrent set to true from false)
										END
									ELSE 6 -- Code not found
								END
							ELSE	5	-- Term[text] not found 
						END
				END AS ImpactAnalysisChangeTypeId,
				CASE 
					WHEN PriorV.TermID IS NULL THEN -1
					ELSE PriorV.TermID
				END AS SuggestionPriorTermID
			FROM 
				(
				SELECT 
					U.TermUpdateID, 
					Ver.Code, 
					CASE WHEN @Locale = 'eng' THEN Ver.Term_ENG
						 WHEN @Locale = 'jpn' THEN Ver.Term_JPN
						 ELSE Ver.Term_LOC
					END As Term,
					Ver.DictionaryLevelId AS LevelId,
					Ver.IsCurrent
				FROM MedDictTermUpdates U
					JOIN MedicalDictVerTerm Ver
						ON U.VersionTermID = Ver.TermID
						AND U.PriorTermID = -1
						AND U.InitialTermID IS NULL -- rather redundant
						AND U.FromVersionOrdinal = @FromVersionOrdinal
						AND U.ToVersionOrdinal = @ToVersionOrdinal
						AND U.MedicalDictionaryID = @MedicalDictionaryID
						--AND U.Locale = @Locale
						AND U.Locale = @LocaleID
				) AS NextV -- next version terms (as indicated in the version staging tables
				LEFT JOIN
				(
				SELECT 
					TermID, 
					Code, 
					CASE WHEN @Locale = 'eng' THEN Term_ENG
						 WHEN @Locale = 'jpn' THEN Term_JPN
						 ELSE Term_LOC
					END AS Term,
					DictionaryLevelId AS LevelID,
					IsCurrent
				FROM MedicalDictionaryTerm
				WHERE @FromVersionOrdinal BETWEEN FromVersionOrdinal AND ToVersionOrdinal
					AND MedicalDictionaryId = @MedicalDictionaryId
					AND SegmentId = -1 -- vendor terms only
					AND dbo.fnIsValidForVersionLocale(FromVersionOrdinal, ToVersionOrdinal, @IOROffset, @FromVersionOrdinal, IORVersionLocaleValidity) = 1
				) AS PriorV -- tentative prior version term resolution
					ON NextV.LevelId = PriorV.LevelId
					AND NextV.Code = PriorV.Code
					--AND ( NextV.Code = PriorV.Code OR NextV.Term = PriorV.Term ) -- WHODRUG Change for same term text with different codes
			)
			
			-- TODO : handle multiples........ (this logic is not necessary ATM)
			UPDATE U
			SET U.ImpactAnalysisChangeTypeId = C.ImpactAnalysisChangeTypeId, 
				U.PriorTermID = C.SuggestionPriorTermID -- these are multiples
			FROM MedDictTermUpdates U
				JOIN newVersionCTE C
					ON U.TermUpdateID = C.TermUpdateID

			PRINT N'PostProcessing: oldVersionCTE - started...' + CONVERT(NVARCHAR,GETUTCDATE(),21)

			-- prior Version terms that are not matched at all in the new version....
			;WITH oldVersionCTE (OldVersionTermID, ImpactAnalysisChangeTypeId, SuggestionNextTermID )
			AS
			(
			SELECT 
				PriorV.TermID,
				CASE 
					WHEN NextV.TermID IS NULL THEN 7 -- Term[text] and Code not found
					ELSE 
						CASE 
							WHEN PriorV.Term = NextV.Term THEN
								CASE
									WHEN PriorV.Code = NextV.Code THEN
										CASE 
											WHEN NextV.IsCurrent = 0 THEN 2  --Obsolete (IsCurrent set to false from true)
											ELSE 3							--ReInstated (IsCurrent set to true from false)
										END
									ELSE 6 -- Code not found
								END
							ELSE	5	-- Term[text] not found 
						END
				END AS ImpactAnalysisChangeTypeId,
				CASE 
					WHEN NextV.TermID IS NULL THEN -1
					ELSE NextV.TermID
				END
			FROM 
				(
				SELECT TermID,
					Code, 
					CASE WHEN @Locale = 'eng' THEN Term_ENG
						 WHEN @Locale = 'jpn' THEN Term_JPN
						 ELSE Term_LOC
					END As Term,
					DictionaryLevelId AS LevelId,
					IsCurrent
				FROM MedicalDictionaryTerm
				WHERE @FromVersionOrdinal BETWEEN FromVersionOrdinal AND ToVersionOrdinal
					AND @ToVersionOrdinal > ToVersionOrdinal
					AND MedicalDictionaryID = @MedicalDictionaryId
					AND dbo.fnIsValidForVersionLocale(FromVersionOrdinal, ToVersionOrdinal, @IOROffset, @FromVersionOrdinal, IORVersionLocaleValidity) = 1
					AND TermId NOT IN (SELECT PriorTermId FROM MedDictTermUpdates
						WHERE FromVersionOrdinal = @FromVersionOrdinal 
							AND ToVersionOrdinal = @ToVersionOrdinal
							AND MedicalDictionaryID = @MedicalDictionaryId
							--AND Locale = @Locale
							AND Locale = @LocaleID
							AND ImpactAnalysisChangeTypeId IN (1, 2, 3, 4)
						)
					AND SegmentId = -1
				) AS PriorV
			LEFT JOIN 
				(
				SELECT 
					U.FinalTermID AS TermID, 
					Ver.Code, 
					CASE WHEN @Locale = 'eng' THEN Ver.Term_ENG
						 WHEN @Locale = 'jpn' THEN Ver.Term_JPN
						 ELSE Ver.Term_LOC
					END As Term,
					Ver.DictionaryLevelId AS LevelId,
					Ver.IsCurrent
				FROM MedDictTermUpdates U
					JOIN MedicalDictVerTerm Ver
						ON U.VersionTermID = Ver.TermID
						AND U.FromVersionOrdinal = @FromVersionOrdinal
						AND U.ToVersionOrdinal = @ToVersionOrdinal
						AND U.MedicalDictionaryID = @MedicalDictionaryId
						--AND U.Locale = @Locale
						AND U.Locale = @LocaleID
				) AS NextV -- next version terms (as indicated in the version staging tables

				ON NextV.LevelId = PriorV.LevelId
				AND ( NextV.Code = PriorV.Code)
				--AND ( NextV.Code = PriorV.Code OR NextV.Term = PriorV.Term )-- WHODRUG Change for same term text with different codes
			LEFT JOIN ImpactAnalysisVersionDifference IAVD
				ON IAVD.OldTermID = PriorV.TermID
				AND IAVD.MedicalDictionaryID = @MedicalDictionaryID
				AND IAVD.FromVersionOrdinal = @FromVersionOrdinal
				AND IAVD.ToVersionOrdinal = @ToVersionOrdinal
				AND IAVD.Locale = @LocaleID
			WHERE IAVD.MedicalDictionaryID IS NULL
			)
			
			-- Multiples allowed
			INSERT INTO ImpactAnalysisVersionDifference
			(MedicalDictionaryID, FromVersionOrdinal, ToVersionOrdinal, Locale, 
				OldTermID, ImpactAnalysisChangeTypeId, FinalTermID)
			SELECT @MedicalDictionaryID, @FromVersionOrdinal, @ToVersionOrdinal, @LocaleID, 
				OldVersionTermID, ImpactAnalysisChangeTypeId, SuggestionNextTermID
			FROM oldVersionCTE
			
			PRINT N'PostProcessing: oldVersionCTE - ended...' + CONVERT(NVARCHAR,GETUTCDATE(),21)
			

			INSERT INTO ImpactAnalysisVersionDifference
			(MedicalDictionaryID, FromVersionOrdinal, ToVersionOrdinal, Locale, 
				OldTermID, ImpactAnalysisChangeTypeId, FinalTermID)
			SELECT @MedicalDictionaryID, @FromVersionOrdinal, @ToVersionOrdinal, @LocaleID, 
				PriorTermID, U.ImpactAnalysisChangeTypeId, U.FinalTermID
			FROM MedDictTermUpdates U
				LEFT JOIN ImpactAnalysisVersionDifference IAVD
					ON IAVD.OldTermID = U.PriorTermID
					AND IAVD.MedicalDictionaryID = U.MedicalDictionaryID
					AND IAVD.FromVersionOrdinal = U.FromVersionOrdinal
					AND IAVD.ToVersionOrdinal = U.ToVersionOrdinal
					AND IAVD.Locale = U.Locale
					AND IAVD.ImpactAnalysisChangeTypeId = U.ImpactAnalysisChangeTypeId
			WHERE IAVD.MedicalDictionaryID IS NULL
				AND U.FromVersionOrdinal = @FromVersionOrdinal 
				AND U.ToVersionOrdinal = @ToVersionOrdinal
				AND U.MedicalDictionaryID = @MedicalDictionaryId
				--AND Locale = @Locale
				AND U.Locale = @LocaleID
				AND U.ImpactAnalysisChangeTypeId IN (1, 2, 3, 4)
				

			UPDATE MedicalDictVerLocaleStatus
			SET VersionStatus = 10
			WHERE MedicalDictionaryID = @MedicalDictionaryID
				AND NewVersionOrdinal = @ToVersionOrdinal
				AND OldVersionOrdinal = @FromVersionOrdinal
				AND Locale = @Locale			
			
		END TRY
		BEGIN CATCH
			PRINT N'VersionDifferencePostProcessing failure for DictionaryID:'+ CAST(@medicalDictionaryID AS NVARCHAR) + N' - for FromVersionOrdinal:'+CAST(@FromVersionOrdinal AS NVARCHAR) + N' - for ToVersionOrdinal:'+CAST(@ToVersionOrdinal AS NVARCHAR) + N' - for Locale:'+@Locale
		END CATCH 

		FETCH NEXT FROM versioningCursor INTO @Locale, @MedicalDictionaryID, @FromVersionOrdinal, @ToVersionOrdinal
	END
	
	CLOSE versioningCursor
	DEALLOCATE versioningCursor