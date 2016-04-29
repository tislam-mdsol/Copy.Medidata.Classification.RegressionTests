﻿/** $Workfile: spWorkflowTaskDataInsert.sql $
**
** Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Mark Hwe [mhwe@mdsol.com]
**
** Complete history on bottom of file
**/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spWorkflowTaskDataInsert')
	DROP PROCEDURE dbo.spWorkflowTaskDataInsert
GO

CREATE PROCEDURE dbo.spWorkflowTaskDataInsert (
	@WorkflowTaskID bigint,
	@WorkflowVariableID int,
	@Data nvarchar(4000),
	@WorkflowTaskDataID bigint output,
	@SegmentId int
)
AS

BEGIN

	INSERT INTO dbo.WorkflowTaskData (
		WorkflowTaskID,
		SegmentId,
		WorkflowVariableID,
		Data
	) VALUES (
		@WorkflowTaskID,
		@SegmentId,
		@WorkflowVariableID,
		@Data
	)
	SET @WorkflowTaskDataID = SCOPE_IDENTITY()
END

GO
