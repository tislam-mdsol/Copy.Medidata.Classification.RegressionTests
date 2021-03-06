﻿if object_id('spUserObjectWorkflowRoleLoad') is not null
	drop procedure spUserObjectWorkflowRoleLoad
go

create procedure spUserObjectWorkflowRoleLoad
	@GrantOnObjectID		bigint,
	@GrantToObjectID		bigint,
	@SegmentId				INT
as
begin
	
	SELECT * FROM UserObjectWorkflowRole
	WHERE SegmentId = @SegmentId
		AND @GrantOnObjectID IN (GrantOnObjectId, -1)
		AND @GrantToObjectID IN (GrantToObjectId, -1)
		AND Active = 1
		
end
GO
