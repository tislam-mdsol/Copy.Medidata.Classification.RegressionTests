/* 
** Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Altin Vardhami [avardhami@mdsol.com]
**/ 

SET NOCOUNT ON
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnRemoveWhiteSpace')
	DROP FUNCTION dbo.fnRemoveWhiteSpace
GO

--SELECT dbo.fnRemoveWhiteSpace('aa    bb bbvv    ccc')

CREATE FUNCTION dbo.fnRemoveWhiteSpace
(
	@VerbatimText NVARCHAR(450)
) RETURNS NVARCHAR(450)
AS
BEGIN

	-- line break chars		
	DECLARE @c13 CHAR(1) = CHAR(13), @c10 CHAR(1) = CHAR(10), @c9 CHAR(1) = CHAR(9)

	-- process the verbatims so that quoted ones are handled exactly the same as unquoted ones
	DECLARE @simplifiedVerbatim NVARCHAR(450) = REPLACE(REPLACE(REPLACE(@VerbatimText, @c9, ' '), @c10, ' '), @c13, ' ')

	WHILE (CHARINDEX('  ', @simplifiedVerbatim, 0) > 0)
		SET @simplifiedVerbatim = REPLACE(@simplifiedVerbatim, '  ', ' ')

	RETURN LTRIM(RTRIM(@simplifiedVerbatim))
	
END
GO