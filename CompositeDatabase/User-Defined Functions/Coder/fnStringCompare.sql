/** $Workfile: fnStringCompare.sql $
**
** Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Altin Vardhami [avardhami@mdsol.com]
**
**/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnStringCompare')
BEGIN
	DROP FUNCTION dbo.fnStringCompare
END
GO

-- compare strings as per their collation
-- RETURN 0 if equal
-- RETURN 1 if LEFT > RIGHT
-- RETURN -1 if RIGHT > LEFT
CREATE function dbo.fnStringCompare(@LeftString as nvarchar(4000), @RightString as nvarchar(4000)) returns int
begin

	DECLARE @returnValue INT

    DECLARE @i INT, @j INT, @k INT
    DECLARE @zeroPadding nvarchar(4000), @changedString nvarchar(4000)

    SET @i = CHARINDEX('.', @LeftString)
    IF (@i = 0)
		SET @i = LEN(@LeftString) + 1
    SET @j = CHARINDEX('.', @RightString)
    IF (@j = 0)
		SET @j = LEN(@RightString) + 1
    
    SET @zeroPadding = ''
    
    if (@i > @j)
		SET @k = @i - @j
	ELSE
		SET @k = @j - @i
    
    WHILE (@k > 0)
    BEGIN
		SET @zeroPadding = @zeroPadding + '0'
		SET @k = @k - 1
    END
    
    if (@i > @j)
    BEGIN
		SET @changedString = @zeroPadding + @RightString
		IF (@LeftString = @changedString)
			SET @returnValue = 0
		ELSE IF (@LeftString > @changedString)
			SET @returnValue = 1
		ELSE
			SET @returnValue = -1
	END
	ELSE
	BEGIN
		SET @changedString = @zeroPadding + @LeftString
		IF (@changedString = @RightString)
			SET @returnValue = 0
		ELSE IF (@changedString > @RightString)
			SET @returnValue = 1
		ELSE
			SET @returnValue = -1
	END
    
    RETURN @returnValue
end
GO