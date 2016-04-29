/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author:	Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND NAME = 'spSynonymMigrationMngmntDeleteSynonyms')
	DROP PROCEDURE spSynonymMigrationMngmntDeleteSynonyms
GO
CREATE PROCEDURE dbo.spSynonymMigrationMngmntDeleteSynonyms
(
	@SynonymMigrationMngmtID INT
) WITH RECOMPILE
AS

BEGIN

	SET ROWCOUNT 500

	GT_DELETE_SYNS:
	
	DELETE FROM SegmentedGroupCodingPatterns
	WHERE SynonymManagementID = @SynonymMigrationMngmtID
	
	IF (@@ROWCOUNT > 0)
		GOTO GT_DELETE_SYNS	
	
	SET ROWCOUNT 0
END   