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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementGetDecisionCountsBySynonymIDs')
	DROP PROCEDURE spCodingElementGetDecisionCountsBySynonymIDs
GO
CREATE PROCEDURE dbo.spCodingElementGetDecisionCountsBySynonymIDs(
	@TermIds VARCHAR(MAX),
	@Delimiter CHAR(1),
	@completedCount INT OUTPUT,
	@inProcessCount INT OUTPUT
)
AS

	DECLARE @TermIDTable TABLE(TermID BIGINT PRIMARY KEY)
	
	INSERT INTO @TermIDTable
	SELECT CAST(Item AS BIGINT)
	FROM dbo.fnParseDelimitedString(@TermIds, @Delimiter)

	SELECT 
		@completedCount = ISNULL(SUM(CASE WHEN WS.IsTerminalState = 1 THEN 1 ELSE 0 END), 0),
		@inProcessCount = ISNULL(SUM(CASE WHEN WS.IsTerminalState = 0 THEN 1 ELSE 0 END), 0)
	FROM CodingElements CE
		JOIN @TermIDTable TT
			ON TT.TermID = CE.AssignedSegmentedGroupCodingPatternID
			AND CE.IsInvalidTask = 0
		JOIN WorkflowStates WS
			ON CE.WorkflowStateID = WS.WorkflowStateID

GO 
 