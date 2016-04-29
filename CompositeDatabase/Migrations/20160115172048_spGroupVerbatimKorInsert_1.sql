IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGroupVerbatimKorInsert')
	DROP PROCEDURE spGroupVerbatimKorInsert
GO

CREATE PROCEDURE dbo.spGroupVerbatimKorInsert 
(
	@GroupVerbatimId INT OUTPUT,  
	@VerbatimText NVARCHAR(450),	
	@Created DATETIME OUTPUT
)  
AS  
  
BEGIN  

	SET @Created = GETUTCDATE()  

	--from http://stackoverflow.com/questions/3407857/only-inserting-a-row-if-its-not-already-there
	INSERT INTO dbo.GroupVerbatimKor 
	SELECT
		@VerbatimText,
		@Created
	 WHERE
		NOT EXISTS
		(SELECT NULL FROM dbo.GroupVerbatimKor WITH (UPDLOCK, HOLDLOCK)
		WHERE VerbatimText=@VerbatimText)
	 
	 SELECT @GroupVerbatimId = gv.GroupVerbatimID
		, @Created = gv.Created
	 FROM dbo.GroupVerbatimKor as gv
	 WHERE VerbatimText=@VerbatimText
END

GO  