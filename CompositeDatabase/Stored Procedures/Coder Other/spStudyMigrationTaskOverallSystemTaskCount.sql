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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyMigrationTaskOverallSystemTaskCount')
	DROP PROCEDURE spStudyMigrationTaskOverallSystemTaskCount
GO

CREATE PROCEDURE dbo.spStudyMigrationTaskOverallSystemTaskCount 
AS  
  
BEGIN  

    SELECT Count(*)
    FROM CodingElements CE
    WITH (NOLOCK)
		JOIN StudyMigrationBackup SMB ON CE.CodingElementId = SMB.CodingElementID AND SMB.MigrationChangeType = -1
    WHERE IsInvalidTask = 0

END

GO 