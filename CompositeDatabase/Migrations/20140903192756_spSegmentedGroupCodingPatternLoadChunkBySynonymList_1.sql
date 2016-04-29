/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentedGroupCodingPatternLoadChunkBySynonymList')
	DROP PROCEDURE spSegmentedGroupCodingPatternLoadChunkBySynonymList
GO

CREATE PROCEDURE dbo.spSegmentedGroupCodingPatternLoadChunkBySynonymList
(
	@SynonymManagementID BIGINT,
	@maxId BIGINT,
	@minId BIGINT,
	@IsAutoApproval BIT,
	@ForcePrimaryPath BIT
)  
AS  
BEGIN

	SELECT  SegmentedGroupCodingPatternID
	       ,CodingElementGroupID
	       ,SGCP.CodingPatternID
	       ,SegmentID
	       ,MatchPercent
	       ,Active
	       ,SGCP.Created SegmentedGroupCodingPatternCreated
	       ,SGCP.Updated SegmentedGroupCodingPatternUpdated
	       ,SynonymManagementID
	       ,CacheVersion
	       ,UserID
	       ,SynonymStatus
	       ,IsExactMatch
	       ,CodingPath
	       ,CP.Created CodingPatternCreated
	       ,CP.Updated CodingPatternUpdated
	       ,DictionaryLevelID
	       ,PathCount 
	FROM SegmentedGroupCodingPatterns SGCP
		LEFT JOIN CodingPatterns CP
			ON SGCP.CodingPatternID = CP.CodingPatternID
			AND SGCP.IsExactMatch = 1
			AND (CP.PathCount = 1 OR @ForcePrimaryPath = 1)
	WHERE SynonymManagementID = @SynonymManagementID
		AND SegmentedGroupCodingPatternID > @minId
		AND SegmentedGroupCodingPatternID <= @maxId
		AND Active = 1
		AND SynonymStatus > 0
		AND (@IsAutoApproval = 0 OR CP.CodingPatternID IS NULL)

END

GO