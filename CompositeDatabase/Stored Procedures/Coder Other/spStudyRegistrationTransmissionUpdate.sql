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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyRegistrationTransmissionUpdate')
	DROP PROCEDURE spStudyRegistrationTransmissionUpdate
GO

CREATE PROCEDURE dbo.spStudyRegistrationTransmissionUpdate 
(
	@StudyRegistrationTransmissionID INT,
	
	@UserID INT,
	@TrackableObjectID INT,
		
	@TransmissionResponses NVARCHAR(MAX),
		
	@StudyRegistrationSucceeded BIT,
	@SegmentID INT,
	
	@Created DATETIME,  
	@Updated DATETIME OUTPUT
)  
AS  
  
BEGIN  

	SELECT @Updated = GetUtcDate()  

	UPDATE StudyRegistrationTransmissions
	SET
		--UserID = @UserID,
		--TrackableObjectID = @TrackableObjectID,
			
		TransmissionResponses = @TransmissionResponses,
			
		StudyRegistrationSucceeded = @StudyRegistrationSucceeded,
		--SegmentID = @SegmentID,
		
		Updated = @Updated
	 WHERE StudyRegistrationTransmissionID = @StudyRegistrationTransmissionID

END

GO  