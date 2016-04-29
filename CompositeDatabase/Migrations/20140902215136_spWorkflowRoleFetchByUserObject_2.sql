if exists (select * from sysobjects where type = 'P' and name = 'spWorkflowRoleFetchByUserObject')
	drop procedure spWorkflowRoleFetchByUserObject
go

create procedure spWorkflowRoleFetchByUserObject
(
	@UserID bigint,
	@GrantOnObjectID bigint,
	@AllStudyId INT,
	@SegmentId INT
)
as
begin
	
	SELECT R.*
	FROM WorkflowRoles R
	WHERE Active = 1
		AND SegmentId = @SegmentId
		AND EXISTS (SELECT NULL
			FROM UserObjectWorkflowRole U
			WHERE GrantToObjectId		= @UserID 
				and DenyObjectRole		= 0
				and Active				= 1
				and SegmentId			= @SegmentId
				and GrantOnObjectId IN (@GrantOnObjectID, @AllStudyId)
				AND U.WorkflowRoleId = R.WorkflowRoleId
			)
end
go
