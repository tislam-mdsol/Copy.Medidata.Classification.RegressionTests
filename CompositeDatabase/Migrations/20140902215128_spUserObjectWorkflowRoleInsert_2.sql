
if object_id('spUserObjectWorkflowRoleInsert') is not null
	drop procedure spUserObjectWorkflowRoleInsert
go

create procedure spUserObjectWorkflowRoleInsert
	@GrantToObjectID bigint,
	@GrantOnObjectID bigint,
	@WorkflowRoleID bigint,
	@Active bit,
	@DenyObjectRole bit,
	@UserObjectWorkflowRoleID BIGINT OUTPUT,
	@SegmentId INT
as

declare  @utcdatetime datetime
set @utcdatetime = GetUtcDate()

-- make sure it is unique
IF NOT EXISTS (SELECT NULL FROM UserObjectWorkflowRole
	WHERE GrantToObjectID = @GrantToObjectID
		AND GrantOnObjectID = @GrantOnObjectID
		AND WorkflowRoleID = @WorkflowRoleID
		AND SegmentId = @SegmentId
		AND Active = 1)
BEGIN

	insert into UserObjectWorkflowRole (
		GrantToObjectID,
		GrantOnObjectID,
		WorkflowRoleID,
		SegmentId, 
		Active,
		DenyObjectRole,
		Created,
		Updated)
	values (
		@GrantToObjectID,
		@GrantOnObjectID,
		@WorkflowRoleID,
		@SegmentId,
		@Active,
		@DenyObjectRole,
		@utcdatetime,
		@utcdatetime)

	SET @UserObjectWorkflowRoleID = SCOPE_IDENTITY()  	
	
END
ELSE 
	SET @UserObjectWorkflowRoleID = -1
go
