IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUserPreferencesInsert')
	DROP PROCEDURE spUserPreferencesInsert
GO

CREATE PROCEDURE dbo.spUserPreferencesInsert (
	@UserId int,
	@SegmentId int,
	@DisplayPrimaryPathOnly bit,
	@Created datetime output,
	@Updated datetime output,
	@UserPreferenceId bigint output
)
AS

BEGIN
	DECLARE @UtcDate DateTime
	SET @UtcDate = GetUtcDate()
	SELECT @Created = @UtcDate, @Updated = @UtcDate

	INSERT INTO dbo.UserPreferences (
		UserId,
		SegmentId,
		DisplayPrimaryPathOnly,
		Created,
		Updated
	) VALUES (
		@UserId,
		@SegmentId,
		@DisplayPrimaryPathOnly,
		@UtcDate,
		@UtcDate
	)
	SET @UserPreferenceId = SCOPE_IDENTITY()
END

GO
 