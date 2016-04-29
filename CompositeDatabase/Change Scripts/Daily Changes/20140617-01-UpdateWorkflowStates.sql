DECLARE @errorString NVARCHAR(MAX)
DECLARE @mapping TABLE(Id INT, OID VARCHAR(50))

INSERT INTO @mapping(Id, OID)
VALUES
	(1, 'Start'),
	(2, 'Waiting Manual Code'),
	(3, 'Waiting Approval'),
	(4, 'Waiting Transmission'),
	(5, 'Completed'),
	(6, 'Reconsider')

	BEGIN TRY
	BEGIN TRANSACTION
			
		-- 1. update history
		UPDATE WTH
		SET WTH.WorkflowStateId = M.Id
		FROM WorkflowTaskHistory WTH
			JOIN WorkflowStates WS
				ON WTH.WorkflowStateId = WS.WorkflowStateId
			JOIN @mapping M
				ON M.OID = dbo.fnLDS(WS.WorkflowStateNameID, 'eng')
		WHERE WTH.WorkflowStateId IS NOT NULL

		-- 2. update tasks
		UPDATE CE
		SET CE.WorkflowStateId = M.Id
		FROM CodingElements CE
			JOIN WorkflowStates WS
				ON CE.WorkflowStateId = WS.WorkflowStateId
			JOIN @mapping M
				ON M.OID = dbo.fnLDS(WS.WorkflowStateNameID, 'eng')


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

		SET @errorString = N'ERROR Updating the workflow states references : ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH