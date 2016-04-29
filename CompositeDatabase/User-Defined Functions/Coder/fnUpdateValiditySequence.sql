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
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnUpdateValiditySequence')
	DROP FUNCTION dbo.fnUpdateValiditySequence
GO
CREATE FUNCTION dbo.fnUpdateValiditySequence( 
	@IsValid BIT,
	@CurrentValidity VARBINARY(100),
	@TargetVersionOrdinal INT, 
	@LocaleOffset INT, 
	@FromVersionOrdinal INT, 
	@ToVersionOrdinal INT
) RETURNS VARBINARY(100)
BEGIN

	DECLARE @arrayOffset INT, @byteNum INT, @bitPosition INT
	SET @arrayOffset = @LocaleOffset * (@ToVersionOrdinal - @FromVersionOrdinal + 1) + @TargetVersionOrdinal - @FromVersionOrdinal + 1

	SET @byteNum = @arrayOffset / 8
	SET @bitPosition = @arrayOffset % 8
	
	IF (@bitPosition <> 0) SET @byteNum = @byteNum + 1
	ELSE SET @bitPosition = 8


	DECLARE @relevantByte BINARY(1)
	SET @relevantByte = SUBSTRING(@CurrentValidity, @byteNum, 1)

	DECLARE @bitMask TINYINT
	
	SELECT @bitMask = BitMask
	FROM BitMaskLookup
	WHERE BitPosition = @bitPosition
	
	IF (@IsValid = 1)
		SET @relevantByte = @bitMask | @relevantByte
	ELSE
		SET @relevantByte = (~@bitMask) & @relevantByte

	DECLARE @retVal VARBINARY(100), @remainderSTR INT

	IF (@byteNum > 1)
		SET @retVal = SUBSTRING(@CurrentValidity, 1, @byteNum - 1) + @relevantByte
	ELSE
		SET @retVal = @relevantByte
	
	SET @remainderSTR = DATALENGTH(@CurrentValidity) - @byteNum
	
	IF (@remainderSTR > 0)
		SET @retVal = @retVal + SUBSTRING(@CurrentValidity, @byteNum + 1, @remainderSTR)
	
	RETURN @retVal

END
