/*
** Copyright© 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Vikas Choithani (vchoithani@mdsol.com)
**
*/

-- WORK IN PROGRESS

if object_id('fnGenerateOID') is not null
	drop function fnGenerateOID
go

If object_id('GetNewID') is not null
	drop view GetNewID
go

create view GetNewID as select NEWID() as new_id
	
go

Create Function dbo.fnGenerateOID(@String nvarchar(4000)) returns nvarchar(4000)
BEGIN
	
	declare @IsDoubleByteString varchar(4000) = @String
	declare @newstring varchar(2000) = ''
	
	if((@String is not null or @string <> '') and @IsDoubleByteString = @String)	--If no DoubleByte characters are present
	BEGIN
		declare @num int = 1
		declare @code int	
		while @num < len(@string)+1
		BEGIN
			set @code = Ascii(SubString(@String, @Num, 1))
			--- ascii: 48-57 (numbers 0-9)
			--- ascii: 65-90 (uppercase letters A-Z)
			--- ascii: 97-122 (lowercase letters a-z)
			--- underscore is an ascii 95
			If (@code between 48 and 57) OR (@code between 65 and 90) OR (@code between 97 and 122) OR (@code = 95)
			BEGIN
				set @newstring = @newstring + Substring(@string, @num, 1)
			END
			set @num = @num + 1
		END
	END
	
	if(@newstring = '' or @newstring is null)
	BEGIN
		select @newstring = new_id from GetNewID
	END
	return upper(@newstring)
END
go 
