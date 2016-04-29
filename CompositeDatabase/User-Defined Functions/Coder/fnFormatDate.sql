 /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2008, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Jalal Uddin juddin@mdsol.com
//
// Formats a datetime according to a mask passed in.
// COLLATE SQL_Latin1_General_CP1_CS_AS  tells SQL to be case sensitive
// ------------------------------------------------------------------------------------------------------*/
/* Test Code
	SELECT dbo.fnFormatDate (getdate(), 'MM/DD/YYYY')           
	SELECT dbo.fnFormatDate (getdate(), 'DD/MM/YYYY')           
	SELECT dbo.fnFormatDate (getdate(), 'M/DD/YYYY')            
	SELECT dbo.fnFormatDate (getdate(), 'M/D/YYYY')             
	SELECT dbo.fnFormatDate (getdate(), 'M/D/YY')               
	SELECT dbo.fnFormatDate (getdate(), 'MM/DD/YY')             
	SELECT dbo.fnFormatDate (getdate(), 'MON DD, YYYY')         
	SELECT dbo.fnFormatDate (getdate(), 'Mon DD, YYYY')         
	SELECT dbo.fnFormatDate (getdate(), 'Month DD, YYYY')       
	SELECT dbo.fnFormatDate (getdate(), 'YYYY/MM/DD')           
	SELECT dbo.fnFormatDate (getdate(), 'YYYYMMDD')             
	SELECT dbo.fnFormatDate (getdate(), 'YYYY-MM-DD')           
*/
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnFormatDate') BEGIN
	DROP FUNCTION dbo.fnFormatDate
END
GO

CREATE FUNCTION [dbo].[fnFormatDate] 
( 
	@Datetime DATETIME,			-- DateTime you want formatted
	@FormatMask VARCHAR(64)		-- String mask of how you want the date to look (MM/DD/YYYY hh:mm:ss ampm)
)	RETURNS VARCHAR(64)			-- String representation of the formatted date/time
AS
BEGIN

	DECLARE @StringDate VARCHAR(64) ,@Month VARCHAR(12) ,@MON VARCHAR(3)
	SET @StringDate = @FormatMask

	--Special Codes (Codes that return more letters)
	--------------------------------------------------------------------------------
	IF (CHARINDEX ('Month', @StringDate) > 0)
		SET @StringDate = REPLACE(@StringDate, 'Month', '|Q|')

	IF (CHARINDEX ('MON', @StringDate) > 0)
		SET @StringDate = REPLACE(@StringDate, 'MON', '|E|')

	IF (CHARINDEX ('AMPM', @StringDate COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)
		SET @StringDate = REPLACE(@StringDate, 'AMPM' COLLATE SQL_Latin1_General_CP1_CS_AS, '|X|')

	IF (CHARINDEX ('ampm', @StringDate COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)
		SET @StringDate = REPLACE(@StringDate, 'ampm' COLLATE SQL_Latin1_General_CP1_CS_AS, '|x|')

	--DATE
	--------------------------------------------------------------------------------
	IF (CHARINDEX ('YYYY', @StringDate) > 0)
		SET @StringDate = REPLACE(@StringDate, 'YYYY', DATENAME(YY, @Datetime))

	IF (CHARINDEX ('YY', @StringDate) > 0)
		SET @StringDate = REPLACE(@StringDate, 'YY', RIGHT(DATENAME(YY, @Datetime),2))

	IF (CHARINDEX ('MM', @StringDate COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)
		SET @StringDate = REPLACE(@StringDate, 'MM' COLLATE SQL_Latin1_General_CP1_CS_AS, RIGHT('0'+CONVERT(VARCHAR,DATEPART(MM, @Datetime)),2))

	IF (CHARINDEX ('M', @StringDate COLLATE SQL_Latin1_General_CP1_CS_AS) > 0)
		SET @StringDate = REPLACE(@StringDate, 'M' COLLATE SQL_Latin1_General_CP1_CS_AS, CONVERT(VARCHAR,DATEPART(MM, @Datetime)))

	IF (CHARINDEX ('DD', @StringDate) > 0)
		SET @StringDate = REPLACE(@StringDate, 'DD', RIGHT('0'+DATENAME(DD, @Datetime),2))

	IF (CHARINDEX ('D', @StringDate) > 0)
		SET @StringDate = REPLACE(@StringDate, 'D', DATENAME(DD, @Datetime))

	--TIME
	--------------------------------------------------------------------------------
	IF (CHARINDEX ('hh', @StringDate) > 0)
		SET @StringDate = REPLACE(@StringDate, 'hh', RIGHT('0'+CONVERT(VARCHAR,DATEPART(HH, @Datetime)),2))

	IF (CHARINDEX ('h', @StringDate) > 0)
		SET @StringDate = REPLACE(@StringDate, 'h', DATEPART(HH, @Datetime))

	IF (CHARINDEX ('mm', @StringDate) > 0)
		SET @StringDate = REPLACE(@StringDate, 'mm', RIGHT('0'+CONVERT(VARCHAR,DATEPART(mi, @Datetime)),2))

	IF (CHARINDEX ('m', @StringDate) > 0)
		SET @StringDate = REPLACE(@StringDate, 'm', DATEPART(mi, @Datetime))

	IF (CHARINDEX ('ss', @StringDate) > 0)
		SET @StringDate = REPLACE(@StringDate, 'ss', RIGHT('0'+CONVERT(VARCHAR,DATEPART(ss, @Datetime)),2))

	IF (CHARINDEX ('s', @StringDate) > 0)
		SET @StringDate = REPLACE(@StringDate, 's', DATEPART(ss, @Datetime))

	-- Special Codes
	-- Must be done last because they replace the code with letters that could be seen as another code ('m')
	--------------------------------------------------------------------------------
	IF (CHARINDEX ('|Q|', @StringDate) > 0)
		SET @StringDate = REPLACE(@StringDate, '|Q|', DATENAME(MM, @Datetime))

	IF (CHARINDEX ('|E|', @StringDate) > 0)
		SET @StringDate = REPLACE(@StringDate, '|E|', LEFT(DATENAME(MM, @Datetime),3))

	IF (CHARINDEX ('|X|', @StringDate) > 0) BEGIN
		DECLARE @AMPM VARCHAR(2)
		IF DATEPART(hour, @Datetime) > 12
			SET @AMPM = 'pm'
		ELSE
			SET @AMPM = 'am'

		IF CHARINDEX ('|X|', @StringDate COLLATE SQL_Latin1_General_CP1_CS_AS) > 0
			SET @AMPM = UPPER(@AMPM)

		SET @StringDate = REPLACE(@StringDate, '|X|', @AMPM)
	END

	RETURN @StringDate
END
GO



