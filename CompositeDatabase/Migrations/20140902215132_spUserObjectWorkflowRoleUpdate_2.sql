if object_id('spUserObjectWorkflowRoleUpdate') is not null
	drop procedure spUserObjectWorkflowRoleUpdate
go

create procedure spUserObjectWorkflowRoleUpdate
	@UserObjectWorkflowRoleID BIGINT,
	@GrantToObjectID bigint,
	@GrantOnObjectID bigint,
	@WorkflowRoleID bigint,
	@Active bit,
	@DenyObjectRole bit,
	@SegmentId INT
as

declare @utcdatetime datetime
set @utcdatetime = GetUtcDate()


	update UserObjectWorkflowRole set
		GrantToObjectID = @GrantToObjectID,
		GrantOnObjectID = @GrantOnObjectID,
		WorkflowRoleID = @WorkflowRoleID,
		SegmentId = @SegmentId,
		Active = @Active,
		DenyObjectRole = @DenyObjectRole,
		Updated = @utcdatetime
	where UserObjectWorkflowRoleID = @UserObjectWorkflowRoleID


go
 