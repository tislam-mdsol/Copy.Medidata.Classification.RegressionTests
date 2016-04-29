
IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingSourceTermInsertGroupMany')
	DROP PROCEDURE dbo.spCodingSourceTermInsertGroupMany
GO

CREATE PROCEDURE dbo.spCodingSourceTermInsertGroupMany
(  
	@TrackableObjectID BIGINT,

	@SourceSystemId INT,
	@CodingRequestId INT,
	
	@taskUDT dbo.TaskInsert_UDT READONLY, 
	@termComponentUDT dbo.TermComponent_UDT READONLY,
	@termReferenceUDT dbo.TermReference_UDT READONLY,
	@workflowVariableUDT dbo.WorkflowVariable_UDT READONLY,

	@SegmentId INT
)  
AS
BEGIN
	
	DECLARE @SubmissionDate DATETIME, @CodingSourceAlgorithmId INT, @UtcDate DATETIME, @newTasks INT
	SELECT @SubmissionDate = GETUTCDATE(),
		@CodingSourceAlgorithmId = 0,
		@UtcDate = GETUTCDATE(),
		@newTasks = 0

	DECLARE @outPutTable TABLE(	
		Ordinal INT PRIMARY KEY,
		CodingElementID BIGINT,
		CodingElementGroupId INT,
		IsDuplicate BIT, 
		SourceIdentifier NVARCHAR(100),
		SegmentID INT)

	DECLARE @taskOrdinal INT, @isInvalid BIT, @isClosed BIT
	
	DECLARE @matchingCodingElementID BIGINT, 
		@matchedGroupID BIGINT, 
		@MedicalDictionaryLevelKey NVARCHAR(100),
		@DictionaryLocale CHAR(3),
		@StartingWorkflowStateId INT,
		@Term NVARCHAR(450),
		@TermSearchType INT,
		@CodingElementID BIGINT,
		@Priority INT,
		@SourceIdentifier NVARCHAR(100),
	
		@subjectRef NVARCHAR(100), 
		@formRef NVARCHAR(450), 
		@fieldRef NVARCHAR(450),
		@StudyDictionaryVersionId INT,
		@UUID NVARCHAR(100),
		@CodingContextURI NVARCHAR(4000),
		@UpdatedTimeStamp BIGINT,
		@MarkingGroup NVARCHAR(450),
		@BatchOID NVARCHAR(450)
		--,@groupVerbatimId INT

	DECLARE UDTCursor CURSOR FORWARD_ONLY FOR
	SELECT 
		RawInputString,
		TermSearchType,
		MedicalDictionaryLevelKey,
		DictionaryLocale,
		StartingWorkflowStateId,
		Priority,
		SourceIdentifier,
		SubjectRef,
		FormRef,
		FieldRef,
		CodingRequestItemDataOrdinal,
		--ReducedInputStringId,
		GroupId,
		StudyDictionaryVersionId,
		UUID,
		CodingContextURI,
		UpdatedTimeStamp,
		MarkingGroup,
		BatchOID
	FROM @taskUDT

	BEGIN TRANSACTION
	BEGIN TRY

		OPEN UDTCursor
		
		FETCH UDTCursor INTO 
			@Term,
			@TermSearchType,
			@MedicalDictionaryLevelKey,
			@DictionaryLocale,
			@StartingWorkflowStateId,
			@Priority,
			@SourceIdentifier,
			@subjectRef,
			@formRef,
			@fieldRef,
			@taskOrdinal,
			--@groupVerbatimId,
			@matchedGroupID,
			@StudyDictionaryVersionId,
			@UUID,
			@CodingContextURI,
			@UpdatedTimeStamp,
			@MarkingGroup,
			@BatchOID

							
		WHILE (@@fetch_status = 0)
		BEGIN

			-- single task work
			-- reset matchedGroupID!
			SELECT @isInvalid = 0, 
				@isClosed = 0,
				@CodingElementID = NULL
		
			-- if no valid group then mark the task accordingly
			IF (@matchedGroupID = 0)
			BEGIN
				SELECT @isInvalid = 1, 
					@isClosed = 1
			END

			-- Create Task
			INSERT INTO CodingElements (SegmentId, CodingElementGroupID, CodingSourceAlgorithmId, StudyDictionaryVersionId, MedicalDictionaryLevelKey, VerbatimTerm, SourceSystemId, CodingRequestId, SearchType, SourceIdentifier, WorkflowStateID, Priority, SourceField, SourceForm, SourceSubject, IsInvalidTask, IsClosed, UUID, CodingContextURI, UpdatedTimeStamp, MarkingGroup, BatchOID, DictionaryLevelId_Backup)
			VALUES (@SegmentId, @matchedGroupID, @CodingSourceAlgorithmId, @StudyDictionaryVersionId, @MedicalDictionaryLevelKey, @Term, @SourceSystemId, @CodingRequestId, @TermSearchType, @SourceIdentifier, @StartingWorkflowStateId, @Priority, @fieldRef, @formRef, @subjectRef, @isInvalid, @isClosed,@UUID, @CodingContextURI, @UpdatedTimeStamp, @MarkingGroup,@BatchOID, 0)
			SET @CodingElementID = SCOPE_IDENTITY()
			
			-- Create TaskData.
			INSERT INTO WorkflowTaskData (SegmentId, WorkflowTaskID, WorkflowVariableId, Data)
			SELECT @SegmentId, @CodingElementID, Id, Value
			FROM @workflowVariableUDT
			WHERE CodingRequestItemDataOrdinal = @taskOrdinal			
			
			INSERT INTO CodingSourceTermReferences (CodingSourceTermId, ReferenceName, ReferenceValue, SegmentId)
			SELECT @CodingElementID, ReferenceKey, Value, @SegmentId
			FROM @termReferenceUDT
			WHERE CodingRequestItemDataOrdinal = @taskOrdinal

			-- insert into supplements
			INSERT INTO CodingSourceTermSupplementals (CodingSourceTermID, SupplementTermKey, SupplementalValue, SearchOperator, Ordinal, SegmentId, IsComponent)
			SELECT @CodingElementID, TextKey, RawInputString, SearchOperator, Ordinal, @SegmentId,
				CASE WHEN IsSupplement = 1 THEN 0 ELSE 1 END 
			FROM @termComponentUDT
			WHERE CodingRequestItemDataOrdinal = @taskOrdinal
			
			SET @newTasks = @newTasks + 1

			INSERT INTO @outPutTable(Ordinal, 
				CodingElementID, 
				CodingElementGroupId,
				IsDuplicate,
				SourceIdentifier, 
				SegmentID)
			VALUES(
				@taskOrdinal, 
				@CodingElementID,
				@matchedGroupID,
				0, -- TODO : to be handled in query management release
				@SourceIdentifier,
				@SegmentID
				)
				
			FETCH UDTCursor INTO 
				@Term,
				@TermSearchType,
				@MedicalDictionaryLevelKey,
				@DictionaryLocale,
				@StartingWorkflowStateId,
				@Priority,
				@SourceIdentifier,
				@subjectRef,
				@formRef,
				@fieldRef,
				@taskOrdinal,
				--@groupVerbatimId,
				@matchedGroupID,
				@StudyDictionaryVersionId,
				@UUID,
				@CodingContextURI,
				@UpdatedTimeStamp,
				@MarkingGroup,
				@BatchOID
			
		END

		CLOSE UDTCursor
		DEALLOCATE UDTCursor

		-- TODO : get this out of this transaction scope
		UPDATE TrackableObjects
		SET TaskCounter = TaskCounter + @newTasks 
		WHERE TrackableObjectID = @TrackableObjectID
		
		COMMIT TRANSACTION
		
		
		SELECT *, 0 AS AckNackTransmissionId
		FROM @outPutTable

	END TRY

	BEGIN CATCH
	
		ROLLBACK TRANSACTION
		
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
		SELECT @ErrorMessage = coalesce(@ErrorProc, 'spCodingSourceTermInsertGroupMany.sql') + ' (' + cast(@ErrorLine as nvarchar) + '): ' + @ErrorMessage

		-- try to close the cursor if not closed!
		BEGIN TRY
			CLOSE UDTCursor
			DEALLOCATE UDTCursor
		END TRY
		BEGIN CATCH
			-- do nothing
		END CATCH
		
		RAISERROR (@ErrorMessage,  @ErrorSeverity, @ErrorState);
	END CATCH

END
GO

SET NOCOUNT OFF
GO