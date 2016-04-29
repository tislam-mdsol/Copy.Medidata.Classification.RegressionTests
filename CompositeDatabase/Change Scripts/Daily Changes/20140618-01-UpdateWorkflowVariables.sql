DECLARE @errorString NVARCHAR(MAX)
DECLARE @mapping TABLE(Id INT, OID VARCHAR(50))

INSERT INTO @mapping(Id, OID)
VALUES
	(1, 'IsAutoCode'),
	(2, 'IsReviewRequired'),
	(3, 'IsApprovalRequired'),
	(4, 'IsResetRequired'),
	(5, 'IsAutoApproval'),
	(6, 'IsAutoApproveExecutedAlready'),
	(7, 'IsBypassTransmit')

	BEGIN TRY
	BEGIN TRANSACTION
			
		UPDATE WTD
		SET WorkflowVariableID = M.Id
		FROM WorkflowTaskData WTD
			JOIN WorkflowVariables WV
				ON WTD.WorkflowVariableID = WV.WorkflowVariableID
			JOIN @mapping M
				ON WV.VariableName = M.OID

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

		SET @errorString = N'ERROR Updating the workflow variables references : ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH