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

-- SELECT dbo.fnNumberOfOccurrences('(', '1.2..4.')

SET NOCOUNT ON
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnNumberOfOccurrences')
	DROP FUNCTION dbo.fnNumberOfOccurrences
GO
CREATE FUNCTION dbo.fnNumberOfOccurrences
(
	@expressionToFind VARCHAR(10),
	@expressionToSearch VARCHAR(1000)
) RETURNS INT
BEGIN

	-- check
	IF (@expressionToSearch IS NULL 
		OR @expressionToFind IS NULL
		OR LEN(@expressionToSearch) = 0
		OR LEN(@expressionToFind) = 0
		)
		RETURN 0

	DECLARE @numOcc INT = 0, @i INT = 0
	
	WHILE (1 = 1)
	BEGIN
		
		SET @i = CHARINDEX(@expressionToFind, @expressionToSearch, @i + 1)
		
		IF (@i = 0)
			BREAK

		SET @numOcc = @numOcc + 1

	END

	RETURN @numOcc

END 