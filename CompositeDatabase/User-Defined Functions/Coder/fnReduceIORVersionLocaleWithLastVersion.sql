
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
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnReduceIORVersionLocaleWithLastVersion ')
	DROP FUNCTION dbo.fnReduceIORVersionLocaleWithLastVersion 
GO


CREATE FUNCTION dbo.fnReduceIORVersionLocaleWithLastVersion ( 
	@localeCount INT,
	@FromVersionOrdinal INT, 
	@CurrentVersionOrdinal INT,
	@ToVersionOrdinal INT,
	@OldIORValidity VARBINARY(100)
) RETURNS VARBINARY(100)
BEGIN

	-- if nonexisting prior IOR - or same ordinal this fn doesnt handle
	IF (@OldIORValidity IS NULL OR DATALENGTH(@OldIORValidity) = 0 OR @CurrentVersionOrdinal = @ToVersionOrdinal)
		RETURN @OldIORValidity
	
	DECLARE @retVal VARBINARY(100)
	SET @retVal = dbo.fnGenerateInitialIORVersionLocale( @localeCount, @FromVersionOrdinal, @ToVersionOrdinal)
	
	-- get the old validity range
	DECLARE @ValidRange TABLE (LocaleOffset INT, VersionOrdinal INT, IsValid BIT)
	DECLARE @localeIndex INT, @versionIndex INT, @IsValid BIT
	
	
	INSERT INTO @ValidRange (LocaleOffset, VersionOrdinal, IsValid)
	SELECT * FROM dbo.fnTranslateIORVersionLocaleValidity (@localeCount, @OldIORValidity, @FromVersionOrdinal, @CurrentVersionOrdinal)


	SET @localeIndex = 0
	-- apply the old validity range
	WHILE (@localeIndex < @localeCount)
	BEGIN
	
		SET @versionIndex = @FromVersionOrdinal
		WHILE (@versionIndex <= @ToVersionOrdinal)
		BEGIN
		
			SELECT @IsValid = IsValid
			FROM @ValidRange
			WHERE LocaleOffset = @localeIndex AND VersionOrdinal = @versionIndex
			
			-- apply the old validity range
			SET @retVal = dbo.fnUpdateValiditySequence(@IsValid, @retVal, @versionIndex, @localeIndex, @FromVersionOrdinal, @ToVersionOrdinal)				
			
			SET @versionIndex = @versionIndex + 1
		END
	
		SET @localeIndex = @localeIndex + 1
	END

	RETURN @retVal

END