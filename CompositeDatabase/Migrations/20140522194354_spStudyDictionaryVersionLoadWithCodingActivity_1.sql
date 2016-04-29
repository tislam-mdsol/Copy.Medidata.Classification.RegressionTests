/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'spStudyDictionaryVersionLoadWithCodingActivity' AND type = 'P')
DROP PROCEDURE spStudyDictionaryVersionLoadWithCodingActivity
GO

CREATE PROCEDURE [dbo].[spStudyDictionaryVersionLoadWithCodingActivity]  
(  
  @ProjectID INT
)  
AS 

	SELECT SDV.*
	FROM StudyDictionaryVersion SDV
		JOIN TrackableObjects tos 
			ON SDV.StudyID = tos.TrackableObjectID
			AND StudyProjectID = @ProjectID
	WHERE EXISTS (SELECT NULL FROM CodingElements CE
				  WHERE CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionId
					 )

GO
