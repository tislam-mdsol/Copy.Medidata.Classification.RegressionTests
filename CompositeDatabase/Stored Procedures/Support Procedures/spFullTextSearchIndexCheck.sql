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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spFullTextSearchIndexCheck')
	DROP PROCEDURE spFullTextSearchIndexCheck
GO
CREATE PROCEDURE dbo.spFullTextSearchIndexCheck
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @tables TABLE (TableName NVARCHAR(250), TableObjectId INT)
	
	INSERT INTO @tables(TableName) VALUES (N'GroupVerbatimEng')
	INSERT INTO @tables(TableName) VALUES (N'GroupVerbatimJpn')
	
	UPDATE @tables
	SET TableObjectId = object_id(TableName)

	DECLARE @FullTextPropertiesToCheck TABLE(PropName NVARCHAR(250))
	
	INSERT INTO @FullTextPropertiesToCheck VALUES(N'TableFulltextDocsProcessed')
	INSERT INTO @FullTextPropertiesToCheck VALUES(N'TableFulltextFailCount')	
	INSERT INTO @FullTextPropertiesToCheck VALUES(N'TableFulltextItemCount')
	INSERT INTO @FullTextPropertiesToCheck VALUES(N'TableFulltextPendingChanges')	
	INSERT INTO @FullTextPropertiesToCheck VALUES(N'TableFulltextPopulateStatus')
	
	SELECT TableName, PropName, OBJECTPROPERTYEX(TableObjectId, PropName)
	FROM @FullTextPropertiesToCheck
		JOIN @tables
			ON 1 = 1


END
GO 