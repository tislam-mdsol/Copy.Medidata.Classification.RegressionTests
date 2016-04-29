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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSystemVariableLoadByWorkflowVariable')
	DROP PROCEDURE spSystemVariableLoadByWorkflowVariable
GO
create procedure dbo.spSystemVariableLoadByWorkflowVariable
(
	@WorkflowVariableId int
)
as
select * from SystemVariables where WorkflowVariableId=@WorkflowVariableId
GO 