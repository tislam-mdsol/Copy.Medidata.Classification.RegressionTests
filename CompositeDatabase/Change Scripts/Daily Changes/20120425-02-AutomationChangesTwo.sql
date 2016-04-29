BEGIN TRY
-- 5. run transition script (TODO : eval how long this might take)
EXEC dbo.spCodingElementGroupToGroupVerbatim
-- 6.1 update CodingElementGroups indices that need it first
IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_CodingElementGroups_Multi')
	DROP INDEX CodingElementGroups.IX_CodingElementGroups_Multi

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_CodingElementGroups_VerbatimKey')
	ALTER TABLE CodingElementGroups
	DROP CONSTRAINT DF_CodingElementGroups_VerbatimKey

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'CodingElementGroups'
			AND COLUMN_NAME = 'VerbatimKey')
	ALTER TABLE CodingElementGroups
	DROP COLUMN VerbatimKey
	
IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'CodingElementGroups'
			AND COLUMN_NAME = 'VerbatimText')
	ALTER TABLE CodingElementGroups
	DROP COLUMN VerbatimText

-- 7. create unique constraint on verbatim(s)
-- 7.1 English
IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_GroupVerbatimEng_Verbatim')
	DROP INDEX GroupVerbatimEng.IX_GroupVerbatimEng_Verbatim
-- TODO : this may be a bit too much
CREATE UNIQUE NONCLUSTERED INDEX IX_GroupVerbatimEng_Verbatim ON [dbo].GroupVerbatimEng 
(
	VerbatimText ASC
)
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

-- 7.2 Japanese
IF EXISTS (SELECT NULL FROM sys.indexes
	WHERE name = 'IX_GroupVerbatimJpn_Verbatim')
	DROP INDEX GroupVerbatimJpn.IX_GroupVerbatimJpn_Verbatim

CREATE UNIQUE NONCLUSTERED INDEX IX_GroupVerbatimJpn_Verbatim ON [dbo].GroupVerbatimJpn 
(
	VerbatimText ASC
)
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


-- migrate to synonym lists/coding rules
EXEC dbo.spSynonymManagementsToLists

IF EXISTS (SELECT NULL FROM sys.default_constraints
	WHERE name = 'DF_SegmentedGroupCodingPatterns_UserId')
	ALTER TABLE SegmentedGroupCodingPatterns
	DROP CONSTRAINT DF_SegmentedGroupCodingPatterns_UserId

IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'SegmentedGroupCodingPatterns'
			AND COLUMN_NAME = 'UserID')
	ALTER TABLE SegmentedGroupCodingPatterns
	DROP COLUMN UserID

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'SegmentedGroupCodingPatterns'
			AND COLUMN_NAME = 'UserId')
	ALTER TABLE SegmentedGroupCodingPatterns
	ADD UserID INT NOT NULL CONSTRAINT DF_SegmentedGroupCodingPatterns_UserId DEFAULT (-2)

-- migrate project registrations & studydictionary versions
EXEC dbo.spProjectStudyRegistrationTransition
-- migrate version ordinals
EXEC dbo.spVersionOrdinalToId

END TRY
BEGIN CATCH
		DECLARE	@ErrorSeverity int, 
			@ErrorState int,
			@ErrorLine int,
			@ErrorMessage nvarchar(4000),
			@ErrorProc nvarchar(4000)

		SELECT @ErrorSeverity = ERROR_SEVERITY(),
			@ErrorState = ERROR_STATE(),
			@ErrorLine = ERROR_LINE(),
			@ErrorMessage = ERROR_MESSAGE(),
			@ErrorProc = ERROR_PROCEDURE()
		SELECT @ErrorMessage = coalesce(@ErrorProc, '20120425-02-AutomationChangesTwo.sql') + ' (' + cast(@ErrorLine as nvarchar) + '): ' + @ErrorMessage

		RAISERROR (@ErrorMessage,  @ErrorSeverity, @ErrorState);
END CATCH
