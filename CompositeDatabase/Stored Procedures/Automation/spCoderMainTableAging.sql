/* ------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of
// this file may not be disclosed to third parties, copied or duplicated in
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Jose De Jesus jdejesus@mdsol.com
// coAuthor: Altin Vardhami avardhami@mdsol.com
// required by automation
// ------------------------------------------------------------------------------------------------------*/

-- Store procedure to age the Task Page Dates
-- Takes 3 parameters being verbatim Term, Segment OID, and the number of days you want to be subtracted from the current date.

--EXEC spCoderMainTableAging  'Aspirin Plus C', 'Mediflex1', 1

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCoderMainTableAging')
	DROP PROCEDURE spCoderMainTableAging
GO

CREATE PROCEDURE spCoderMainTableAging
(
    @VerbatimTerm NVARCHAR(100),
    @SegmentOID VARCHAR(450),
    @offSet DECIMAL(10,2)
)
AS

BEGIN

 --production check
 IF NOT EXISTS (
		SELECT NULL 
		FROM CoderAppConfiguration
		WHERE Active = 1 AND IsProduction = 0)
BEGIN
	PRINT N'THIS IS A PRODUCTION ENVIRONMENT - Test Script cannot proceed!'
	RETURN
END

    DECLARE @segmentID INT

    SELECT @segmentID = SegmentId
    FROM Segments
    WHERE OID = @SegmentOID

    IF (@segmentID IS NULL)
    BEGIN
        PRINT N'Cannot find segment'
        RETURN
    END

	update codingelements
	set Created = Created - @offSet
	where VerbatimTerm = @VerbatimTerm 
		and SegmentId = @segmentID

END 