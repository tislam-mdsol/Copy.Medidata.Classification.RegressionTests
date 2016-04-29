 /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spWorkflowTaskGetDecisionsByCodingElementIDs')
	DROP PROCEDURE spWorkflowTaskGetDecisionsByCodingElementIDs
GO
CREATE PROCEDURE dbo.spWorkflowTaskGetDecisionsByCodingElementIDs(
	@CodingElementIds VARCHAR(MAX),
	@Delimiter CHAR(1),
	@SegmentID INT
)
AS

	DECLARE @IDTable TABLE(CodingElementID BIGINT PRIMARY KEY)
	
	INSERT INTO @IDTable
	SELECT CAST(Item AS BIGINT)
	FROM dbo.fnParseDelimitedString(@CodingElementIds, @Delimiter)

	SELECT CE.*
	FROM CodingElements CE
		JOIN @IDTable IT
			ON IT.CodingElementID = CE.CodingElementID
	
GO 
