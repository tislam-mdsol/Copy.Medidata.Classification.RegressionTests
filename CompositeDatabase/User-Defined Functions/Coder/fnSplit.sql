/** $Workfile: $
**
** Copyright(c) 2007, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Jalal Uddin juddin@mdsol.com
**
** Complete history on bottom of file
**/

-- Please use dbo.fnParseDelimitedString instead.

set NOCOUNT ON
go

if object_id('fnSplit') is not null
	DROP FUNCTION dbo.fnSplit
GO

CREATE FUNCTION dbo.fnSplit
(
    @ItemList VARCHAR(max),
    @delimiter CHAR(1)
) RETURNS @IDTable TABLE (Item VARCHAR(50))
AS

BEGIN
    DECLARE @tempItemList VARCHAR(max)
    SET @tempItemList = @ItemList

    DECLARE @i INT
    DECLARE @Item VARCHAR(4000)

    SET @tempItemList = REPLACE(@tempItemList, ' ', '')
    SET @i = CHARINDEX(@delimiter, @tempItemList)

    WHILE (LEN(@tempItemList) > 0)
    BEGIN
        IF @i = 0
            SET @Item = @tempItemList
        ELSE
            SET @Item = LEFT(@tempItemList, @i - 1)
        INSERT INTO @IDTable(Item) VALUES(@Item)
        IF @i = 0
            SET @tempItemList = ''
        ELSE
            SET @tempItemList = RIGHT(@tempItemList, LEN(@tempItemList) - @i)
        SET @i = CHARINDEX(@delimiter, @tempItemList)
    END
    RETURN
END
GO
