/* 
** Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Bonnie Pan [bpan@mdsol.com]
**/ 
--example category code 1234567 2345 1 return 2345
SET NOCOUNT ON
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnGetJPNStringIDFromCategoryCode')
	DROP FUNCTION dbo.fnGetJPNStringIDFromCategoryCode
GO
CREATE FUNCTION dbo.fnGetJPNStringIDFromCategoryCode
( 
  @categoryCode NVARCHAR(100)
) RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE @Code NVARCHAR(100), @temp NVARCHAR(100), @spaceIndex INT
	Set @spaceIndex = CHARINDEX(' ',@categoryCode)
	IF @spaceIndex >0
	BEGIN
		SET @temp = substring(@categoryCode,@spaceIndex + 1,LEN(@categoryCode))
		SET @Code = substring(@temp, 1, CHARINDEX(' ', @temp)-1)
	END
	ELSE 
	SET @Code = @categoryCode

	RETURN @Code
END
GO  	
SET NOCOUNT OFF 	
GO
