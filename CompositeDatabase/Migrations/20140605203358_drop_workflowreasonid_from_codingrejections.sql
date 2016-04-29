IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'CodingRejections'
		AND COLUMN_NAME = 'WorkflowReasonId'))
BEGIN
	DROP INDEX [IX_CodingRejections_WorkflowReasonID] ON [dbo].[CodingRejections]
	ALTER TABLE [dbo].[CodingRejections] DROP CONSTRAINT [FK_CodingRejections_WorkflowReasons]
	ALTER TABLE [dbo].[CodingRejections] DROP COLUMN [WorkflowReasonId]
END
GO