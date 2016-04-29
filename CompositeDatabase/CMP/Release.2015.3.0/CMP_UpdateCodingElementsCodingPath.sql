/* ------------------------------------------------------------------------------------------------------
// Updates the CodingElements.AssignedCodingPath to the new S3 string
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCMPUpdateCodingElementsCodingPath')
	DROP PROCEDURE spCMPUpdateCodingElementsCodingPath
GO

CREATE PROCEDURE dbo.spCMPUpdateCodingElementsCodingPath  
AS
BEGIN

	-- should take a few minutes (<2)
	UPDATE CE
	SET CE.AssignedCodingPath = CP.CodingPath
	FROM CodingElements CE
		JOIN SegmentedGroupCodingPatterns SGCP
			ON CE.AssignedSegmentedGroupCodingPatternId = SGCP.SegmentedGroupCodingPatternID
		JOIN CodingPatterns CP
			ON CP.CodingPatternId = SGCP.CodingPatternID
END 
