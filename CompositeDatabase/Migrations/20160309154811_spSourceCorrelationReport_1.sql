-- EXEC spSourceCorrelationReport 'MedidataReserved1', ''
-- EXEC spSourceCorrelationReport 'Coder Performance TestSegment 01', 'ST01Migration'

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSourceCorrelationReport')
	DROP PROCEDURE spSourceCorrelationReport
GO
CREATE PROCEDURE dbo.spSourceCorrelationReport
(
	-- Requirement 1 - Scoped in Segment
	@SegmentName NVARCHAR(255),
	-- Requirement 2 - Optionally scoped in Study
	@StudyName NVARCHAR(2000) = ''
)
AS
BEGIN
	
	SET NOCOUNT ON

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	-- verify params	
	DECLARE @SegmentId INT,
		@studyID INT

	SELECT @SegmentId = SegmentId
	FROM Segments
	WHERE SegmentName = @SegmentName

	IF (@SegmentId IS NULL)
	BEGIN
		RAISERROR(N'ERROR: No such Segment!', 16, 1)
		RETURN 0
	END

	IF (@StudyName = '')
	BEGIN
		-- no study scope
		SET @studyID = 0
	END
	ELSE
	BEGIN
		
		-- have study scope
		SELECT @studyID = TrackableObjectId
		FROM TrackableObjects
		WHERE ExternalObjectName = @StudyName
			AND SegmentId = @SegmentId

		IF (@studyID IS NULL)
		BEGIN
			RAISERROR(N'ERROR: No such Study!', 16, 1)
			RETURN 0
		END

	END

	DECLARE @sdvTable TABLE(Id INT, DictionaryLocale CHAR(3), SerializedDescription NVARCHAR(1000), StudyName NVARCHAR(500))

	INSERT INTO @sdvTable (Id, DictionaryLocale, SerializedDescription, StudyName)
	SELECT StudyDictionaryVersionID, DictionaryLocale
		,'Dictionary: '+ DR.OID + '  Version: '+ DVR.OID + '  Locale: ' +  DictionaryLocale
		, T.ExternalObjectName
	FROM StudyDictionaryVersion SDV
		JOIN DictionaryVersionRef DVR
			ON SDV.DictionaryVersionId = DVR.DictionaryVersionRefID
		JOIN DictionaryRef DR
			ON DR.DictionaryRefID = DVR.DictionaryRefID
		JOIN TrackableObjects T
			ON T.TrackableObjectID = SDV.StudyID
	WHERE SDV.SegmentID = @SegmentId
		AND @studyID IN (0, StudyID)
		AND T.IsTestStudy = 0   -- KG edit 8/22
	
	CREATE TABLE #CodingElementSourceProperties(
		CodingElementSourcePropertyId INT NOT NULL IDENTITY(1,1),
		CodingElementId INT NOT NULL,
		CodingRequestId INT NOT NULL,

		StudyOID VARCHAR(51) NOT NULL,
		SubjectKey NVARCHAR(51) NOT NULL,
		SiteOID NVARCHAR(51) NOT NULL,
		StudyEventOID VARCHAR(101) NOT NULL,
		StudyEventRepeatKey VARCHAR(101) NOT NULL,
		FormOID VARCHAR(101) NOT NULL,
		FormRepeatKey VARCHAR(101) NOT NULL,
		ItemGroupOID VARCHAR(101) NOT NULL,
		ItemGroupRepeatKey VARCHAR(11) NOT NULL,
		ItemOID VARCHAR(101) NOT NULL,
		SourceIdentifier VARCHAR(101) NOT NULL,

		Truncated SMALLINT NOT NULL CONSTRAINT DF_CodingElementSourceProperties_Truncated DEFAULT (-1),
		IsChainTruncated BIT NOT NULL CONSTRAINT DF_CodingElementSourceProperties_IsChainTruncated DEFAULT (0),

		CodingElementSourceKeyId INT NOT NULL CONSTRAINT DF_CodingElementSourceProperties_CodingElementSourceKeyId DEFAULT (-1),
		NextCodingElementId INT NOT NULL CONSTRAINT DF_CodingElementSourceProperties_NextCodingElementId DEFAULT (-1),

		CONSTRAINT [PK_CodingElementSourceProperties] PRIMARY KEY CLUSTERED 
		(
			[CodingElementSourcePropertyId] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	)
	
	CREATE NONCLUSTERED INDEX IX_CodingElementSourceProperties_CodingElementId
	ON #CodingElementSourceProperties (CodingElementId)
	
	CREATE NONCLUSTERED INDEX IX_CodingElementSourceProperties_CodingRequestId
	ON #CodingElementSourceProperties (CodingRequestId)
	
	CREATE NONCLUSTERED INDEX IX_CodingElementSourceProperties_CodingElementSourceKeyId
	ON #CodingElementSourceProperties (CodingElementSourceKeyId)
	

	-- perform the correlation
	EXEC spPerformSourceCorrelation @SegmentName

	-- Requirement 6 : Report the properties in the following order
	DECLARE @Delim CHAR(3) = '|&|'	-- KG edit 8/22

	SELECT
		CAST(CESP.CodingElementId AS NVARCHAR(50)) + @Delim +
		CAST(CESP.CodingRequestId AS NVARCHAR(50)) + @Delim +
		StudyName + @Delim +
		CESP.StudyOID + @Delim +
		CE.SourceSite + @Delim +
		CESP.SubjectKey + @Delim +
		CE.SourceForm + @Delim +
		CESP.StudyEventOID + @Delim +
		CESP.FormOID + @Delim +
		CESP.FormRepeatKey + @Delim +
		CE.SourceField + @Delim +
		dbo.fnCleanVerbatimForCorrelation(CE.VerbatimTerm) + @Delim +
		CESP.ItemGroupRepeatKey + @Delim +
		Cesp.StudyEventRepeatKey + @Delim +
--		dbo.fnLDS(WorkflowStateNameID, 'eng') + @Delim +
		dbo.fnWorkflowState( CE.WorkflowStateID ) + @Delim +

		CE.UUID
		AS 'Output'
	FROM CodingElements CE
		JOIN @sdvTable SDV
			ON SDV.Id = CE.StudyDictionaryVersionId
		JOIN #CodingElementSourceProperties CESP
			ON CESP.CodingElementId = CE.CodingElementId
			-- only the last ones
			AND CESP.NextCodingElementId = -1
	where dbo.fnWorkflowState( CE.WorkflowStateID ) != 'Completed'
/*
		CROSS APPLY
		(
			SELECT *
			FROM WorkflowStates WSI
			WHERE WSI.WorkflowStateId = CE.WorkflowStateID
				AND dbo.fnLDS(WSI.WorkflowStateNameID, 'eng') != 'Completed'  -- KG edit 8/22
		) AS WS
*/
		--CROSS APPLY
		--(
		--	SELECT 
		--		'|' +
		--		SupplementTermKey
		--		+ '|' +
		--		SupplementalValue
		--	FROM CodingSourceTermSupplementals
		--	WHERE CodingSourceTermID = CE.CodingElementId
		--	ORDER BY Ordinal ASC
		--	FOR XML PATH('')
		--) Supp (list)
		--CROSS APPLY
		--(
		--	SELECT 
		--		'|' +
		--		ComponentName
		--		+ '|' +
		--		ComponentValue
		--	FROM CodingSourceTermComponents
		--	WHERE CodingSourceTermID = CE.CodingElementId
		--	ORDER BY Ordinal ASC
		--	FOR XML PATH('')
		--) Comp (list)

		DROP TABLE #CodingElementSourceProperties
END
GO 
