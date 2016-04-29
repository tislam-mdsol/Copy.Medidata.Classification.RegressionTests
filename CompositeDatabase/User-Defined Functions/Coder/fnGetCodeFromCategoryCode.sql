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
--example of category code 1234567 234 1 return 1234567 (string before the first space)
SET NOCOUNT ON
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnGetCodeFromCategoryCode')
	DROP FUNCTION dbo.fnGetCodeFromCategoryCode
GO
CREATE FUNCTION dbo.fnGetCodeFromCategoryCode
( 
  @categoryCode NVARCHAR(100)
) RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE @Code NVARCHAR(100),@spaceIndex INT
	Set @spaceIndex = CHARINDEX(' ',@categoryCode)
	IF @spaceIndex>0
	SET @Code = substring(@categoryCode,1,@spaceIndex-1)
	ELSE 
	SET @Code = @categoryCode

	RETURN @Code
END
GO 
SET NOCOUNT OFF
GO