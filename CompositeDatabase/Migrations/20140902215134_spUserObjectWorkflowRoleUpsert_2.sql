if object_id('spUserObjectWorkflowRoleUpsert') is not null
	drop procedure dbo.spUserObjectWorkflowRoleUpsert
go

create procedure [dbo].[spUserObjectWorkflowRoleUpsert]
(
	@GrantToObjectID bigint,
	@GrantOnObjectID bigint,
	@WorklfowRoleID bigint,
	@Active bit,
	@DenyObjectRole bit,
	@Count int output, -- 0: if inserted, 1:if updated
	@SegmentId INT
)
as
begin

	declare @utcdatetime datetime
	set @utcdatetime = GetUtcDate()

	if exists (select null from UserObjectWorkflowRole 
		where SegmentId = @SegmentId 
			and GrantToObjectID = @GrantToObjectID 
			and GrantOnObjectID = @GrantOnObjectID ) begin
			
		update UserObjectWorkflowRole 
		set GrantToObjectID = @GrantToObjectID,
			GrantOnObjectID = @GrantOnObjectID,
			WorkflowRoleID = @WorklfowRoleID,
			SegmentId = @SegmentId,
			Active = @Active,
			DenyObjectRole = @DenyObjectRole,
			Updated = @utcdatetime
			where SegmentId = @SegmentId 
				and GrantToObjectID = @GrantToObjectID 
				and GrantOnObjectID = @GrantOnObjectID 
				
			set @Count = 1
	end
	else begin		
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
			@WorklfowRoleID,
			@SegmentId,
			@Active,
			@DenyObjectRole,
			@utcdatetime,
			@utcdatetime)
			
			set @Count = 0
	end
end
go