DECLARE @errorString NVARCHAR(MAX)
DECLARE @mapping TABLE(Id INT, OID VARCHAR(50))

INSERT INTO @mapping(Id, OID)
VALUES
	(1, 'Start Auto Code'),
	(2,'Code'),
	(3, 'Open Query'),
	(4, 'Retry Auto Code'),
	(5, 'Recode'),
	(6, 'Approve'),
	(7, 'AutoApproveInternal'),
	(8, 'Transmit'),
	(9, 'CompleteWithoutTransmission'),
	(10, 'Reconsider'),
	(11, 'Leave As Is'),
	(12, 'Reject Coding Decision'),
	(13, 'Add Comment'),
	(14, 'Reclassify'),
	(15, 'Cancel Query')

	BEGIN TRY
	BEGIN TRANSACTION
			
		-- 1. update history
		UPDATE WTH
		SET WTH.WorkflowActionID = M.Id
		FROM WorkflowTaskHistory WTH
			JOIN WorkflowActions WA
				ON WTH.WorkflowActionID = WA.WorkflowActionId
			JOIN @mapping M
				ON M.OID = WA.OID
		WHERE WTH.WorkflowActionId IS NOT NULL

		-- 2. update workflow roleactions
		UPDATE WRA
		SET WRA.WorkflowActionID = M.Id
		FROM WorkflowRoleActions WRA
			JOIN WorkflowActions WA
				ON WRA.WorkflowActionID = WA.WorkflowActionId
			JOIN @mapping M
				ON M.OID = WA.OID


		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		
		ROLLBACK TRANSACTION

		SELECT
			ERROR_NUMBER() AS ErrorNumber
			,ERROR_SEVERITY() AS ErrorSeverity
			,ERROR_STATE() AS ErrorState
			,ERROR_PROCEDURE() AS ErrorProcedure
			,ERROR_LINE() AS ErrorLine
			,ERROR_MESSAGE() AS ErrorMessage;

		SET @errorString = N'ERROR Updating the workflow action references : ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH