 /** $Workfile: fnIsValidNumericCorrect.sql $
**
** Copyright© (2007), Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Isaac Wong
**
** Complete history on bottom of file
**/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnIsValidNumericCorrect')
BEGIN
	DROP FUNCTION dbo.fnIsValidNumericCorrect
END
GO

CREATE FUNCTION dbo.fnIsValidNumericCorrect(@instring varchar(20)) 
RETURNS BIT
BEGIN
	declare @out bit
	declare @len int
	declare @position int

	set @out = 0
	Set @len = len(@instring)
	SET @position = 1

	--Use IsNumeric to get us past most non-numeric issues and make sure no commas as a comma is not valid for float conversion.
	if isnumeric(@instring)=1 and charindex(',', @instring,1) = 0
	begin
		while @out = 0 and @position <= @len
		begin
		--Make sure character is between 0 and 9 
		if  PatIndex('[0-9]', SUBSTRING(@instring, @position, 1)) <> 0 
			set @out = 1
		set @position = @position + 1
		end
	end
	return @out
END
GO

GRANT EXEC ON dbo.fnIsValidNumericCorrect TO PUBLIC

GO
