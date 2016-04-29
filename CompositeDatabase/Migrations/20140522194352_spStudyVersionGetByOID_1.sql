 /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyVersionGetByOID')
	DROP PROCEDURE spStudyVersionGetByOID
GO
CREATE PROCEDURE dbo.spStudyVersionGetByOID(
	@medicalDictionaryID BIGINT,
	@locale VARCHAR(3),
	@studyOID VARCHAR(100)
)
AS
	
	SELECT sdv.*
	FROM StudyDictionaryVersion sdv
		JOIN TrackableObjects tos
			ON tos.TrackableObjectID = sdv.StudyID
			AND tos.ExternalObjectOID = @studyOID
			AND sdv.MedicalDictionaryID = @MedicalDictionaryID
			AND sdv.DictionaryLocale = @locale
		JOIN ExternalObjectTypeR eotr
			ON eotr.ExternalObjectTypeID = tos.ExternalObjectTypeID
			AND ObjectTypeName = 'CodingStudy'

GO 