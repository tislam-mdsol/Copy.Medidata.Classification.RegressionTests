/* 
** Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Altin Vardhami [avardhami@mdsol.com]
**/ 

SET NOCOUNT ON
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnGenerateInitialIORVersionLocale')
	DROP FUNCTION dbo.fnGenerateInitialIORVersionLocale
GO
CREATE FUNCTION dbo.fnGenerateInitialIORVersionLocale( 
	@localeCount INT,
	@FromVersionOrdinal INT, 
	@ToVersionOrdinal INT
) RETURNS VARBINARY(100)
BEGIN

	IF (@FromVersionOrdinal > @ToVersionOrdinal OR @localeCount <= 0)
		RETURN 0x

	DECLARE @totalLength INT, @index INT, @byteNum INT, @bitPosition INT
	SET @totalLength = @localeCount * (@ToVersionOrdinal - @FromVersionOrdinal + 1)

	SET @byteNum = @totalLength / 8
	SET @bitPosition = @totalLength % 8
	
	IF (@bitPosition <> 0)
		SET @byteNum = @byteNum + 1

	DECLARE @retVal VARBINARY(100)
	SET @index = 0
	
	SET @retVal = 0x
	
	WHILE (@index < @byteNum)
	BEGIN
		SET @retVal = @retVal + 0x00
		SET @index = @index + 1
	END
	
	RETURN @retVal

END 