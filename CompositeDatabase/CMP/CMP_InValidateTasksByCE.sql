
/*
sample execution

begin tran
exec CMP_InValidateTasksByCE 'Sanofi-Cov', 12345, '181870,181871,181872,181873'
rollback


*/

if exists (select * from sysobjects where name = 'CMP_InValidateTasksByCE')
	drop procedure CMP_InValidateTasksByCE
go
create PROCEDURE CMP_InValidateTasksByCE
(
	@segmentName VARCHAR(250),
	@WRNumber INT,
	@commaDelimitedCEIDs NVARCHAR(MAX)
)
AS
BEGIN
	DECLARE
		@segmentId INT,
		@startId INT,
		@errorString NVARCHAR(MAX),
		@runDT DATETIME=GETUTCDATE(),
		@comment NVARCHAR(MAX)
	
	DECLARE @TasksToUpdate TABLE (CodingElementId varchar(20) PRIMARY KEY, SegmentID INT)
 
	SET @comment = 'Task invalidated (WR ' + cast(@WRNumber as nvarchar(max)) + ').'
 
	-- DROP TABLE BK_CMP_InvalidatedTasks
	IF NOT EXISTS (SELECT * FROM SYSOBJECTS WHERE NAME = 'BK_CMP_InvalidateTasks')
	CREATE TABLE BK_CMP_InvalidatedTasks (
		WRNumber INT,
		CodingElementId INT,
		Updated DATETIME,
		IsClosed bit,
		RunDT DATETIME
	)
 
	SELECT @segmentId = SegmentId 
	FROM Segments

	WHERE SegmentName = @segmentName
	IF (@segmentId IS NULL)
	BEGIN
		SELECT 'Cannot find Segment'
		RETURN 0
	END
	
	INSERT INTO @TasksToUpdate (CodingElementId, SegmentId)
	SELECT
		replace(replace(item,char(10),''),char(13),'') as CodingElementId, -1
	FROM 
		dbo.fnParseDelimitedString(@commaDelimitedCEIDs,',')
	
	UPDATE @TasksToUpdate SET
		SegmentId = CE.SegmentId
	FROM @TasksToUpdate T
	JOIN CodingElements CE ON CE.SegmentId = @SegmentId and CE.CodingElementID  = T.CodingElementId
	
	IF EXISTS (SELECT NULL FROM @TasksToUpdate WHERE SegmentId <> @SegmentID)
	BEGIN
		SET @errorString = N'ERROR: CodingElements are not in segment or do not exist!'
		SELECT * FROM @TasksToUpdate WHERE SegmentId <> @SegmentID
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END
	
	INSERT INTO dbo.WorkflowTaskHistory (
        WorkflowTaskID, WorkflowStateID, WorkflowActionID, WorkflowSystemActionID, UserID, WorkflowReasonID,
	Comment, Created, SegmentId, CodingAssignmentId, CodingElementGroupId, QueryId)

	SELECT 
		CE.CodingElementId, CE.WorkflowStateID, NULL, NULL, -2, NULL, 
		@Comment, @runDT, CE.SegmentId, CA.CodingAssignmentID, CE.CodingElementGroupID, 0
	FROM @TasksToUpdate T
	JOIN CodingElements CE ON CE.CodingElementId = T.CodingElementId
	LEFT JOIN CodingAssignment CA ON CA.CodingElementId = CE.CodingElementId and CA.Active = 1
	WHERE CE.IsInvalidTask = 0
	
	INSERT INTO BK_CMP_InvalidatedTasks ( 	
		WRNumber, CodingElementId, Updated, IsClosed, RunDT)
	SELECT
		@WRNumber, CE.CodingElementId, CE.Updated, CE.IsClosed, @RunDT
	FROM @TasksToUpdate T
	JOIN CodingElements CE ON CE.CodingElementId = T.CodingElementId
	WHERE CE.IsInvalidTask = 0

	UPDATE CA SET	
		Active = 0,
		Updated = @runDT
	FROM @TasksToUpdate T
	JOIN CodingElements CE ON CE.CodingElementId = T.CodingElementId
	JOIN CodingAssignment CA ON CA.CodingElementId = CE.CodingElementId 
	WHERE CE.IsInvalidTask = 0
		AND CA.active = 1
	
	UPDATE CE SET	
		IsInvalidTask = 1,
		IsClosed = 1,
		Updated = @runDT,
		CacheVersion = CacheVersion + 10
	FROM @TasksToUpdate T
	JOIN CodingElements CE ON CE.CodingElementId = T.CodingElementId
	WHERE CE.IsInvalidTask = 0
/*
	SELECT CE.* 
	FROM @TasksToUpdate T
	JOIN CodingElements CE 
	ON CE.CodingElementId = T.CodingElementId
	ORDER BY CE.CodingElementId
	SELECT CA.* 
	FROM @TasksToUpdate T
	JOIN CodingAssignment CA
	ON CA.CodingElementId = T.CodingElementId
	ORDER BY CA.CodingElementId
*/

	SELECT WFH.*
	FROM @TasksToUpdate T
	JOIN WorkflowTaskHistory WFH on WFH.WorkflowTaskId = T.CodingElementId
	WHERE WFH.Created = @RunDT
	ORDER BY WFH.WorkflowTaskId

	SELECT * FROM BK_CMP_InvalidatedTasks
	WHERE RunDT = @RunDT
	
	PRINT 'Invalidate tasks succeeded!'	 
END