/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2014, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Bonnie Pan@mdsol.com
//
//
//  This CMP is to invalidate tasks by correlating information given from Rave
// 
//	CREATE TABLE TermInRave
// (
//	SiteName nvarchar(max),
//	SubjectName nvarchar(max),
//	FolderOid nvarchar(max),
//	FormName nvarchar(max),
//	FieldOid nvarchar(max),
//	LogLine nvarchar(max),
//	Verbatim nvarchar(max)
//);
*/
    
	DECLARE @StudyUUID VARCHAR(100)='f9d957c6-799b-4216-9955-da4fabc3272e'
	DECLARE @WorkflowTaskHistoryComment VARCHAR(450) ='InValidate tasks requested by Client via CMP 6/26/2014'
	DECLARE @DateCreated DateTime ='2014-04-29'
    
	DECLARE @StudyID BIGINT, @SegmentId INT
	
	SELECT @StudyID = TrackableObjectID, @SegmentId=SegmentId
	FROM TrackableObjects
	WHERE ExternalObjectId = @StudyUUID 

	IF (@StudyID IS NULL)
	BEGIN
		DECLARE @errorString NVARCHAR(MAX)=  N'Study not found: StudyUUID: ' + @StudyUUID
	    PRINT @errorString
	    RAISERROR(@errorString, 16, 1)
		RETURN
	END

	-------Data From Rave-------------
	IF object_id('tempdb..#TermInRave') IS NOT NULL
	BEGIN
		 DROP TABLE #TermInRave;
	END
	----------------------------------
CREATE TABLE #TermInRave
 (
	SiteName nvarchar(max),
	SubjectName nvarchar(max),
	FolderOid nvarchar(max),
	FormName nvarchar(max),
	FieldOid nvarchar(max),
	LogLine nvarchar(max),
	Verbatim nvarchar(max)
);	

--Rave data provided by Rave support
--	INSERT INTO #TermInRave(SiteName, SubjectName,FolderOid,FormName,FieldOid,LogLine,Verbatim)
--Values
--('202 Dana-Farber Cancer Institute','202214','OTH','Prior and Concomitant Medications','CMDRUG','5','Krill oil')
-----------------------------------------------------------------------------------------------------------------------------

	-- Determine tasks to update
	DECLARE @TasksToUpdate TABLE (CodingElementId INT, CodingElementGroupID INT)

	DECLARE @WaitingManualCodeStatusId INT = (SELECT WorkflowStateID FROM WorkflowStates WHERE segmentId=@SegmentId and dbo.fnLDS(WorkflowStateNameID,'eng')='Waiting Manual Code')
	
	;WITH TasksToInvalidate
	AS(
	SELECT CE.CodingElementId, CE.CodingElementGroupID 
	FROM #TermInRave C
	    JOIN CodingElements CE
	        ON C.Verbatim     = CE.VerbatimTerm 
	        AND C.FormName    = CE.SourceForm 
	        AND C.SubjectName = CE.SourceSubject 
	        AND C.FieldOid    = CE.SourceField
            AND C.LogLine     = CE.SourceLine
            AND C.FolderOid   = CE.SourceEvent 
            AND C.SiteName    = CE.SourceSite
    WHERE SegmentId = @SegmentId 
	    AND CE.Created > @DateCreated And CE.Created < DATEADD(day,1,@DateCreated)
	    AND IsClosed = 0
	    AND IsInvalidTask = 0
	    AND WorkflowStateID= @WaitingManualCodeStatusId
	    AND CE.StudyDictionaryVersionId IN (SELECT StudyDictionaryVersionId 
											    FROM StudyDictionaryVersion 
											    WHERE StudyID=@StudyID)
	)
	
	INSERT INTO @TasksToUpdate(CodingElementId, CodingElementGroupID)
	SELECT CodingElementId,CodingElementGroupID
	FROM TasksToInvalidate
	
	DECLARE @UtcTime DATETIME=GETUTCDATE()
	UPDATE CE
	SET	IsInvalidTask = 1,
		IsClosed = 1,
		Updated = @UtcTime,
		CacheVersion = CacheVersion + 10
	FROM @TasksToUpdate T
		JOIN CodingElements CE 
		ON CE.CodingElementId = T.CodingElementId		
		

	INSERT INTO dbo.WorkflowTaskHistory
        ( WorkflowTaskID ,
          WorkflowStateID ,
          WorkflowActionID ,
          WorkflowSystemActionID ,
          UserID ,
          WorkflowReasonID ,
          Comment ,
          Created ,
          SegmentId ,
          CodingAssignmentId ,
          CodingElementGroupId,
          QueryId
        )
   SELECT CE.CodingElementId, 
   CE.WorkflowStateID, NULL, NULL, -2, NULL, 
		@WorkflowTaskHistoryComment, 
		@UtcTime, 
		CE.SegmentId, 
		NULL,
		CE.CodingElementGroupID,
		0
	FROM @TasksToUpdate T
		JOIN CodingElements CE ON CE.CodingElementId = T.CodingElementId
	
	PRINT N'InValidate tasks succeeded!'

	SELECT CE.* 
	FROM @TasksToUpdate T
	JOIN CodingElements CE 
	ON CE.CodingElementId = T.CodingElementId

	DROP TABLE #TermInRave



