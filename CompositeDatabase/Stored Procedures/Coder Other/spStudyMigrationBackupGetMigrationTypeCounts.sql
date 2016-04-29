/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Steve Myers smyers@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyMigrationBackupGetMigrationTypeCounts')
	DROP PROCEDURE spStudyMigrationBackupGetMigrationTypeCounts
GO

CREATE PROCEDURE dbo.spStudyMigrationBackupGetMigrationTypeCounts 
(
    @StudyDictionaryVersionId INT
)
AS  
  
BEGIN  

    SELECT MigrationChangeType, COUNT(MigrationChangeType) AS Count
    FROM StudyMigrationBackup
    WHERE StudyDictionaryVersionId = @StudyDictionaryVersionId
	GROUP BY MigrationChangeType

END

GO 