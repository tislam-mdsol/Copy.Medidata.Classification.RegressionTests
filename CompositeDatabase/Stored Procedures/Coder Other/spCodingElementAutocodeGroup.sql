/**
** Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Altin Vardhami avardhami@mdsol.com
**/

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingElementAutocodeGroup')
	DROP PROCEDURE spCodingElementAutocodeGroup
GO

CREATE PROCEDURE dbo.spCodingElementAutocodeGroup
(
	@CodingElementID BIGINT
)
AS
BEGIN

	-- TODO : handle the cases when there's more THAN 1 HIT
	DECLARE @segmentedGroupCodingPatternID BIGINT
	
	SELECT TOP 1 @segmentedGroupCodingPatternID = SGCP.SegmentedGroupCodingPatternId
	FROM SegmentedGroupCodingPatterns SGCP
		JOIN CodingElements CE
			ON SGCP.CodingElementGroupID = CE.CodingElementGroupID
			AND CE.SegmentID = SGCP.SegmentID
			AND SGCP.SynonymStatus = 2
			AND SGCP.Active = 1
			AND CE.CodingElementID = @CodingElementID
		JOIN StudyDictionaryVersion SDV
			ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionId
			AND SGCP.SynonymManagementID = SDV.SynonymManagementID
	ORDER BY SGCP.Created ASC

	SELECT ISNULL(@segmentedGroupCodingPatternID, -1)

END
GO

SET NOCOUNT OFF
GO
 