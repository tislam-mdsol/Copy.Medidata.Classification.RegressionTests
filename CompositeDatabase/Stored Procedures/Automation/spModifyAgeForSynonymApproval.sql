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

--spModifyAgeForSynonymApproval 'advil 600 mg', 'mediflex', 3

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spModifyAgeForSynonymApproval')
	DROP PROCEDURE spModifyAgeForSynonymApproval
GO
CREATE PROCEDURE dbo.spModifyAgeForSynonymApproval
(
	@synTermText NVARCHAR(450), 
	@segmentOID NVARCHAR(100),
	@daysToAge INT
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
	
	SELECT @segmentID = SegmentID
	FROM Segments
	WHERE OID = @segmentOID
	
	IF (@segmentID IS NULL)
	BEGIN
		PRINT N'Cannot find segment with OID'+@segmentOID
		RETURN
	END
	
	IF (@synTermText IS NULL OR LEN(@synTermText) <= 0) 
	BEGIN 
		PRINT N'Synonym Term Text cannot be null or empty.'
		RETURN
	END
	
	IF NOT EXISTS (
		SELECT NULL 
		FROM SegmentedGroupCodingPatterns SGCP
		Inner JOIN CodingElements CE
			ON SGCP.SegmentID = @segmentID 
			And SGCP.CodingElementGroupID = CE.CodingElementGroupID
		WHERE  CE.VerbatimTerm = @synTermText And SGCP.SynonymStatus = 1)
	BEGIN
		PRINT N'There are no synonyms matching the criteria.'
		RETURN
	END
	
	-- Everything is good to go
	UPDATE SGCP 
	SET Created = SGCP.Created - @daysToAge , Updated = SGCP.Updated - @daysToAge
	FROM SegmentedGroupCodingPatterns SGCP
		Inner JOIN CodingElements CE
			ON SGCP.SegmentID = @segmentID 
			And SGCP.CodingElementGroupID = CE.CodingElementGroupID
	WHERE  CE.VerbatimTerm = @synTermText And SGCP.SynonymStatus = 1
END 