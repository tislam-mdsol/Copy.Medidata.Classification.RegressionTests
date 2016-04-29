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

IF EXISTS (SELECT * FROM sysobjects WHERE type IN ('TF', 'IF') AND name = 'fnParseDelimitedString')
BEGIN
	DROP FUNCTION dbo.fnParseDelimitedString
END
GO

-- select * from dbo.fnParseDelimitedString(N'12|324234|3|2321|2|213|','|')
-- select * from dbo.fnParseDelimitedStringOld(N'12|324234|3|2321|2|213|','|')

--CREATE FUNCTION dbo.fnParseDelimitedString
--(
--	@StringToParse	NVARCHAR(MAX), 
--	@Delimeter		NCHAR(1)
--)
--RETURNS @Items TABLE(Item NVARCHAR(4000))
--AS
--  BEGIN
  
--	DECLARE @firstIndex INT, @lastIndex INT
	
--	SELECT @firstIndex = 1,
--		@lastIndex = CHARINDEX(@Delimeter, @StringToParse, 2)
	
--	WHILE @lastIndex > 1
--	BEGIN 

--		INSERT @Items (Item)
--		SELECT SUBSTRING(@StringToParse, @firstIndex, @lastIndex - @firstIndex)
		
--		SELECT @firstIndex = @lastIndex + 1,
--			@lastIndex = CHARINDEX(@Delimeter, @StringToParse, @firstIndex + 1)

--	END
	
--	INSERT @Items (Item)
--	SELECT SUBSTRING(@StringToParse, @firstIndex, LEN(@StringToParse) - @firstIndex + 1)

--	RETURN
--  END
--GO

create function dbo.fnParseDelimitedString(@str nvarchar(max),@sep nchar(1))
returns table
as
return
(
	select item
	from
	(
	select x.i.value('(./text())[1]','nvarchar(4000)') [item]
	from (select xmllist= dbo.fnFormatXMLFromDL(@str,@sep) ) a
	cross apply xmllist.nodes('i') x(i)
	) S
	where item is not null
)

go
