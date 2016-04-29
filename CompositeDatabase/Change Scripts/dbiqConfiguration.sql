SET NOCOUNT ON 
GO

-- setup the main coderconfiguration
INSERT INTO CoderAppConfiguration (IsProduction, Active) VALUES(0, 1)

CREATE TABLE #Configuration 
(
	id              int IDENTITY,
	Tag 			varchar(64) NOT NULL,
	ConfigValue 	varchar(1024) NOT NULL,
	Action		    varchar(15) NOT NULL	
)

-- DO NOT WRITE ABOVE THIS LINE

--INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('DatabaseVersion', '1.0.0.0', '-INSERT-')

INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('SecurityAllTrackableObjectsID', '-105', '-INSERT-')
INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('DefaultLocale', 'eng', '-INSERT-')
INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('SessionTimeout', '30', '-INSERT-')
INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('AddSynonymOnAutoCoding', 'No', '-INSERT-')
INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('MaxHitSearchReturn', '250', '-INSERT-')
INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('MaxSuggestionReturn', '20', '-INSERT-')
INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('MinSearchRank', '20', '-INSERT-')
INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('DefaultTermWeight', '100', '-INSERT-')
INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('ComponentDefaultValueWeight', '	25', '-INSERT-')
INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('CodingTaskPageSize', '10', '-INSERT-')
INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('CodingSuggestionPageSize', '10', '-INSERT-')
INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('DateTimeFormat', 'dd MMM yyyy HH:nn:ss', '-INSERT-')
INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('DateFormat', 'dd MMM yyyy', '-INSERT-')
INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('NoRetriesTransmission', '5', '-INSERT-')
INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('NoRetriesSendEmail', '1', '-INSERT-')
INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('ForcePrimaryPathSelection', 'No', '-INSERT-')
INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('ForcePreferredNameSelection', 'No', '-INSERT-')
INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('SearchLimitReclassificationResult', '100', '-INSERT-')

-- possible values in SynonymCreationPolicyEnum (1: AlwaysActive)
INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('SynonymCreationPolicyFlag', '1', '-INSERT-')

INSERT INTO [#Configuration] ([Tag], [ConfigValue], [Action]) VALUES('BypassReconsiderUponReclassifyFlag', 'No', '-INSERT-')

-- DO NOT WRITE BELOW THIS LINE

IF EXISTS(
	SELECT Tag
	FROM [#Configuration]
	GROUP BY Tag
	HAVING COUNT(*) > 1
)
BEGIN
	-- will return duplicate entries
	SELECT * FROM [#Configuration]
	WHERE Tag IN
	(
		SELECT Tag
		FROM [#Configuration]
		GROUP BY Tag
		HAVING COUNT(*) > 1
	)
	ORDER BY Tag

	RAISERROR ('The script contains duplicate entries (see the recordset). Remove duplicates and re-run the script. Script aborted', 16, 1)
END
ELSE
BEGIN

	;WITH SegmentsInConfig (SegmentID)
	AS
	(SELECT DISTINCT SegmentID FROM Configuration)


	-- Insert into Configuration those entries 
	-- from [#Configuration] that are missing from Configuration
	INSERT INTO Configuration(Tag, ConfigValue, Created, Updated, SegmentID)
	SELECT tmp.Tag, tmp.ConfigValue, GETUTCDATE(), GETUTCDATE(), SIC.SegmentID
	FROM [#Configuration] tmp
		LEFT JOIN Configuration C ON
			tmp.Tag = C.Tag COLLATE SQL_Latin1_General_CP1_CI_AS 
		LEFT JOIN SegmentsInConfig SIC
			ON SIC.SegmentID > 0
	WHERE C.Tag IS NULL
	-- Update those records in Configuration that exists in
	-- #Configuration and are marked with with Action = '-UPDATE-'
	UPDATE Configuration
	SET 
		ConfigValue = tmp.ConfigValue,
		Updated = GETUTCDATE()
	FROM #Configuration tmp
		LEFT JOIN Configuration C ON
			tmp.Tag = C.Tag COLLATE SQL_Latin1_General_CP1_CI_AS 
	WHERE C.Tag IS NOT NULL
	AND UPPER(tmp.Action) = '-UPDATE-'
	-- Delete those records in Configuration that exists in
	-- #Configuration and are marked with Action = '-DELETE-'
	DELETE Configuration
	FROM #Configuration tmp
		LEFT JOIN Configuration C ON
			tmp.Tag = C.Tag COLLATE SQL_Latin1_General_CP1_CI_AS 
	WHERE C.Tag IS NOT NULL
	AND UPPER(tmp.Action) = '-DELETE-'
END
DROP TABLE #Configuration 