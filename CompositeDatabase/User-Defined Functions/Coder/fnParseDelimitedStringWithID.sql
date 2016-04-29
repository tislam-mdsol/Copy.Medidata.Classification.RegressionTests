 /* 
** Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Altin Vardhami avardhami@mdsol.com
** (optimized version)
**/ 

set nocount on
go

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TF' AND name = 'fnParseDelimitedStringWithID')
BEGIN
	DROP FUNCTION dbo.fnParseDelimitedStringWithID
END
GO

-- select * from dbo.fnParseDelimitedString(N'12|324234|3|2321|2|213|','|')
-- select * from dbo.fnParseDelimitedStringOld(N'12|324234|3|2321|2|213|','|')

CREATE FUNCTION dbo.fnParseDelimitedStringWithID
(
	@StringToParse	NVARCHAR(MAX), 
	@Delimeter		NCHAR(1)
)
RETURNS @Items TABLE(Id INT IDENTITY(1, 1), Item NVARCHAR(4000))
AS
  BEGIN
  
	DECLARE @firstIndex INT, @lastIndex INT
	
	SELECT @firstIndex = 1,
		@lastIndex = CHARINDEX(@Delimeter, @StringToParse, 2)
	
	WHILE @lastIndex > 1
	BEGIN

		INSERT @Items (Item)
		SELECT SUBSTRING(@StringToParse, @firstIndex, @lastIndex - @firstIndex)
		
		SELECT @firstIndex = @lastIndex + 1,
			@lastIndex = CHARINDEX(@Delimeter, @StringToParse, @firstIndex + 1)

	END
	
	INSERT @Items (Item)
	SELECT SUBSTRING(@StringToParse, @firstIndex, LEN(@StringToParse) - @firstIndex + 1)

	RETURN
  END
GO


