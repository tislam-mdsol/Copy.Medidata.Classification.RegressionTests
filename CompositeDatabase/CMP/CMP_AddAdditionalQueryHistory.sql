	
	---This CMP is to resolve WR 1423718: 
	---Coder failed to open query due to data conflict response received (409) from RAVE however leaving status
	---in query history tab as "Queued" and status in the task grid "None"
	---Client wants us to add an additional history to the history tab to record what has happened
	---Relates to MCC-138512
	DECLARE @Comment AS NVARCHAR(250) = 'failed to open query due to the term change (WR 1423718)' 
	DECLARE @CodingElementId INT = 5307936
	DECLARE @QueryId INT = 17628
	DECLARE @PriorCodingQueryHistoryId INT = 52560

	BEGIN TRY
	BEGIN TRANSACTION	
		
		DECLARE @UtcTime DATETIME=GETUTCDATE()

		INSERT INTO CoderQueryHistory (  
			QueryRepeatKey,
			QueryStatus,
			PriorQueryStatus,
			Recipient,
			QueryText,
			QueryResponse,
			UserRef,
			DateTimeStamp,
			QueryId,
			Created
		) 
		SELECT QueryRepeatKey,
		0,--Query Status: None
		QueryStatus,
		Recipient,
		QueryText,
		'',
		'systemuser',
		@UtcTime,
		QueryId,
		@UtcTime
		FROM CoderQueryHistory
		Where QueryHistoryId = @PriorCodingQueryHistoryId

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
			  CodingElementGroupId ,
			  QueryId
			)
	   SELECT CE.CodingElementId, 
	   CE.WorkflowStateID, 
	   NULL, 
	   NULL, 
	   -2, 
	   NULL, 
	  @Comment, 
	  @UtcTime, 
	  CE.SegmentId, 
	  NULL,
	  CE.CodingElementGroupID,
	  @QueryId
	   FROM CodingElements CE
	   WHERE CodingElementId=@CodingElementId

   COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		
	    DECLARE @errorString NVARCHAR(1000)
		SET @errorString = N'ERROR Updating Tasks: ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH