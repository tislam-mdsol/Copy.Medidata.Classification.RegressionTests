IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUserInsert')
	DROP PROCEDURE spUserInsert
GO
CREATE PROCEDURE dbo.spUserInsert
(
    @FirstName NVARCHAR(255),
	@LastName NVARCHAR(255),
	@Email NVARCHAR(255),
    @Login NVARCHAR(50),
    @IMedidataId NVARCHAR(50),
    @Locale CHAR(3),
	@PasswordExpires DateTime,
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
		[Login],
		IMedidataId,
		Locale,
		PasswordExpires,
		Active,
		Created,
		Updated
	) VALUES (
		@FirstName,
		@LastName,
		@Email,
		@Login,
		@IMedidataId,
		@Locale,
		@PasswordExpires,
		@Active,
		@Created,
		@Updated
	)
	SET @UserID = SCOPE_IDENTITY() 
	
GO   