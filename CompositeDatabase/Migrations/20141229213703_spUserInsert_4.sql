IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUserInsert')
	DROP PROCEDURE spUserInsert
GO
CREATE PROCEDURE dbo.spUserInsert
(
    @FirstName NVARCHAR(255),
	@LastName NVARCHAR(255),
	@Email NVARCHAR(255),
    @Login NVARCHAR(50),
	@TimeZoneInfo NVARCHAR(255),
    @IMedidataId NVARCHAR(50),
    @Locale CHAR(3),
	@Active BIT,
	@UserID INT OUTPUT
)
AS

	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	DECLARE @Created DATETIME = @UtcDate, @Updated DATETIME = @UtcDate 
	
	 
	INSERT INTO Users (
		FirstName,
		LastName,
		Email,
		TimeZoneInfo,
		[Login],
		IMedidataId,
		Locale,
		Active,
		Created,
		Updated
	) VALUES (
		@FirstName,
		@LastName,
		@Email,
		@TimeZoneInfo,
		@Login,
		@IMedidataId,
		@Locale,
		@Active,
		@Created,
		@Updated
	)
	SET @UserID = SCOPE_IDENTITY() 
	
GO   