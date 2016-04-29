/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
//
//
// Fills in missing differences for Japanese (or other non-English) across dictionary versions
// (extracted from modifications made to spVersionDifferencePostProcessingV1_1)
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_004')
	DROP PROCEDURE spCoder_CMP_004
GO

CREATE PROCEDURE dbo.spCoder_CMP_004 
AS
BEGIN
 
	DECLARE @ordinalTable TABLE (MedicalDictionaryID INT, FromOrdinal INT, ToOrdinal INT, Locale CHAR(3), LocaleID INT)

	INSERT INTO @ordinalTable(MedicalDictionaryID , FromOrdinal, ToOrdinal , Locale , LocaleID)
	SELECT MedicalDictionaryID, OldVersionOrdinal, NewVersionOrdinal, MVLS.Locale, CLAI.ID
	FROM MedicalDictVerLocaleStatus MVLS
		JOIN CoderLocaleAddlInfo CLAI
			ON MVLS.Locale = CLAI.Locale
	WHERE MVLS.Locale <> 'eng'
		AND OldVersionOrdinal IS NOT NULL
		AND VersionStatus = 10



	-- prior Version terms that are not matched at all in the new version....
	;WITH oldVersionCTE (OldVersionTermID, ImpactAnalysisChangeTypeId, SuggestionNextTermID, FromVersionOrdinal, ToVersionOrdinal, LocaleId, MedicalDictionaryID )
	AS
	(
		SELECT Past_V.FinalTermID,
			CASE 
				WHEN V.FinalTermID IS NULL THEN 7 -- Term[text] and Code not found
				ELSE 
					CASE 
						WHEN
							(OT.Locale = 'eng' AND V.Term_ENG = Past_V.Term_ENG)
							OR
							(OT.Locale = 'jpn' AND V.Term_JPN = Past_V.Term_JPN)
							OR
							(OT.Locale = 'loc' AND V.Term_LOC = Past_V.Term_LOC)
						 THEN
							CASE
								WHEN Past_V.Code = V.Code THEN
									CASE 
										WHEN V.IsCurrent = 0 THEN 2  --Obsolete (IsCurrent set to false from true)
										ELSE 3							--ReInstated (IsCurrent set to true from false)
									END
								ELSE 6 -- Code not found
							END
						ELSE	5	-- Term[text] not found 
					END
			END AS ImpactAnalysisChangeTypeId,
			ISNULL(V.FinalTermID, -1),
			Past_V.DictionaryVersionOrdinal,
			OT.ToOrdinal,
			OT.LocaleID,
			Past_V.MedicalDictionaryID
		FROM @ordinalTable OT
			JOIN MedicalDictVerTerm Past_V
				ON OT.MedicalDictionaryID = Past_V.MedicalDictionaryID
				AND Past_V.DictionaryVersionOrdinal = OT.FromOrdinal --@ToVersionOrdinal
				-- past must be present
				AND 
					(
						(OT.Locale = 'eng' AND Past_V.Term_ENG <> '')
						OR
						(OT.Locale = 'jpn' AND Past_V.Term_JPN <> '')
						OR
						(OT.Locale = 'loc' AND Past_V.Term_LOC <> '')
					)					
			LEFT JOIN MedDictTermUpdates U
				ON U.PriorTermID = Past_V.FinalTermID
				AND U.FromVersionOrdinal = Past_V.DictionaryVersionOrdinal
				AND U.ToVersionOrdinal = OT.ToOrdinal --@ToVersionOrdinal
				AND U.MedicalDictionaryID = Past_V.MedicalDictionaryID
				AND U.Locale = OT.LocaleID -- @LocaleID
				AND U.ImpactAnalysisChangeTypeId IN (1, 2, 3, 4)
			LEFT JOIN ImpactAnalysisVersionDifference IAVD
				ON IAVD.OldTermID = Past_V.FinalTermID
				AND IAVD.MedicalDictionaryID = Past_V.MedicalDictionaryID
				AND IAVD.FromVersionOrdinal = Past_V.DictionaryVersionOrdinal
				AND IAVD.ToVersionOrdinal = OT.ToOrdinal --@ToVersionOrdinal
				AND IAVD.Locale = OT.LocaleID --@LocaleID
			LEFT JOIN MedicalDictVerTerm V
				ON V.DictionaryVersionOrdinal = OT.ToOrdinal --@ToVersionOrdinal
				AND V.DictionaryLevelId = Past_V.DictionaryLevelId
				AND V.MedicalDictionaryID = Past_V.MedicalDictionaryID
				AND V.Code = Past_V.Code
				-- future must be present
				AND 
					(
						OT.Locale = 'eng'
						OR
						(OT.Locale = 'jpn' AND V.Term_JPN <> '')
						OR
						(OT.Locale = 'loc' AND V.Term_LOC <> '')
					)
		WHERE U.TermUpdateId IS NULL
			AND IAVD.MedicalDictionaryID IS NULL
			-- exclude false positives introduced due to IOR
			AND NOT 
				(
					V.FinalTermID = Past_V.FinalTermID
					AND V.IsCurrent = Past_V.IsCurrent
					AND
					(
						(OT.Locale = 'jpn' AND V.Term_JPN = Past_V.Term_JPN)
						OR
						(OT.Locale = 'loc' AND V.Term_LOC = Past_V.Term_LOC)
					)
				)
	)

	-- Multiples allowed
	INSERT INTO ImpactAnalysisVersionDifference
	(MedicalDictionaryID, FromVersionOrdinal, ToVersionOrdinal, Locale, 
		OldTermID, ImpactAnalysisChangeTypeId, FinalTermID)
	SELECT MedicalDictionaryID, FromVersionOrdinal, ToVersionOrdinal, LocaleId, 
		OldVersionTermID, ImpactAnalysisChangeTypeId, SuggestionNextTermID
	FROM oldVersionCTE
	OPTION (RECOMPILE)
	
END
