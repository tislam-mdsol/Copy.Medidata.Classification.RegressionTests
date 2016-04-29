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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnCleanVerbatimForCorrelation')
	DROP FUNCTION dbo.fnCleanVerbatimForCorrelation
GO
CREATE FUNCTION dbo.fnCleanVerbatimForCorrelation
(
	@UnNormalizedVerbatim NVARCHAR(MAX)
) RETURNS NVARCHAR(MAX)
AS
BEGIN
	
	RETURN LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(@UnNormalizedVerbatim, CHAR(13),''), CHAR(10),''), CHAR(9),''), CHAR(8),'')))
END

