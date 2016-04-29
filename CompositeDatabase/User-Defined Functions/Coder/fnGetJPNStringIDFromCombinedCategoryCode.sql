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
--example category code 1234567 注 1 and componentJpnStringId = 1234
--should return 1234
SET NOCOUNT ON
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnGetJPNStringIDFromCombinedCategoryCode')
	DROP FUNCTION dbo.fnGetJPNStringIDFromCombinedCategoryCode
GO
CREATE FUNCTION dbo.fnGetJPNStringIDFromCombinedCategoryCode
( 
  @categoryCode NVARCHAR(100)
) RETURNS INT
AS
BEGIN
	DECLARE @CategoryName NVARCHAR(100), @temp NVARCHAR(100), @firstSpaceIndex INT , @secondSpaceIndex INT ,@JPNStringID INT
	Set @firstSpaceIndex = CHARINDEX(' ',@categoryCode)
	IF @firstSpaceIndex >0
	BEGIN
		SET @temp = substring(@categoryCode,@firstSpaceIndex + 1,LEN(@categoryCode))
		Set @secondSpaceIndex = CHARINDEX(' ', @temp)
		IF @secondSpaceIndex >0
		BEGIN
			SET @CategoryName = substring(@temp, 1, @secondSpaceIndex - 1)
			SELECT @JPNStringID = Id FROM ComponentJpnStrings WHERE Name=@CategoryName
		END
		ELSE
			SET @JPNStringID = -1
	END
	ELSE
		SET @JPNStringID = -1 
	
	RETURN ISNULL(@JPNStringID, -1)

	
END
GO 
SET NOCOUNT OFF
GO 
