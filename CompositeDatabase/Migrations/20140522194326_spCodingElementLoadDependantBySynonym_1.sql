/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementLoadDependantBySynonym')
	DROP PROCEDURE spCodingElementLoadDependantBySynonym
GO

CREATE PROCEDURE dbo.spCodingElementLoadDependantBySynonym(
	@SegmentedCodingPatternID BIGINT,
	@CodingElementGroupID BIGINT,
	@SynonymManagementID INT,
	@lastId BIGINT
)
AS
BEGIN

	SELECT TOP (100) CE.*
	FROM CodingElements CE
		JOIN StudyDictionaryVersion SDV
			ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionId
			AND SDV.SynonymManagementID = @SynonymManagementID
			-- NOTE: ignore locked studies
			AND SDV.StudyLock = 1
	WHERE @CodingElementGroupID = CodingElementGroupID
		AND IsInvalidTask = 0
		AND AssignedSegmentedGroupCodingPatternID IN (-1, @SegmentedCodingPatternID)
		AND CodingElementId > @LastID
	ORDER BY CodingElementId ASC
		

END
GO 
 