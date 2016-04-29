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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyRegistrationTransmissionInsert')
	BEGIN
		DROP  Procedure  spStudyRegistrationTransmissionInsert
	END

GO

CREATE Procedure dbo.spStudyRegistrationTransmissionInsert
(
	@UserID INT,
	@TrackableObjectID INT,
		
	@TransmissionResponses NVARCHAR(MAX),
		
	@StudyRegistrationSucceeded BIT,
	@SegmentID INT,
	
	@Created DATETIME OUTPUT,
	@Updated DATETIME OUTPUT,
	@StudyRegistrationTransmissionID INT OUTPUT
)
AS

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
  
	INSERT INTO StudyRegistrationTransmissions (  
		UserID,
		TrackableObjectID,
		TransmissionResponses,
		StudyRegistrationSucceeded,
		SegmentID,
		
		Created,
		Updated
	) VALUES (  
		@UserID,
		@TrackableObjectID,
		@TransmissionResponses,
		@StudyRegistrationSucceeded,
		@SegmentID,
		
		@Created,
		@Updated
	)  
	
	SET @StudyRegistrationTransmissionID = SCOPE_IDENTITY()  	
	
END
GO
  