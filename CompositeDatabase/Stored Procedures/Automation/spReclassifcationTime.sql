/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// required by automation
// ------------------------------------------------------------------------------------------------------*/

--Store Procedure to enable a backwards leap in the numbe of days in the Reclassification
--table for the Created date for a verbatim term. Takes 3 parameters being Segment,
--verbatim Term, and the number of days you want to be subtracted from the current date.
 
--EXEC spReclassifcationTime 'Mediflex1', 'Aspirin Plus C', 1
IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spReclassificationTime')
	DROP PROCEDURE spReclassificationTime
GO
CREATE PROCEDURE spReclassificationTime
(
    @SegmentOID NVARCHAR(100),
    @VerbatimTerm NVARCHAR(450),
    @DaysBack INT
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
    
    DECLARE @codingAssignmentID INT, @codingElementID INT
    
    SELECT @codingAssignmentID = CA.CodingAssignmentID, @codingElementID = CE.CodingElementId
    FROM CodingAssignment CA
        JOIN CodingElements CE
            ON CA.CodingElementID = CE.CodingElementID
            AND CA.Active = 1
            AND CE.SegmentId = @segmentID
    WHERE CE.VerbatimTerm = @VerbatimTerm

	-- update ALL workflow actions associated with this coding element
	UPDATE WorkflowTaskHistory
	SET Created = Created - @DaysBack
	WHERE WorkflowTaskID = @codingElementID
	

    UPDATE CodingAssignment
    SET Created = Created - @DaysBack
    WHERE CodingAssignmentID = @codingAssignmentID

END
