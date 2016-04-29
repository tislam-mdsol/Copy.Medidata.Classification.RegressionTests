/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyDictionaryRegistrationUpdate')
	DROP PROCEDURE spStudyDictionaryRegistrationUpdate
GO

CREATE PROCEDURE dbo.spStudyDictionaryRegistrationUpdate 
(
	@StudyDictionaryRegistrationID INT,

	@UserID INT,
	@InteractionID INT,
	
	@DictionaryID INT,
	@VersionOrdinal INT,
	@TrackableObjectID INT,
	@SegmentID INT,
	
	@StudyRegistrationTransmissionID INT,
	@StudyDictionaryVersionID INT,
	
	@Created DATETIME,  
	@Updated DATETIME OUTPUT
)  
AS  
  
BEGIN  

	SELECT @Updated = GetUtcDate()  

	UPDATE StudyDictionaryRegistrations
	SET
		UserID = @UserID,
		InteractionID = @InteractionID,
		
		DictionaryID = @DictionaryID,
		VersionOrdinal = @VersionOrdinal,
		TrackableObjectID = @TrackableObjectID,
		SegmentID = @SegmentID,
		
		StudyRegistrationTransmissionID = @StudyRegistrationTransmissionID,
		StudyDictionaryVersionID = @StudyDictionaryVersionID,
		Updated = @Updated
	 WHERE StudyDictionaryRegistrationID = @StudyDictionaryRegistrationID

END

GO  