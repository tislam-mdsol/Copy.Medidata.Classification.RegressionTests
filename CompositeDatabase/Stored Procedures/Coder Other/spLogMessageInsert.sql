
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spLogMessageInsert')
	BEGIN
		DROP  Procedure  spLogMessageInsert
	END

GO

CREATE Procedure dbo.spLogMessageInsert
(
	@Date datetime,
	@Category varchar(200),
	@Thread varchar(255),
	@Level varchar(50),
	@Logger varchar(255),
	@Message varchar(4000),
	@Exception varchar(4000)
)
AS
BEGIN
	INSERT INTO dbo.LogMessages (Date, Category, Thread, Level, Logger, Message, Exception)  
		VALUES (@Date, @Category, @Thread, @Level, @Logger, @Message, @Exception)  
END
GO
