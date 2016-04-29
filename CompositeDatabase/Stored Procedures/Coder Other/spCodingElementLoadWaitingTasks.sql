/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Bonnie Pan bpan@mdsol.com
// ------------------------------------------------------------------------------------------------------*/
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementLoadWaitingTasks')
	DROP Procedure spCodingElementLoadWaitingTasks
GO

CREATE PROCEDURE [dbo].spCodingElementLoadWaitingTasks
(
	@MaxFailureCount INT,
	@WorkflowStatesToPickup WorkflowStateIds_UDT READONLY
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--pick up tasks for workflow to process(failure count < max)
	SELECT SegmentId, COUNT(*) AS TotalTasks 
	FROM CodingElements CE
		JOIN @WorkflowStatesToPickup W ON CE.WorkflowStateID = W.WorkflowStateID
	WHERE FailureCount < @MaxFailureCount
		  AND IsStillInService = 0
	GROUP BY SegmentId
	OPTION (RECOMPILE)

END	