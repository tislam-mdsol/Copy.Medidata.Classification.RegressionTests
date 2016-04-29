  /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Steve Myers smyers@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spApplicationLoadByAppTypeAppName')
	DROP PROCEDURE spApplicationLoadByAppTypeAppName
GO

CREATE PROCEDURE dbo.spApplicationLoadByAppTypeAppName 
(
	@AppTypeName NVARCHAR(256),
	@AppName NVARCHAR(256)
)  
AS  
  
BEGIN  

-- clean input
IF (@AppTypeName = '')
	SET @AppTypeName = NULL
IF (@AppName = '')
	SET @AppName = NULL

SELECT A.*
	FROM Application A
	INNER JOIN ApplicationType B ON A.ApplicationTypeID = B.ApplicationTypeID
	WHERE
		A.Deleted = 0 AND B.Deleted = 0
		-- filter on Application Type if supplied
		AND (@AppTypeName IS NULL OR @AppTypeName = B.Name)
		-- filter on Application Name if supplied
		AND (@AppName IS NULL OR @AppName = A.Name)

END

GO
