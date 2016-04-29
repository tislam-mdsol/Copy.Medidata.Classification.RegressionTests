
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementLoadTaskFilters')
	DROP Procedure spCodingElementLoadTaskFilters
GO

/* 1/15/2013 - CONNOR ROSS cross@mdsol.com
//
// TECH-DEBT: Study Lock number is not being passed in for study migration enum
// TECH-DEBT: UDT is not being used for @studyDictionaryIds
//
// NOTE: If you update this file you must review:
//			1. spCodingElementGetFilterValuesGroup.sql
//			2. spCodingElementGetNextTaskToCodeWithFilterSort.sql
//			3. spCodingElementLoadTaskFilters.sql
//			5. spCodingElementSearchByFilterSecuredAndPagedWithFilterAndGroup.sql
*/

create procedure [dbo].spCodingElementLoadTaskFilters
(
	@TrackableObjectIds varchar(max),
	-- View Options
	@InService INT = 0,					-- 0: Not in service, 1: In Service, -1: Either
	@WorkflowStates NVARChAR(MAX),		-- comma seperated list of worflow state ids, '-1': All workflow states
	@InStudyMigration BIT,					-- 1: In Study Migration, 0: All others study status
	@SegmentId INT
)
as
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL	READ UNCOMMITTED

	DECLARE @TrackableObjects TABLE(TrackableObjectId INT PRIMARY KEY)
	DECLARE @workflowStateIds TABLE (WorkflowStateId INT PRIMARY KEY)
	
	INSERT INTO @TrackableObjects(TrackableObjectId) 
	SELECT item
	FROM dbo.fnParseDelimitedString(@TrackableObjectIds,',')
	
	INSERT INTO @workflowStateIds(WorkflowStateId)
	SELECT * FROM dbo.fnParseDelimitedString(@WorkflowStates,',')
		
	DECLARE @SkipWorkflowStates BIT
	IF EXISTS(SELECT NULL FROM @workflowStateIds WHERE WorkflowStateId > 0)
	BEGIN
		SET @SkipWorkflowStates = 0
	END
	ELSE
	BEGIN
		SET @SkipWorkflowStates = 1
	END
	
	IF NOT EXISTS (SELECT NULL FROM @TrackableObjects
		WHERE TrackableObjectId > 0)
		RETURN
		
	DECLARE @dataTable TABLE(SourceId INT, TrackableID INT, IsTest Bit, TotalCount INT)
	
	DECLARE @studyMap TABLE(StudyId INT, SdvId INT PRIMARY KEY)
	
	INSERT INTO @studyMap (StudyId, SdvId)
	SELECT  
		Tr.TrackableObjectID,
		sdv.StudyDictionaryVersionID
	FROM @TrackableObjects t1  
		JOIN TrackableObjects Tr   
			ON t1.TrackableObjectId = Tr.TrackableObjectID   
		JOIN StudyDictionaryVersion SDV
			ON Tr.TrackableObjectID = SDV.StudyID
			AND SDV.SegmentID = @SegmentId
			AND ((@InStudyMigration = 0 AND StudyLock <> 3) OR (@InStudyMigration = 1 AND StudyLock = 3))

	INSERT INTO @dataTable(SourceId, TrackableID, TotalCount)
	SELECT 		
		e.SourceSystemId,  
		x.StudyId,  
		COUNT(*) 
	FROM @studyMap x
		JOIN CodingElements e  
			ON e.StudyDictionaryVersionId = x.SdvId
			AND @InService IN (-1, e.IsStillInService) -- avoid those still in service  
			AND e.IsClosed = 0 -- avoid done items
			AND (@SkipWorkflowStates = 1 OR e.WorkflowStateId IN (SELECT WorkFlowStateId FROM @workflowStateIds))
	 GROUP BY  
		e.SourceSystemId,
		x.StudyId  
	 OPTION (RECOMPILE)	 
	 
	 -- OPT  
	UPDATE D  
	SET IsTest = Tr.IsTestStudy  
	FROM @dataTable D  
		JOIN TrackableObjects Tr   
			ON D.TrackableID = Tr.TrackableObjectID

	SELECT 
		CASE WHEN IsTest = 1 THEN 'TestStudyTaskCount'
			ELSE 'ProdStudyTaskCount'
		END AS FilterName, 
		-1 AS ID, 
		'' AS ExternalObjectName, 
		SUM(TotalCount) AS TaskCount
	FROM @dataTable
	GROUP BY IsTest
	UNION
	SELECT
		FilterName, ID, AP.Name AS ExternalObjectName, TaskCount
	FROM
	(
		SELECT 'SourceSystem' AS FilterName, SourceId AS ID, SUM(TotalCount) AS TaskCount
		FROM @dataTable
		GROUP BY SourceId
	) X
		JOIN Application AP
			ON AP.SourceSystemID = X.ID
	UNION
	SELECT
		FilterName, ID, Tr.ExternalObjectName, TaskCount
	FROM
	(
		SELECT 'Study' AS FilterName, TrackableID AS ID, SUM(TotalCount) AS TaskCount
		FROM @dataTable
		GROUP BY TrackableID
	) X
		JOIN TrackableObjects Tr
			ON Tr.TrackableObjectID = X.ID

END
 