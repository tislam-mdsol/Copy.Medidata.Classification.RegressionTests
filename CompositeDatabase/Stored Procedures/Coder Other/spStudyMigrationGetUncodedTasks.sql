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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyMigrationGetUncodedTasks')
	DROP PROCEDURE spStudyMigrationGetUncodedTasks
GO

CREATE PROCEDURE dbo.spStudyMigrationGetUncodedTasks 
(
    @StudyDictionaryVersionId INT,
    @RowNumbers INT,
    @LastRowId BIGINT
)
AS  
  
BEGIN  

    SELECT TOP (@rowNumbers) CE.CodingElementId
    FROM CodingElements CE
    WITH (NOLOCK)
		JOIN StudyMigrationBackup SMB ON CE.CodingElementId = SMB.CodingElementID AND SMB.MigrationChangeType = -1
    WHERE CE.StudyDictionaryVersionId = @StudyDictionaryVersionId
        AND AssignedSegmentedGroupCodingPatternId = -1
        AND IsInvalidTask = 0
        AND	CE.CodingElementId > @LastRowId
    ORDER BY CodingElementId ASC

END

GO 