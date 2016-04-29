IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGroupVerbatimChnInsert')
	DROP PROCEDURE spGroupVerbatimChnInsert
GO

CREATE PROCEDURE dbo.spGroupVerbatimChnInsert 
(
	@GroupVerbatimId INT OUTPUT,  
	@VerbatimText NVARCHAR(450),	
	@Created DATETIME OUTPUT
)  
AS  
  
BEGIN  

	SET @Created = GETUTCDATE()  

	--from http://stackoverflow.com/questions/3407857/only-inserting-a-row-if-its-not-already-there
	INSERT INTO dbo.GroupVerbatimChn 
	SELECT
		@VerbatimText,
		@Created
	 WHERE
		NOT EXISTS
		(SELECT NULL FROM dbo.GroupVerbatimChn WITH (UPDLOCK, HOLDLOCK)
		WHERE VerbatimText=@VerbatimText)
	 
	 SELECT @GroupVerbatimId = gv.GroupVerbatimID
		, @Created = gv.Created
	 FROM dbo.GroupVerbatimChn as gv
	 WHERE VerbatimText=@VerbatimText
END

GO  