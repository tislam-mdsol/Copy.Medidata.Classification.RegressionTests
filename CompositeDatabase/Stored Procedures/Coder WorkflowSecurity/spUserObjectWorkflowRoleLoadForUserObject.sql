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

if object_id('spUserObjectWorkflowRoleLoadForUserObject') is not null
	drop procedure spUserObjectWorkflowRoleLoadForUserObject
go

create procedure dbo.spUserObjectWorkflowRoleLoadForUserObject    
(    
	@GrantToObjectId bigint,     
	@GrantToObjectTypeId int,    
	@GrantOnObjectId bigint,     
	@GrantOnObjectTypeId bigint, 
	@SegmentId INT    
)    
as    
begin    
	select u.* from UserObjectWorkflowRole u   
	where u.Active = 1    
		and u.GrantToObjectId=@GrantToObjectId and u.GrantToObjectTypeId=@GrantToObjectTypeId    
		and u.GrantOnObjectId=@GrantOnObjectId and u.GrantOnObjectTypeId=@GrantOnObjectTypeId  
		and u.SegmentId = @SegmentId
      
end
go 