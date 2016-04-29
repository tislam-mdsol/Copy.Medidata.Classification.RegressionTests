/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2008, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Jalal Uddin juddin@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

--spWorkflowTaskHistoryLoadByWorkflowTask2 31389

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spWorkflowTaskHistoryLoadByWorkflowTask')
	DROP PROCEDURE spWorkflowTaskHistoryLoadByWorkflowTask
GO
create procedure dbo.spWorkflowTaskHistoryLoadByWorkflowTask
(
	@workflowTaskId bigint
)
as

	select WTH.*
	from WorkflowTaskHistory WTH
    where WTH.WorkflowTaskID = @workflowTaskId
	order by WTH.WorkflowTaskHistoryID desc


GO 


