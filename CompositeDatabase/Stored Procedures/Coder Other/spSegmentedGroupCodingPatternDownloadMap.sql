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

-- WILL YIELD A SNAPSHOT DOWNLOAD MAP
-- Actual Download may not yield complete Synonym List at a given time
-- Rather, it will be the mapped list at the time of this snapshot

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentedGroupCodingPatternDownloadMap')
	DROP PROCEDURE spSegmentedGroupCodingPatternDownloadMap
GO

CREATE PROCEDURE dbo.spSegmentedGroupCodingPatternDownloadMap
(
	@SynonymManagementID BIGINT,
	@MaxCount INT,
	@IsAutoApproval BIT,
	@ForcePrimaryPath BIT
)  
AS  
BEGIN

	;WITH xCTE AS
	(
		SELECT SegmentedGroupCodingPatternID, 
			ROW_NUMBER() OVER (ORDER BY SegmentedGroupCodingPatternID DESC) AS RowNum
		FROM SegmentedGroupCodingPatterns SGCP
			JOIN CodingPatterns CP
				ON SGCP.CodingPatternID = CP.CodingPatternID
		WHERE SGCP.SynonymManagementID = @SynonymManagementID
			AND SGCP.Active = 1
			AND dbo.fnIsValidForAutoCodeIncludingProvisional(@IsAutoApproval, @ForcePrimaryPath, SGCP.IsExactMatch, SGCP.SynonymStatus, CP.PathCount) = 1
	)

	SELECT *
	FROM xCTE
	WHERE RowNum % @MaxCount = 0 OR RowNum = 1
	ORDER BY RowNum ASC

END

GO