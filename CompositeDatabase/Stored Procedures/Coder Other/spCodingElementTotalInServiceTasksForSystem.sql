/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Connor Ross cross@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementTotalInServiceTasksForSystem')
	DROP Procedure spCodingElementTotalInServiceTasksForSystem
GO

CREATE PROCEDURE [dbo].spCodingElementTotalInServiceTasksForSystem
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT COUNT(*) AS TotalTasks 
	FROM CodingElements CE
	WHERE IsStillInService = 1

END	