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

IF object_id('spWorkflowRoleActionInsert') is not null
	drop  procedure spWorkflowRoleActionInsert
go

create procedure spWorkflowRoleActionInsert
	@WorkflowRoleId bigint,
	@WorkflowActionId int,
	@SegmentId INT,
	@WorkflowRoleActionID bigint output,
	@Created datetime output,
	@Updated datetime output
as
begin
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  	
		
	INSERT INTO dbo.WorkflowRoleActions (  
	  SegmentId,  
	  WorkflowRoleId, 
	  WorkflowActionId, 
	  Created,  
	  Updated  
	 ) 
	 VALUES (  
	  @SegmentId,  
	  @WorkflowRoleId,
	  @WorkflowActionId,  
	  @UtcDate,  
	  @UtcDate  
	 )  
	 SET @WorkflowRoleActionID = SCOPE_IDENTITY()  
end
go
