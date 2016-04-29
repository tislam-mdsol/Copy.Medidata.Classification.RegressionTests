IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUserPreferencesLoadBySegmentUser')
	DROP PROCEDURE spUserPreferencesLoadBySegmentUser
GO
create procedure dbo.spUserPreferencesLoadBySegmentUser
(
	@userId int,
	@segmentId int
)
as
begin
	select * from dbo.UserPreferences where segmentId=@segmentId and userId=@userId
end	 
GO