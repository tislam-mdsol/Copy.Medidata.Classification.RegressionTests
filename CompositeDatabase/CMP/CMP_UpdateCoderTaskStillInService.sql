

if exists (select * from sysobjects where name = 'CMP_UpdateCoderTaskStillInService')
	drop procedure CMP_UpdateCoderTaskStillInService
go

/*********************************************************************************************
-- Author:			Prathyusha Muddasani
-- Created:			6 Mar 2016
-- Description:		Clear IsStillInService bit on Coder Tasks that are stuck.


select s.segmentname, * from codingelements ce
join segments s on s.segmentid = ce.segmentid
 where isstillinservice = 1


begin transaction
exec CMP_UpdateCoderTaskStillInService
	@SegmentName = 'mundipharma',
	@WRNumber = 12345,
	@commaDelimitedCEs = '9047929,8992227,9033482'
rollback

begin transaction
exec CMP_UpdateCoderTaskStillInService
	@SegmentName = 'CODER_AZ1_PILOT1',
	@WRNumber = 12345,
	@commaDelimitedCEs = '3,28,30'
rollback

**********************************************************************************************/
CREATE PROCEDURE CMP_UpdateCoderTaskStillInService
(
	@segmentName VARCHAR(250),
	@WRNumber INT,
	@commaDelimitedCEs NVARCHAR(MAX)
)
AS
BEGIN
		DECLARE @TasksToUpdate TABLE (CodingElementId INT PRIMARY KEY, SegmentID INT, IsStillInService bit )
		DECLARE @segmentId INT,
				@WFHComment NVARCHAR(MAX),
				@errorString NVARCHAR(MAX)
		DECLARE @UtcTime DATETIME=GETUTCDATE()

		
		SET @WFHComment ='Cleared IsStillInService bit (' + Convert(varchar(20), @WRNumber) + ').'
		
		SELECT @segmentId = SegmentId 
		FROM Segments
		WHERE SegmentName = @segmentName


		IF (@segmentId IS NULL)
		BEGIN
			SELECT 'Cannot find Segment'
			RETURN 0
		END

		INSERT INTO @TasksToUpdate 
			(
				CodingElementId,
				SegmentId,
				IsStillInService		
			)
		SELECT
			item,-1,0
		FROM dbo.fnParseDelimitedString(@commaDelimitedCEs,',')
   
		UPDATE @TasksToUpdate
		SET SegmentId = CE.SegmentId
		FROM @TasksToUpdate t
		INNER JOIN CodingElements CE
		ON CE.SegmentId = @SegmentId and CE.CodingElementId  = t.CodingElementId

		IF EXISTS (SELECT NULL FROM @TasksToUpdate WHERE SegmentId <> @SegmentID)
		BEGIN
			SET @errorString = N'ERROR: CodingElements are not in segment or do not exist!'
			SELECT * FROM @TasksToUpdate WHERE SegmentId <> @SegmentID
			RAISERROR(@errorString, 16, 1)
			RETURN 1
		END	
 
		UPDATE @TasksToUpdate
		SET IsStillInService = CE.IsStillInService
		FROM @TasksToUpdate t
		INNER JOIN CodingElements CE ON CE.CodingElementId  = t.CodingElementId
		
			
		IF EXISTS (SELECT NULL FROM @TasksToUpdate WHERE IsStillInService = 0)
		BEGIN
			SET @errorString = N'NOTE: CodingElements not in Service.'
			SELECT * FROM @TasksToUpdate T WHERE T.IsStillInService = 0
			PRINT @errorString
			-- CONTINUE, EXCLUDING VALID CODINGELEMENTS
		END
		

		UPDATE CE 
		SET
			IsStillInService = 0,
			Updated = @UtcTime,
			CacheVersion = CacheVersion + 10

		OUTPUT INSERTED.CodingElementId, INSERTED.WorkflowStateID, -2, @WFHComment, @UTCTime, INSERTED.SegmentID, INSERTED.CodingElementGroupID
		INTO WorkflowTaskHistory (WorkflowTaskID, WorkflowStateID, UserID, Comment, Created, SegmentId, CodingElementGroupId)

		FROM @TasksToUpdate T
			JOIN CodingElements CE 
			ON CE.CodingElementId = T.CodingElementId
		WHERE T.IsStillInService=1  and CE.SegmentId=@SegmentId
			  and DateDiff(HH,CE.Updated,@UtcTime)>=12
	

		PRINT 'IsStillInService update tasks succeeded!'

		SELECT CE.* 
		FROM @TasksToUpdate T
		JOIN CodingElements CE 
		ON CE.CodingElementId = T.CodingElementId
		WHERE T.IsStillInService=1 
			and CE.SegmentId=@SegmentId
			and CE.IsStillInService=0
		ORDER BY CE.CodingElementId

		SELECT WFH.*
		FROM @TasksToUpdate T
		JOIN WorkflowTaskHistory WFH on WFH.WorkflowTaskId = T.CodingElementId
		WHERE WFH.Created = @UtcTime and T.IsStillInService=1  and WFH.SegmentId=@SegmentId
		ORDER BY WFH.WorkflowTaskId
END