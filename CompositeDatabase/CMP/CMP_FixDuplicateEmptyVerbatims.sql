IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'CMP_FixDuplicateEmptyVerbatims')
	DROP PROCEDURE CMP_FixDuplicateEmptyVerbatims
GO

CREATE PROCEDURE dbo.CMP_FixDuplicateEmptyVerbatims
(
	@mode BIT = 0 -- DEBUG MODE, use 1 for RUN MODE
)  
AS  
BEGIN

	IF (@MODE = 0)
	BEGIN
		PRINT 'Debug mode - will not modify data'
		PRINT 'Invoke with @mode = 1 to run for real.'
	END

	SET NOCOUNT ON
	SET XACT_ABORT ON

	SELECT 'Started - '+CAST(GETUTCDATE() AS VARCHAR)

	-- *** START - get the existing entries for empty verbatims
	-- !!! these entries should not exist !!!
	DECLARE @badEmptyVerbatims TABLE(GroupVerbatimId INT, Locale CHAR(3))

	INSERT INTO @badEmptyVerbatims (GroupVerbatimId, Locale)
	SELECT GroupVerbatimId, 'eng'
	FROM GroupVerbatimEng
	WHERE VerbatimText = ''
		AND GroupVerbatimId > 0

	INSERT INTO @badEmptyVerbatims (GroupVerbatimId, Locale)
	SELECT GroupVerbatimId, 'jpn'
	FROM GroupVerbatimJpn
	WHERE VerbatimText = N''
		AND GroupVerbatimId > 0

	-- GET the affected CodingElementGroupComponents (CEGC)
	DECLARE @badCEGC TABLE
		(
			CodingElementGroupID INT PRIMARY KEY
		)

	INSERT INTO @badCEGC
	SELECT DISTINCT(CEGC.CodingElementGroupID)
	FROM @badEmptyVerbatims Bad_Verbatims 
		JOIN CodingElementGroupComponents CEGC
			ON CEGC.NameTextID = Bad_Verbatims.GroupVerbatimId
		JOIN CodingElementGroups CEG
			ON CEG.CodingElementGroupID = CEGC.CodingElementGroupID 
			AND CEG.DictionaryLocale = Bad_Verbatims.Locale

	SELECT 'Resolved affected CodingElementGroupComponents'+CAST(GETUTCDATE() AS VARCHAR)

	-- GET the affected CodingElementGroups (CEGs)
	DECLARE @badCEG TABLE
		(
			CodingElementGroupID INT PRIMARY KEY, 
			CompSuppCount INT,
			GroupVerbatimID INT,
			GroupVerbatimIDToMatch INT,
			DictionaryLevelID INT, 
			SegmentId INT,
			Locale CHAR(3),
			ToCodingElementGroupID INT
		)

	;WITH BAD_CEG
	AS
	(
		SELECT CEG.*, Bad_CEG_Verbatims.GroupVerbatimId AS GroupVerbatimIDToMatch
		FROM CodingElementGroups CEG
			JOIN @badEmptyVerbatims Bad_CEG_Verbatims
				ON CEG.GroupVerbatimID   = Bad_CEG_Verbatims.GroupVerbatimId 
				AND CEG.DictionaryLocale = Bad_CEG_Verbatims.Locale
	)

	INSERT INTO @badCEG (CodingElementGroupID, CompSuppCount, GroupVerbatimID, GroupVerbatimIDToMatch, DictionaryLevelID, SegmentId, Locale, ToCodingElementGroupID)
	SELECT CodingElementGroupID, CompSuppCount, GroupVerbatimID, GroupVerbatimIDToMatch, DictionaryLevelID, SegmentID, DictionaryLocale, -1
	FROM BAD_CEG

	INSERT INTO @badCEG (CodingElementGroupID, CompSuppCount, GroupVerbatimID, GroupVerbatimIDToMatch, DictionaryLevelID, SegmentId, Locale, ToCodingElementGroupID)
	SELECT CodingElementGroupID, CompSuppCount, GroupVerbatimID, GroupVerbatimID, DictionaryLevelID, SegmentID, DictionaryLocale, -1
	FROM CodingElementGroups
	WHERE CodingElementGroupID IN (SELECT CodingElementGroupID FROM @badCEGC)
		AND CodingElementGroupID NOT IN (SELECT CodingElementGroupID FROM @badCEG)

	SELECT 'Resolved affected CodingElementGroups'+CAST(GETUTCDATE() AS VARCHAR)

	-- map existing CEG conflicts (if any)
	UPDATE BAD_CEG
	SET BAD_CEG.ToCodingElementGroupID = GOOD_CEG.CodingElementGroupID
	FROM 
		-- BAD CEG
		@badCEG Bad_CEG
		-- GOOD CEG
		JOIN CodingElementGroups GOOD_CEG
			ON GOOD_CEG.DictionaryLevelID = BAD_CEG.DictionaryLevelID
			AND GOOD_CEG.CodingElementGroupID <> BAD_CEG.CodingElementGroupID -- do not match self
			AND GOOD_CEG.SegmentID        = BAD_CEG.SegmentID
			AND GOOD_CEG.CompSuppCount    = Bad_CEG.CompSuppCount
			AND GOOD_CEG.DictionaryLocale = BAD_CEG.Locale
			AND GOOD_CEG.GroupVerbatimID  = BAD_CEG.GroupVerbatimIDToMatch
		-- CEGC
		CROSS APPLY
		(
			SELECT COUNT(1) AS CC
			FROM CodingElementGroupComponents Bad_CEGC
				LEFT JOIN @badEmptyVerbatims Bad_CEGC_Verbatims
					ON Bad_CEGC.NameTextID            = Bad_CEGC_Verbatims.GroupVerbatimId 
					AND Bad_CEG.Locale                = Bad_CEGC_Verbatims.Locale
				JOIN CodingElementGroupComponents Good_CEGC
					ON Good_CEGC.CodingElementGroupID = GOOD_CEG.CodingElementGroupID
					AND Good_CEGC.ComponentTypeID     = Bad_CEGC.ComponentTypeID
					AND Good_CEGC.IsSupplement        = Bad_CEGC.IsSupplement
					AND Good_CEGC.NameTextID          = 
						CASE WHEN Bad_CEGC_Verbatims.GroupVerbatimId IS NULL THEN Bad_CEGC.NameTextID
							ELSE 0 -- the new empty verbatim Id
						END
			WHERE Bad_CEG.CodingElementGroupID = Bad_CEGC.CodingElementGroupID
		) AS Matched_CEGC
	WHERE Bad_CEG.CompSuppCount = Matched_CEGC.CC

	SELECT 'Mapped CodingElementGroups conflicts'+CAST(GETUTCDATE() AS VARCHAR)

	-- *** for the unconflicted CEG/CEGCs, just update the groupverbatim/NameText references*** --	
	IF (@mode = 1)
	BEGIN
		UPDATE UnConflicted_CEGC
		SET UnConflicted_CEGC.NameTextID = 0 -- from positive id to 0 (the new id for empty verbatim)
		FROM @badCEG BAD_CEG
			JOIN CodingElementGroups UnConflicted_CEG
				ON BAD_CEG.CodingElementGroupID = UnConflicted_CEG.CodingElementGroupID
			JOIN CodingElementGroupComponents UnConflicted_CEGC
				ON BAD_CEG.CodingElementGroupID = UnConflicted_CEGC.CodingElementGroupID
			JOIN @badEmptyVerbatims BEV
				ON BEV.GroupVerbatimId          = UnConflicted_CEGC.NameTextID
				AND BEV.Locale                  = BAD_CEG.Locale
		WHERE BAD_CEG.ToCodingElementGroupID = -1

		PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' UnConflicted CodingElementGroupComponents entries updated NameTextID to 0'
	END
	ELSE
	BEGIN
		SELECT 'Debug Mode: Total UnConflicted CodingElementGroupComponents entries to update NameTextID to 0', COUNT(UnConflicted_CEGC.CodingElementGroupComponentID)
		FROM @badCEG BAD_CEG
			JOIN CodingElementGroups UnConflicted_CEG
				ON BAD_CEG.CodingElementGroupID = UnConflicted_CEG.CodingElementGroupID
			JOIN CodingElementGroupComponents UnConflicted_CEGC
				ON BAD_CEG.CodingElementGroupID = UnConflicted_CEGC.CodingElementGroupID
			JOIN @badEmptyVerbatims BEV
				ON BEV.GroupVerbatimId          = UnConflicted_CEGC.NameTextID
				AND BEV.Locale                  = BAD_CEG.Locale
		WHERE BAD_CEG.ToCodingElementGroupID = -1
	END

	SELECT 'Dealt with unconflicted CodingElementGroupComponents'+CAST(GETUTCDATE() AS VARCHAR)

	IF (@mode = 1)
	BEGIN
		UPDATE UnConflicted_CEG
		SET UnConflicted_CEG.GroupVerbatimId = BAD_CEG.GroupVerbatimIDToMatch
		FROM @badCEG BAD_CEG
			JOIN CodingElementGroups UnConflicted_CEG
				ON BAD_CEG.CodingElementGroupID = UnConflicted_CEG.CodingElementGroupID
				AND BAD_CEG.GroupVerbatimID     = UnConflicted_CEG.GroupVerbatimID
				AND BAD_CEG.Locale              = UnConflicted_CEG.DictionaryLocale
		WHERE BAD_CEG.ToCodingElementGroupID = -1
			AND BAD_CEG.GroupVerbatimId <> BAD_CEG.GroupVerbatimIDToMatch

		PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' UnConflicted CodingElementGroups entries updated GroupVerbatimId to 0'
	END
	ELSE
	BEGIN
		SELECT 'Debug Mode: Total UnConflicted CodingElementGroups entries to update GroupVerbatimId to 0', COUNT(UnConflicted_CEG.CodingElementGroupID)
		FROM @badCEG BAD_CEG
			JOIN CodingElementGroups UnConflicted_CEG
				ON BAD_CEG.CodingElementGroupID = UnConflicted_CEG.CodingElementGroupID
				AND BAD_CEG.GroupVerbatimID     = UnConflicted_CEG.GroupVerbatimID
				AND BAD_CEG.Locale              = UnConflicted_CEG.DictionaryLocale
		WHERE BAD_CEG.ToCodingElementGroupID = -1
			AND BAD_CEG.GroupVerbatimId <> BAD_CEG.GroupVerbatimIDToMatch
	END

	SELECT 'Dealt with unconflicted CodingElementGroups'+CAST(GETUTCDATE() AS VARCHAR)

	-- ignore Unconflicted CEGs from further processing (as their Ids don't change and no further migration is needed)
	DELETE @badCEG
	WHERE ToCodingElementGroupID = -1

	-- *** STAGE - Synonyms *** --
	DECLARE @badSynonyms TABLE
		(
		OldSynonymId BIGINT PRIMARY KEY, 
		NewSynonymId BIGINT,
		MaxStatus INT, -- if conflict resolve with the higher synonym status (synonym > waiting approval)
		Irreconcilable BIT
		)

	INSERT INTO @badSynonyms (OldSynonymId, NewSynonymId, MaxStatus, Irreconcilable)
	SELECT 
		BAD_SGCP.SegmentedGroupCodingPatternID, 
		ISNULL(Good_SGCP.SegmentedGroupCodingPatternID, -1),
		CASE WHEN Good_SGCP.SegmentedGroupCodingPatternID IS NULL THEN BAD_SGCP.SynonymStatus
			WHEN BAD_SGCP.SynonymStatus > Good_SGCP.SynonymStatus THEN BAD_SGCP.SynonymStatus
			ELSE Good_SGCP.SynonymStatus END,
		0
	FROM SegmentedGroupCodingPatterns BAD_SGCP
		JOIN @badCEG BAD_CEG
			ON BAD_SGCP.CodingElementGroupID  = BAD_CEG.CodingElementGroupID
		LEFT JOIN SegmentedGroupCodingPatterns Good_SGCP
			ON BAD_CEG.ToCodingElementGroupID = Good_SGCP.CodingElementGroupID
			AND BAD_SGCP.SynonymManagementID  = Good_SGCP.SynonymManagementID
			AND BAD_SGCP.CodingPatternId      = Good_SGCP.CodingPatternId

	SELECT 'Mapped affected SegmentedGroupCodingPatterns'+CAST(GETUTCDATE() AS VARCHAR)

	-- map the irreconcilables
	-- these are the ones where the old synonym is not the same with the new synonym
	UPDATE BS
	SET BS.MaxStatus = 0,
		BS.Irreconcilable = 1
	FROM @badSynonyms BS
		JOIN SegmentedGroupCodingPatterns UnConflicted_SGCP
			ON BS.OldSynonymId              = UnConflicted_SGCP.SegmentedGroupCodingPatternID
		JOIN @badCEG BAD_CEG
			ON BAD_CEG.CodingElementGroupID = UnConflicted_SGCP.CodingElementGroupID
	WHERE 
		(
			BS.MaxStatus > 0
			AND EXISTS (SELECT NULL
					FROM SegmentedGroupCodingPatterns SGCP
					WHERE SGCP.SynonymManagementID    = UnConflicted_SGCP.SynonymManagementID
						AND SGCP.CodingElementGroupID = BAD_CEG.ToCodingElementGroupID
						AND SGCP.SegmentedGroupCodingPatternID <> UnConflicted_SGCP.SegmentedGroupCodingPatternID
						AND SGCP.SynonymStatus > 0)
		)

	SELECT 'Mapped irreconcilable SegmentedGroupCodingPatterns'+CAST(GETUTCDATE() AS VARCHAR)

	-- SHOW THE IRRECONCILABLE SYNONYMS
	SELECT 'Irreconcilable SegmentedGroupCodingPatterns ', OldSynonymId
	FROM @badSynonyms
	WHERE Irreconcilable = 1

	-- *** SubSTAGE (1) - Synonyms for which no conflicts arise
	--- migration strategy - update these synonym bad CEGs to good CEGs references
	IF (@mode = 1)
	BEGIN

		UPDATE UnConflicted_SGCP
		SET UnConflicted_SGCP.CodingElementGroupID = BAD_CEG.ToCodingElementGroupID,
			-- downgrade the irreconcilables to non-synonyms
			UnConflicted_SGCP.SynonymStatus        = BAD_Synonyms.MaxStatus
		FROM @badSynonyms BAD_Synonyms
			JOIN SegmentedGroupCodingPatterns UnConflicted_SGCP
				ON BAD_Synonyms.OldSynonymId       = UnConflicted_SGCP.SegmentedGroupCodingPatternID
			JOIN @badCEG BAD_CEG
				ON BAD_CEG.CodingElementGroupID    = UnConflicted_SGCP.CodingElementGroupID
		WHERE BAD_Synonyms.NewSynonymId = -1

		PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' UnConflicted SegmentedGroupCodingPatterns entries updated CodingElementGroupID(s)'
	END
	ELSE
	BEGIN
		SELECT 'Debug Mode: Total UnConflicted SegmentedGroupCodingPatterns entries to update CodingElementGroupID', COUNT(UnConflicted_SGCP.SegmentedGroupCodingPatternId)
		FROM @badSynonyms BAD_Synonyms
			JOIN SegmentedGroupCodingPatterns UnConflicted_SGCP
				ON BAD_Synonyms.OldSynonymId       = UnConflicted_SGCP.SegmentedGroupCodingPatternID
			JOIN @badCEG BAD_CEG
				ON BAD_CEG.CodingElementGroupID    = UnConflicted_SGCP.CodingElementGroupID
		WHERE BAD_Synonyms.NewSynonymId = -1
	END

	-- ignore Unconflicted SGCPs from further processing (as their Ids don't change and no further migration is needed)
	DELETE @badSynonyms
	WHERE NewSynonymId = -1

	SELECT 'Dealt with unconflicted SegmentedGroupCodingPatterns'+CAST(GETUTCDATE() AS VARCHAR)

	-- *** SubSTAGE (2) - Synonyms for which Synonym conflicts arise
	--- migration strategy - Replace old synonym references with new, and delete Old synonyms

	-- must migrate the CodingAssignment & CodingElements & BotElements
	IF (@mode = 1)
	BEGIN
		UPDATE BE
		SET BE.SegmentedCodingPatternId = BS.NewSynonymId
		FROM BOTElements BE
			JOIN @badSynonyms BS
				ON BE.SegmentedCodingPatternId = BS.OldSynonymId
		PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' affected BOTElements entries updated SegmentedCodingPatternId(s)'
	END
	ELSE
	BEGIN
		SELECT 'Debug Mode: Total affected BOTElements entries to updated SegmentedCodingPatternId', COUNT(BE.BotElementId)
		FROM BOTElements BE
			JOIN @badSynonyms BS
				ON BE.SegmentedCodingPatternId = BS.OldSynonymId
	END

	SELECT 'Dealt with affected BOTElements'+CAST(GETUTCDATE() AS VARCHAR)

	IF (@mode = 1)
	BEGIN
		UPDATE CA
		SET CA.SegmentedGroupCodingPatternID = BS.NewSynonymId
		FROM CodingAssignment CA
			JOIN @badSynonyms BS
				ON CA.SegmentedGroupCodingPatternID = BS.OldSynonymId
		PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' affected CodingAssignment entries updated SegmentedGroupCodingPatternID(s)'
	END
	ELSE
	BEGIN
		SELECT 'Debug Mode: Total affected CodingAssignment entries to update SegmentedGroupCodingPatternID', COUNT(CA.CodingAssignmentId)
		FROM CodingAssignment CA
			JOIN @badSynonyms BS
				ON CA.SegmentedGroupCodingPatternID = BS.OldSynonymId
	END

	SELECT 'Dealt with affected CodingAssignment'+CAST(GETUTCDATE() AS VARCHAR)

	IF (@mode = 1)
	BEGIN
		UPDATE CE
		SET CE.AssignedSegmentedGroupCodingPatternId = BS.NewSynonymId
		FROM CodingElements CE
			JOIN @badSynonyms BS
				ON CE.AssignedSegmentedGroupCodingPatternId = BS.OldSynonymId
		PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' affected CodingElements entries updated AssignedSegmentedGroupCodingPatternId(s)'
	END
	ELSE
	BEGIN
		SELECT 'Debug Mode: Total affected CodingElements entries to update AssignedSegmentedGroupCodingPatternId', COUNT(CE.CodingElementId)
		FROM CodingElements CE
			JOIN @badSynonyms BS
				ON CE.AssignedSegmentedGroupCodingPatternId = BS.OldSynonymId
	END

	SELECT 'Dealt with affected CodingElements.AssignedSegmentedGroupCodingPatternId'+CAST(GETUTCDATE() AS VARCHAR)

	IF (@mode = 1)
	BEGIN
		UPDATE SME
		SET SME.SegmentedGroupCodingPatternID = BS.NewSynonymId
		FROM SynonymMigrationEntries SME
			JOIN @badSynonyms BS
				ON SME.SegmentedGroupCodingPatternID = BS.OldSynonymId
		PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' affected SynonymMigrationEntries entries updated SegmentedGroupCodingPatternID(s)'
	END
	ELSE
	BEGIN
		SELECT 'Debug Mode: Total affected SynonymMigrationEntries entries to update SegmentedGroupCodingPatternID', COUNT(SME.SynonymMigrationEntryId)
		FROM SynonymMigrationEntries SME
			JOIN @badSynonyms BS
				ON SME.SegmentedGroupCodingPatternID = BS.OldSynonymId
	END

	SELECT 'Dealt with affected SynonymMigrationEntries'+CAST(GETUTCDATE() AS VARCHAR)

	-- fix - Delete conflicted Synonyms
	IF (@mode = 1)
	BEGIN
		DELETE Delete_SGCP
		FROM SegmentedGroupCodingPatterns Delete_SGCP
			JOIN @badSynonyms LAS
				ON LAS.OldSynonymId = Delete_SGCP.SegmentedGroupCodingPatternID
		PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' affected SegmentedGroupCodingPatterns entries deleted'
	END
	ELSE
	BEGIN
		SELECT 'Debug Mode: Total affected SegmentedGroupCodingPatterns entries to delete', COUNT(Delete_SGCP.SegmentedGroupCodingPatternId)
		FROM SegmentedGroupCodingPatterns Delete_SGCP
			JOIN @badSynonyms LAS
				ON LAS.OldSynonymId = Delete_SGCP.SegmentedGroupCodingPatternID
	END

	SELECT 'Dealt with conflicted SegmentedGroupCodingPatterns'+CAST(GETUTCDATE() AS VARCHAR)

	-- upgrade synonym status
	IF (@mode = 1)
	BEGIN
		UPDATE Upgrade_SGCP
		SET Upgrade_SGCP.SynonymStatus = BS.MaxStatus
		FROM SegmentedGroupCodingPatterns Upgrade_SGCP
			JOIN @badSynonyms BS
				ON BS.NewSynonymId = Upgrade_SGCP.SegmentedGroupCodingPatternID
		PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' affected SegmentedGroupCodingPatterns entries upgraded'
	END
	ELSE
	BEGIN
		SELECT 'Debug Mode: Total affected SegmentedGroupCodingPatterns entries to upgrade', COUNT(Upgrade_SGCP.SegmentedGroupCodingPatternId)
		FROM SegmentedGroupCodingPatterns Upgrade_SGCP
			JOIN @badSynonyms BS
				ON BS.NewSynonymId = Upgrade_SGCP.SegmentedGroupCodingPatternID
	END

	SELECT 'Dealt with upgraded SegmentedGroupCodingPatterns'+CAST(GETUTCDATE() AS VARCHAR)

	-- migrate tasks
	IF (@mode = 1)
	BEGIN
		UPDATE CE
		SET CE.CodingElementGroupId = BAD_CEG.ToCodingElementGroupId
		FROM CodingElements CE
			JOIN @badCEG BAD_CEG
				ON CE.CodingElementGroupId = BAD_CEG.CodingElementGroupId
		PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' affected CodingElements entries updated CodingElementGroupId(s)'
	END
	ELSE
	BEGIN
		SELECT 'Debug Mode: Total affected CodingElements entries to update CodingElementGroupId(s)', COUNT(CE.CodingElementId)
		FROM CodingElements CE
			JOIN @badCEG BAD_CEG
				ON CE.CodingElementGroupId = BAD_CEG.CodingElementGroupId
	END

	SELECT 'Dealt with affected CodingElements.CodingElementGroupId'+CAST(GETUTCDATE() AS VARCHAR)

	-- migrate audits
	IF (@mode = 1)
	BEGIN
		UPDATE WTH
		SET WTH.CodingElementGroupId = BAD_CEG.ToCodingElementGroupId
		FROM WorkflowTaskHistory WTH
			JOIN @badCEG BAD_CEG
				ON WTH.CodingElementGroupId = BAD_CEG.CodingElementGroupId
		PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' affected WorkflowTaskHistory entries updated CodingElementGroupId(s)'
	END
	ELSE
	BEGIN
		SELECT 'Debug Mode: Total affected WorkflowTaskHistory entries to update CodingElementGroupId(s)', COUNT(WTH.CodingElementGroupId)
		FROM WorkflowTaskHistory WTH
			JOIN @badCEG BAD_CEG
				ON WTH.CodingElementGroupId = BAD_CEG.CodingElementGroupId
	END

	SELECT 'Dealt with affected WorkflowTaskHistory'+CAST(GETUTCDATE() AS VARCHAR)

	-- fix - delete bad(old) CEGC
	IF (@mode = 1)
	BEGIN
		DELETE BAD_CEGC
		FROM @badCEG Bad
			JOIN CodingElementGroupComponents BAD_CEGC
				ON Bad.CodingElementGroupID = BAD_CEGC.CodingElementGroupID
		PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' affected CodingElementGroupComponents entries deleted(s)'
	END
	ELSE
	BEGIN
		SELECT 'Debug Mode: Total affected CodingElementGroupComponents entries to delete', COUNT(BAD_CEGC.CodingElementGroupComponentId)
		FROM @badCEG Bad
			JOIN CodingElementGroupComponents BAD_CEGC
				ON Bad.CodingElementGroupID = BAD_CEGC.CodingElementGroupID
	END

	SELECT 'Dealt with conflicted CodingElementGroupComponents'+CAST(GETUTCDATE() AS VARCHAR)

	-- fix - delete bad(old) CEG
	IF (@mode = 1)
	BEGIN
		DELETE BAD_CEG
		FROM @badCEG Bad
			JOIN CodingElementGroups BAD_CEG
				ON Bad.CodingElementGroupID = BAD_CEG.CodingElementGroupID
		PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' affected CodingElementGroups entries deleted(s)'
	END
	ELSE
	BEGIN
		SELECT 'Debug Mode: Total affected CodingElementGroups entries to delete', COUNT(BAD_CEG.CodingElementGroupId)
		FROM @badCEG Bad
			JOIN CodingElementGroups BAD_CEG
				ON Bad.CodingElementGroupID = BAD_CEG.CodingElementGroupID
	END

	SELECT 'Dealt with conflicted CodingElementGroups'+CAST(GETUTCDATE() AS VARCHAR)

	-- fix - remove the bad empty verbatim entry
	IF (@mode = 1)
	BEGIN
		DELETE GroupVerbatimEng
		WHERE VerbatimText = ''
			AND GroupVerbatimId > 0
		PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' affected GroupVerbatimEng entries deleted(s)'
	END
	ELSE
	BEGIN
		SELECT 'Debug Mode: Total affected GroupVerbatimEng entries to delete', COUNT(GroupVerbatimId)
		FROM GroupVerbatimEng
		WHERE VerbatimText = ''
			AND GroupVerbatimId > 0
	END

	IF (@mode = 1)
	BEGIN
		DELETE GroupVerbatimJpn
		WHERE VerbatimText = N''
			AND GroupVerbatimId > 0
		PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' affected GroupVerbatimJpn entries deleted(s)'
	END
	ELSE
	BEGIN
		SELECT 'Debug Mode: Total affected GroupVerbatimJpn entries to delete', COUNT(GroupVerbatimId)
		FROM GroupVerbatimJpn
		WHERE VerbatimText = N''
			AND GroupVerbatimId > 0
	END

	SELECT 'Finished'+CAST(GETUTCDATE() AS VARCHAR)

END