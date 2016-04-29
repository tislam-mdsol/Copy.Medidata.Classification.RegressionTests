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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyMigrationGetTasksWithActivePatterns')
	DROP PROCEDURE spStudyMigrationGetTasksWithActivePatterns
GO

CREATE PROCEDURE dbo.spStudyMigrationGetTasksWithActivePatterns
(
     @StudyDictionaryVersionId INT,	
     @RowNumbers INT,	
	 @LastRowId BIGINT
)
AS  
  
BEGIN  

        SELECT TOP (@RowNumbers) CE.CodingElementId, CP.CodingPath
        FROM CodingElements CE
        WITH (NOLOCK)
        	JOIN StudyMigrationBackup SMB ON CE.CodingElementId = SMB.CodingElementID AND SMB.MigrationChangeType = -1
            JOIN SegmentedGroupCodingPatterns SGCP
                ON SGCP.SegmentedGroupCodingPatternID = CE.AssignedSegmentedGroupCodingPatternId
                AND SGCP.Active = 1
                AND CE.StudyDictionaryVersionId = @StudyDictionaryVersionId
            JOIN CodingPatterns CP
                ON CP.CodingPatternID = SGCP.CodingPatternID
        WHERE CE.CodingElementId > @LastRowId
        ORDER BY CE.CodingElementId ASC

END

GO 