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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyDictionaryRegistrationInsert')
	BEGIN
		DROP  Procedure  spStudyDictionaryRegistrationInsert
	END

GO

CREATE Procedure dbo.spStudyDictionaryRegistrationInsert
(
	@UserID INT,
	@InteractionID INT,
	
	@DictionaryID INT,
	@VersionOrdinal INT,
	@TrackableObjectID INT,
	@SegmentID INT,
	
	@StudyRegistrationTransmissionID INT,
	@StudyDictionaryVersionID INT,
	
	@Created DATETIME OUTPUT,
	@Updated DATETIME OUTPUT,
	@StudyDictionaryRegistrationID INT OUTPUT
)
AS

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
  
	INSERT INTO StudyDictionaryRegistrations (  
		UserID,
		InteractionID,
		
		DictionaryID,
		VersionOrdinal,
		TrackableObjectID,
		SegmentID,
		
		StudyRegistrationTransmissionID,
		StudyDictionaryVersionID,
		
		Created,
		Updated
	) VALUES (  
		@UserID,
		@InteractionID,
		
		@DictionaryID,
		@VersionOrdinal,
		@TrackableObjectID,
		@SegmentID,
		
		@StudyRegistrationTransmissionID,
		@StudyDictionaryVersionID,

		@Created,
		@Updated
	)  
	
	SET @StudyDictionaryRegistrationID = SCOPE_IDENTITY()  	
	
END
GO
  