IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSubscriptionLogInsert')
	DROP PROCEDURE spSubscriptionLogInsert
GO
create procedure dbo.spSubscriptionLogInsert
(
	@Active BIT,
	@Deleted BIT,
	@UserID INT,
	@DictionaryVersionId INT,
	@DictionaryLocale CHAR(3),
	@Created DATETIME OUTPUT,
	@Updated DATETIME OUTPUT,
	@SubscriptionLogID INT OUTPUT
)
AS	

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
  
	INSERT INTO SubscriptionLogs (  
		Active,
		Deleted,
		UserID,
		DictionaryVersionId,
		DictionaryLocale,
		Created,
		Updated
	) VALUES (  
		@Active,
		@Deleted,
		@UserID,
		@DictionaryVersionId,
		@DictionaryLocale,
		@Created,
		@Updated
	)  
	
	SET @SubscriptionLogID = SCOPE_IDENTITY()  	
	
END
GO      