DECLARE @errorString NVARCHAR(1000)

BEGIN TRY
BEGIN TRANSACTION

	IF EXISTS (SELECT NULL FROM SupplementFieldKeys)
	BEGIN
		SET @errorString = N'ERROR Group Migration: Migration has already occurred - there are entries in SupplementFieldKeys'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)	
	END

	-- *** REWIRE CodingElementGroupComponents (For components only) *** 
	
    --0. Make all components name text uppercase
    UPDATE CodingElementGroupComponents
    SET NameText = UPPER(NameText)
    
	-- 1. insert missing eng entries
	;WITH cte
	AS
	(
		SELECT DISTINCT(CEGC.NameText) AS VText
		FROM CodingElementGroupComponents CEGC
			JOIN CodingElementGroups CEG
				ON CEGC.CodingElementGroupID = CEG.CodingElementGroupID
				AND CEG.DictionaryLocale = 'eng'
			LEFT JOIN GroupVerbatimEng GVE
				ON GVE.VerbatimText = CEGC.NameText
		WHERE GVE.GroupVerbatimID IS NULL
	)

	INSERT INTO GroupVerbatimEng (VerbatimText)
	SELECT VText
	FROM cte

	-- 2. insert missing jpn entries
	;WITH cte
	AS
	(
		SELECT DISTINCT(CEGC.NameText) AS VText
		FROM CodingElementGroupComponents CEGC
			JOIN CodingElementGroups CEG
				ON CEGC.CodingElementGroupID = CEG.CodingElementGroupID
				AND CEG.DictionaryLocale = 'jpn'
			LEFT JOIN GroupVerbatimJPN GVJ
				ON GVJ.VerbatimText = CEGC.NameText
		WHERE GVJ.GroupVerbatimID IS NULL
	)

	INSERT INTO GroupVerbatimJpn (VerbatimText)
	SELECT VText
	FROM cte

	-- 3. update eng 
	UPDATE CEGC
	SET CEGC.NameTextID = GVE.GroupVerbatimID,
		CEGC.IsSupplement = 0
	FROM CodingElementGroupComponents CEGC
		JOIN CodingElementGroups CEG
			ON CEGC.CodingElementGroupID = CEG.CodingElementGroupID
			AND CEG.DictionaryLocale = 'eng'
		JOIN GroupVerbatimEng GVE
			ON GVE.VerbatimText = CEGC.NameText

	-- 4. update jpn
	UPDATE CEGC
	SET CEGC.NameTextID = GVJ.GroupVerbatimID,
		CEGC.IsSupplement = 0
	FROM CodingElementGroupComponents CEGC
		JOIN CodingElementGroups CEG
			ON CEGC.CodingElementGroupID = CEG.CodingElementGroupID
			AND CEG.DictionaryLocale = 'jpn'
		JOIN GroupVerbatimJPN GVJ
			ON GVJ.VerbatimText = CEGC.NameText
			
	-- *** REWIRE CodingSourceTermSupplementals *** 
	;WITH cte
	AS
	(
		SELECT DISTINCT(CEGC.SupplementalValue) AS VText
		FROM CodingSourceTermSupplementals CEGC
			JOIN CodingElements CE
				ON CE.CodingElementId = CEGC.CodingSourceTermID
			JOIN CodingElementGroups CEG
				ON CE.CodingElementGroupID = CEG.CodingElementGroupID
				AND CEG.DictionaryLocale = 'eng'
			LEFT JOIN GroupVerbatimEng GVE
				ON GVE.VerbatimText = CEGC.SupplementalValue
		WHERE GVE.GroupVerbatimID IS NULL
	)

	INSERT INTO GroupVerbatimEng (VerbatimText)
	SELECT UPPER(VText)
	FROM cte

	-- 2. insert missing jpn entries
	;WITH cte
	AS
	(
		SELECT DISTINCT(CEGC.SupplementalValue) AS VText
		FROM CodingSourceTermSupplementals CEGC
			JOIN CodingElements CE
				ON CE.CodingElementId = CEGC.CodingSourceTermID
			JOIN CodingElementGroups CEG
				ON CE.CodingElementGroupID = CEG.CodingElementGroupID
				AND CEG.DictionaryLocale = 'jpn'
			LEFT JOIN GroupVerbatimJPN GVJ
				ON GVJ.VerbatimText = CEGC.SupplementalValue
		WHERE GVJ.GroupVerbatimID IS NULL
	)

	INSERT INTO GroupVerbatimJpn (VerbatimText)
	SELECT UPPER(VText)
	FROM cte

	-- 3. update eng 
	UPDATE CEGC
	SET CEGC.ValueId = GVE.GroupVerbatimID
	FROM CodingSourceTermSupplementals CEGC
		JOIN CodingElements CE
			ON CE.CodingElementId = CEGC.CodingSourceTermID
		JOIN CodingElementGroups CEG
			ON CE.CodingElementGroupID = CEG.CodingElementGroupID
			AND CEG.DictionaryLocale = 'eng'
		JOIN GroupVerbatimEng GVE
			ON GVE.VerbatimText = CEGC.SupplementalValue

	-- 4. update jpn
	UPDATE CEGC
	SET CEGC.ValueId = GVJ.GroupVerbatimID
	FROM CodingSourceTermSupplementals CEGC
		JOIN CodingElements CE
			ON CE.CodingElementId = CEGC.CodingSourceTermID
		JOIN CodingElementGroups CEG
			ON CE.CodingElementGroupID = CEG.CodingElementGroupID
			AND CEG.DictionaryLocale = 'jpn'
		JOIN GroupVerbatimJPN GVJ
			ON GVJ.VerbatimText = CEGC.SupplementalValue

	-- 5. insert missing field key entries
	;WITH cte
	AS
	(
		SELECT DISTINCT(CEGC.SupplementTermKey) AS VText
		FROM CodingSourceTermSupplementals CEGC
			LEFT JOIN SupplementFieldKeys S
				ON CEGC.SupplementTermKey = S.KeyField
		WHERE S.SupplementFieldKeyId IS NULL
	)

	INSERT INTO SupplementFieldKeys (KeyField)
	SELECT VText
	FROM cte

	-- 6. update key entries
	UPDATE CEGC
	SET CEGC.KeyId = S.SupplementFieldKeyId
	FROM CodingSourceTermSupplementals CEGC
		JOIN SupplementFieldKeys S
				ON CEGC.SupplementTermKey = S.KeyField
				
	-- *** Migrate Groups *** --

	-- perform check
	IF EXISTS (SELECT NULL FROM CodingSourceTermSupplementals
		WHERE KeyId < 1 OR ValueId < 1)
	BEGIN
		SET @errorString = N'ERROR Group Migration: CodingSourceTermSupplementals not migrated yet'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END

	-- 1. identify new groups (those with supps)


	-- 2. save the info
	-- if longer than 890 bytes, than 'houston...' - probability sufficiently low
	-- [given max keyid length of 3 and valueid length of 4, each supplement translates to 9 bytes, which]
	-- [means that we'd need more than 97 supplements to get to that case]
	INSERT INTO [TmpProcessingGroup] (CodingElementGroupID, KeyField, NewGroupId)
	SELECT CE.CodingElementGroupID, X.CompositeKey, 0
	FROM CodingElements CE
		--WITH (FORCESEEK)
		CROSS APPLY
		(
			SELECT CAST(KeyId AS VARCHAR) +':'+CAST(ValueId AS VARCHAR) + ';'
			FROM CodingSourceTermSupplementals CSTS
			WHERE CE.CodingElementID = CSTS.CodingSourceTermID
			ORDER BY KeyId, ValueId
			FOR XML PATH('')
		) AS X (CompositeKey)
	WHERE EXISTS (SELECT NULL FROM CodingSourceTermSupplementals
		WHERE CE.CodingElementID = CodingSourceTermID)
		AND X.CompositeKey IS NOT NULL
	GROUP BY CE.CodingElementGroupID, X.CompositeKey

	-- 3. create the new groups
	-- a. group placeholders first
	DECLARE @idMapper TABLE(Id INT PRIMARY KEY, NewGroupID INT)
	DECLARE @i INT = 0, @maxRows INT = 100

	WHILE (1 = 1)
	BEGIN

		DELETE @idMapper

		INSERT INTO CodingElementGroups 
			(DictionaryLevelID, DictionaryLocale, GroupVerbatimID, MedicalDictionaryID, SegmentID, ProgrammaticAuxiliary, CompSuppCount)
				OUTPUT inserted.ProgrammaticAuxiliary, inserted.CodingElementGroupId INTO @idMapper(Id, NewGroupID)
		SELECT TOP (@maxRows)
			CEG.DictionaryLevelID, CEG.DictionaryLocale, CEG.GroupVerbatimID, CEG.MedicalDictionaryID, CEG.SegmentID, TP.Id, 0 -- TODO : eval count later
		FROM [TmpProcessingGroup] TP
			JOIN CodingElementGroups CEG
				ON TP.CodingElementGroupID = CEG.CodingElementGroupID
		WHERE TP.Id > @i
		ORDER BY TP.Id
		
		IF (@@ROWCOUNT = 0)
			BREAK
		
		-- save the mappings
		UPDATE TP
		SET TP.NewGroupId = IM.NewGroupID
		FROM [TmpProcessingGroup] TP
			JOIN @idMapper IM
				ON TP.Id = IM.Id
				
		SELECT @i = MAX(Id)
		FROM @idMapper

	END

	-- 4. add the components for these new groups (mere copy from the already wired existing groups)
	INSERT INTO CodingElementGroupComponents (CodingElementGroupID, ComponentTypeID, IsSupplement, NameTextID, SearchOperator, SearchType) 
	SELECT TP.NewGroupId, CEGS.ComponentTypeID, 0, CEGS.NameTextID, CEGS.SearchOperator, CEGS.SearchType
	FROM [TmpProcessingGroup] TP
		JOIN CodingElementGroups CEG
			ON TP.CodingElementGroupID = CEG.CodingElementGroupID
		JOIN CodingElementGroupComponents CEGS
			ON CEGS.CodingElementGroupID = CEG.CodingElementGroupID
			
	-- 5. Update task groupId
	UPDATE CE
	SET CE.CodingElementGroupID = TP.NewGroupId
	FROM [TmpProcessingGroup] TP
		JOIN CodingElements CE
			ON TP.CodingElementGroupID = CE.CodingElementGroupID
		CROSS APPLY
		(
			SELECT CAST(KeyId AS VARCHAR) +':'+CAST(ValueId AS VARCHAR) + ';'
			FROM CodingSourceTermSupplementals CSTS
			WHERE CE.CodingElementID = CSTS.CodingSourceTermID
			ORDER BY KeyId, ValueId
			FOR XML PATH('')
		) AS X (CompositeKey)
	WHERE X.CompositeKey = TP.KeyField

	-- 6. add the supplements for these new groups
	INSERT INTO CodingElementGroupComponents (CodingElementGroupID, ComponentTypeID, IsSupplement, NameTextID, SearchOperator, SearchType) 
	SELECT TP.NewGroupId, CSTS.KeyId, 1, CSTS.ValueId, CSTS.SearchOperator, 1
	FROM [TmpProcessingGroup] TP
		CROSS APPLY
		(
			SELECT TOP 1 TopElementID = CE.CodingElementID
			FROM CodingElements CE
			WHERE TP.NewGroupID = CE.CodingElementGroupID
		) AS GROUP_REP
		JOIN CodingSourceTermSupplementals CSTS
			ON CSTS.CodingSourceTermID = GROUP_REP.TopElementID

	-- 7. update component counts
	UPDATE CEG
	SET CEG.CompSuppCount = X.CompCount
	FROM CodingElementGroups CEG
		CROSS APPLY
		(
			SELECT CompCount = COUNT(*)
			FROM CodingElementGroupComponents CEGC
			WHERE CEG.CodingElementGroupID = CEGC.CodingElementGroupID
		) AS X

	-- *** Synonym, Assignment & History Impact *** --
	-- double the synonyms

	DECLARE @maxId INT
	SELECT @maxId = MAX(SegmentedGroupCodingPatternID)
	FROM SegmentedGroupCodingPatterns
	
	-- Use the UserID for PiggyBack
	INSERT INTO SegmentedGroupCodingPatterns 
		(CodingElementGroupID, CodingPatternID, DictionaryVersionID, IsProvisional, IsValidForAutoCode, SegmentID, MatchPercent, Active, UserID, SynonymManagementID, CacheVersion)
		OUTPUT inserted.UserId, inserted.SegmentedGroupCodingPatternID, inserted.CacheVersion INTO TmpProcessingSynonym(IdOld, IdNew, TmpId )
	SELECT 
		TP.NewGroupId, SGCP.CodingPatternID, SGCP.DictionaryVersionID, SGCP.IsProvisional, SGCP.IsValidForAutoCode, SGCP.SegmentID, SGCP.MatchPercent, SGCP.Active, SGCP.SegmentedGroupCodingPatternID, SGCP.SynonymManagementID, TP.Id
	FROM SegmentedGroupCodingPatterns SGCP
		JOIN [TmpProcessingGroup] TP
			ON TP.CodingElementGroupID = SGCP.CodingElementGroupID

	UPDATE SegmentedGroupCodingPatterns
	SET UserID = -2
	WHERE SegmentedGroupCodingPatternID > @maxId
	
	-- update the synonym count
	;WITH NewSynsCTE (SynListId, AddedCount)
	AS
	(
		SELECT SGCP.SynonymManagementID, COUNT(*)
		FROM TmpProcessingSynonym TPS
			JOIN SegmentedGroupCodingPatterns SGCP
				ON TPS.IdNew = SGCP.SegmentedGroupCodingPatternID
		WHERE SGCP.IsValidForAutoCode = 1 OR SGCP.IsProvisional = 1
		GROUP BY SGCP.SynonymManagementID
	)

	UPDATE S
	SET S.NumberOfSynonyms = S.NumberOfSynonyms + CTE.AddedCount
	FROM SynonymMigrationMngmt S
		JOIN NewSynsCTE CTE
			ON S.SynonymMigrationMngmtID = CTE.SynListId

	-- rewire CodingElements (only those who got migrated to new groups)
	UPDATE CE
	SET CE.AssignedSegmentedGroupCodingPatternId = TPS.IdNew
	FROM CodingElements CE
		JOIN [TmpProcessingGroup] TP
			ON TP.NewGroupID = CE.CodingElementGroupID
		JOIN TmpProcessingSynonym TPS
			ON TPS.IdOld = CE.AssignedSegmentedGroupCodingPatternId
			AND TPS.TmpId = TP.Id

	-- rewire CodingAssignments (only those who got migrated to new groups)
	UPDATE CA
	SET CA.SegmentedGroupCodingPatternID = TPS.IdNew
	FROM CodingElements CE
		JOIN [TmpProcessingGroup] TP
			ON TP.NewGroupID = CE.CodingElementGroupID
		JOIN CodingAssignment CA
			ON CA.CodingElementID = CE.CodingElementId
		JOIN TmpProcessingSynonym TPS
			ON TPS.IdOld = CA.SegmentedGroupCodingPatternID
			AND TPS.TmpId = TP.Id

	-- WorkflowHistory
	INSERT INTO WorkflowTaskHistory
		(WorkflowTaskID, WorkflowStateID, WorkflowActionID, WorkflowSystemActionID, UserID, WorkflowReasonID, 
		Comment, SegmentId, CodingAssignmentId)
	SELECT History.WorkflowTaskID, History.WorkflowStateID, History.WorkflowActionID, History.WorkflowSystemActionID, -2, NULL, 
		'New coding group to include supplements', History.SegmentId, History.CodingAssignmentId
	FROM [TmpProcessingGroup] TP
		JOIN CodingElements CE
			ON TP.NewGroupId = CE.CodingElementGroupID
		CROSS APPLY
		(
			SELECT TOP 1 *
			FROM WorkflowTaskHistory WTH
			WHERE CE.CodingElementId = WTH.WorkflowTaskID
			ORDER BY WorkflowTaskHistoryID DESC
		) AS History

COMMIT TRANSACTION

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION

	SET @errorString = N'ERROR Group Migration: Transaction Error Message - ' + ERROR_MESSAGE()
	PRINT @errorString
	RAISERROR(@errorString, 16, 1)
END CATCH
