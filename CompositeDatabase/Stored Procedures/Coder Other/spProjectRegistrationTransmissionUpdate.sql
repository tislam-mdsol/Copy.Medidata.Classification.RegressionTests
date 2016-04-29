IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spProjectRegistrationTransmissionUpdate')
	DROP PROCEDURE spProjectRegistrationTransmissionUpdate
GO

CREATE PROCEDURE dbo.spProjectRegistrationTransmissionUpdate 
(
	@ProjectRegistrationTransmissionID INT,
	
	@UserID INT,
	@StudyProjectID INT,
	@TransmissionResponses nvarchar(max),
	@ProjectRegistrationSucceeded BIT,
	@SegmentId INT,
	@ApplicationIdsUpdatedInTransmission VARCHAR(MAX),
	
	@Updated DATETIME OUTPUT
)  
AS  
  
BEGIN  

	SELECT @Updated = GetUtcDate()  

	UPDATE ProjectRegistrationTransms
	SET
		UserID = @UserID,
		StudyProjectID = @StudyProjectID,
		TransmissionResponses = @TransmissionResponses,
		ProjectRegistrationSucceeded = @ProjectRegistrationSucceeded,
		SegmentId = @SegmentId,
		ApplicationIdsUpdatedInTransmission = @ApplicationIdsUpdatedInTransmission,
		
		Updated = @Updated
	 WHERE ProjectRegistrationTransmissionID = @ProjectRegistrationTransmissionID

END

GO 