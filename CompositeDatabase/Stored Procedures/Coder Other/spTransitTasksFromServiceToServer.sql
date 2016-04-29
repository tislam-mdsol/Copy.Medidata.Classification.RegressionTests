/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spTransitTasksFromServiceToServer')
	DROP PROCEDURE spTransitTasksFromServiceToServer
GO
CREATE PROCEDURE dbo.spTransitTasksFromServiceToServer
(
	@CodingElementIds VARCHAR(MAX)
)
AS
BEGIN

	UPDATE CE
	SET CE.IsStillInService = 0
	FROM
	(SELECT CAST(Item AS INT) AS CodingElementID
	FROM dbo.fnParseDelimitedString(@CodingElementIds,',')) FN
		JOIN CodingElements CE
			ON CE.CodingElementID = FN.CodingElementID
			AND CE.IsStillInService = 1 -- check for service ownership

END	
GO  
  