IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUserPreferencesUpdate')
	DROP PROCEDURE spUserPreferencesUpdate
GO

CREATE PROCEDURE dbo.spUserPreferencesUpdate (
	@UserPreferenceId bigint,
	@UserId int,
	@SegmentId int,
	@DisplayPrimaryPathOnly bit,
	@Updated datetime output
)
AS

BEGIN
	DECLARE @UtcDate DateTime
	SET @UtcDate = GetUtcDate()
	SET @Updated = @UtcDate

	UPDATE dbo.UserPreferences SET
		UserId = @UserId,
		SegmentId = @SegmentId,
		DisplayPrimaryPathOnly = @DisplayPrimaryPathOnly,
		Updated = @UtcDate
	WHERE UserPreferenceId = @UserPreferenceId
END

GO