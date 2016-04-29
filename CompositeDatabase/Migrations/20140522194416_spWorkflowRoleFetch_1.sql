﻿/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Jalal Uddin juddin@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF object_id('spWorkflowRoleFetch') is not null
	DROP  Procedure  spWorkflowRoleFetch
GO

CREATE Procedure spWorkflowRoleFetch
	@WorkflowRoleID bigint
AS
	SELECT * FROM WorkflowRoles WHERE WorkflowRoleID = @WorkflowRoleID
GO
 