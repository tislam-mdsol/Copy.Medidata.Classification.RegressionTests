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

IF object_id('fnGetLastQueryUUID') IS NOT NULL
	DROP FUNCTION dbo.fnGetLastQueryUUID
GO

--SELECT * FROM dbo.fnGetLastQueryUUID('<TaskUUID>', '<SegmentOID>')

CREATE FUNCTION dbo.fnGetLastQueryUUID
(
    @TaskUUID NVARCHAR(100),
    @SegmentOID VARCHAR(50)
)
RETURNS TABLE
AS

	RETURN 
	SELECT TOP 1 QueryUUID
	FROM CoderQueries
	WHERE CodingElementId = (SELECT CodingElementId 
				FROM CodingElements 
				WHERE UUID = @TaskUUID
					AND SegmentId = (SELECT SegmentID FROM Segments WHERE OID = @SegmentOID)
				)
	ORDER BY QueryID DESC
		