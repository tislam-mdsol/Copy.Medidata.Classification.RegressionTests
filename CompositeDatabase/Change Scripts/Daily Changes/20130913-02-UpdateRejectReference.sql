--1. update rejectcoding workflow system action to openquery
Update WorkflowSystemActionR
Set ActionName='OpenQuery'
Where ActionName = 'RejectCoding'

--2. exisiting WorkflowActions 
-- create cursor over all segments  
Declare @segmentId INT  
DECLARE curSegment CURSOR FOR
	SELECT SegmentID FROM Segments

OPEN curSegment
FETCH curSegment INTO @segmentId
WHILE (@@FETCH_STATUS = 0) BEGIN

	Declare @OpenQueryActionNameId INT
	EXEC dbo.spLclztnFndOrInsrtDtStrng 'Open Query', 'eng', @OpenQueryActionNameId OUTPUT, @segmentId

	Update WorkflowActions
	Set OID ='Open Query', NameID = @OpenQueryActionNameId 
	Where OID ='Reject Term' and SegmentId = @segmentId
	
	FETCH curSegment INTO @segmentId
END -- while

CLOSE curSegment
DEALLOCATE curSegment




