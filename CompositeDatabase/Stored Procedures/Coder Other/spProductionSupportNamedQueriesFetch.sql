  /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Sneha Saikumar ssaikumar@mdsol.com
// ------------------------------------------------------------------------------------------------------*/


IF  EXISTS (SELECT null FROM sys.objects WHERE TYPE = 'P' and NAME = 'spProductionSupportNamedQueriesFetch')
DROP PROCEDURE [dbo].[spProductionSupportNamedQueriesFetch]
GO

CREATE PROCEDURE [dbo].[spProductionSupportNamedQueriesFetch]
@queryID int 

AS
	SELECT * FROM ProductionSupportNamedQueries WHERE QueryID=@queryID
GO


