/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF object_id('spUserObjectWorkflowRoleFetch') is not null
	DROP  Procedure  spUserObjectWorkflowRoleFetch
GO

create procedure spUserObjectWorkflowRoleFetch
(
	@UserObjectWorkflowRoleId bigint
)
as
begin

	select * 
	from UserObjectWorkflowRole 
	where UserObjectWorkflowRoleId = @UserObjectWorkflowRoleId
		AND Active = 1
end  