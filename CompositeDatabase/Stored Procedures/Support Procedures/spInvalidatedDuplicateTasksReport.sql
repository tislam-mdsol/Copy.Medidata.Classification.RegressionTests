/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
//
// Reports on Invalidated tasks that have been identified as duplicates by the duplicate detection script
// Can be invoked separately from the invalidation script.
// ------------------------------------------------------------------------------------------------------*/

-- EXEC spInvalidatedDuplicateTasksReport

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spInvalidatedDuplicateTasksReport')
	DROP PROCEDURE spInvalidatedDuplicateTasksReport
GO
CREATE PROCEDURE dbo.spInvalidatedDuplicateTasksReport
(
	@StartDatetime DATETIME = NULL, -- unbound
	@EndDateTime DATETIME = NULL -- unbound
)
AS
BEGIN

	-- TBD - decide what to report on
	SELECT 
		IT.Created AS InvalidatedOn,
		CE.VerbatimTerm AS Verbatim,
		CE.CodingElementId
		-- TODO : unknown
	FROM InvalidatedTasks IT
		JOIN CodingElements CE
			ON CE.CodingElementId = IT.CodingElementId
			-- time interval constraint
			AND IT.Created BETWEEN ISNULL(@StartDatetime, IT.Created) AND ISNULL(@EndDateTime, IT.Created)

END
GO