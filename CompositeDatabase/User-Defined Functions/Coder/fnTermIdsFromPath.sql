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
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TF' AND name = 'fnTermIdsFromPath')
	DROP FUNCTION dbo.fnTermIdsFromPath
GO

CREATE FUNCTION dbo.fnTermIdsFromPath
(
	@NodePath VARCHAR(MAX)
) RETURNS @TermIDs TABLE(RowNumber INT IDENTITY(1,1), TermID BIGINT)
AS
BEGIN

	DECLARE @priorI INT, @nextI INT, @delimiter CHAR(1) = '.'

	IF (@NodePath IS NULL)
	RETURN
    
    SET @priorI = CHARINDEX(@delimiter, @NodePath) + 1
    SET @nextI = CHARINDEX(@delimiter, @NodePath, @priorI)
	
    WHILE (@nextI > @priorI)
    BEGIN

        INSERT INTO @TermIDs(TermID)
        SELECT CAST(SUBSTRING(@NodePath, @priorI, @nextI - @priorI) AS BIGINT)

        SET @priorI = CHARINDEX(@delimiter, @NodePath, @nextI + 1) + 1

		IF (@priorI > @nextI)
	        SET @nextI = CHARINDEX(@delimiter, @NodePath, @priorI)
	    ELSE 
			SET @nextI = 0	        
    END	
    			
	RETURN
	
END
GO