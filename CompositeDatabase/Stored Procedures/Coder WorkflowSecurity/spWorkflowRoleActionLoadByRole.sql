/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Jalal Uddin juddin@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF object_id('spWorkflowRoleActionLoadByRole') is not null
	DROP  Procedure  spWorkflowRoleActionLoadByRole
GO

create proc spWorkflowRoleActionLoadByRole
(
	@WorkflowRoleId bigint
)
as
	select * from WorkflowRoleActions where WorkflowRoleId = @WorkflowRoleId
go 