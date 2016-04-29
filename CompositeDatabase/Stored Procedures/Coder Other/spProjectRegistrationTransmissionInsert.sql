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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spProjectRegistrationTransmissionInsert')
	BEGIN
		DROP  Procedure  spProjectRegistrationTransmissionInsert
	END

GO

CREATE Procedure dbo.spProjectRegistrationTransmissionInsert
(
	@UserID INT,
	@StudyProjectID INT,
	@TransmissionResponses nvarchar(max),
	@ProjectRegistrationSucceeded BIT,
	@SegmentId INT,
	@ApplicationIdsUpdatedInTransmission VARCHAR(MAX),
	
	@Created DATETIME OUTPUT,
	@Updated DATETIME OUTPUT,
	@ProjectRegistrationTransmissionID INT OUTPUT

)
AS

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
  
	INSERT INTO ProjectRegistrationTransms (  
		UserID,
		StudyProjectID,
		TransmissionResponses,
		ProjectRegistrationSucceeded,
		SegmentId,
		ApplicationIdsUpdatedInTransmission,
		
		Created,
		Updated
	) VALUES (  
		@UserID,
		@StudyProjectID,
		@TransmissionResponses,
		@ProjectRegistrationSucceeded,
		@SegmentId,
		@ApplicationIdsUpdatedInTransmission,
		
		@Created,
		@Updated
	)  
	
	SET @ProjectRegistrationTransmissionID = SCOPE_IDENTITY()  	
	
END
GO
  