/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

--spSegmentedGroupCodingPatternLoadByCodingElementIDs '5880', ';'
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentedGroupCodingPatternLoadByCodingElementIDs')
	DROP PROCEDURE spSegmentedGroupCodingPatternLoadByCodingElementIDs
GO

CREATE PROCEDURE dbo.spSegmentedGroupCodingPatternLoadByCodingElementIDs 
(
	@CodingElementIds VARCHAR(MAX),
	@Delimiter CHAR(1)
)  
AS  
BEGIN

	DECLARE @IDTable TABLE(CodingElementID BIGINT PRIMARY KEY)
	
	INSERT INTO @IDTable
	SELECT CAST(Item AS INT)
	FROM dbo.fnParseDelimitedString(@CodingElementIds, @Delimiter)

	SELECT SGCP.*
	FROM @IDTable IT
		JOIN CodingElements CE
			ON IT.CodingElementID = CE.CodingElementID
		JOIN SegmentedGroupCodingPatterns SGCP
			ON CE.AssignedSegmentedGroupCodingPatternId = SGCP.SegmentedGroupCodingPatternID
			AND SGCP.Active = 1


END

GO   