IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spProjectDictionaryRegistrationUpdate')
	DROP PROCEDURE spProjectDictionaryRegistrationUpdate
GO

CREATE PROCEDURE dbo.spProjectDictionaryRegistrationUpdate 
(
	@ProjectDictionaryRegistrationID INT,
	@UserID INT,
	@StudyProjectID INT,
	@ProjectRegistrationTransmissionID INT,
	@SegmentId INT,
	@SynonymManagementId INT,
	
	@Created DATETIME,  
	@Updated DATETIME OUTPUT
)  
AS  
  
BEGIN  

	SELECT @Updated = GetUtcDate()  

	UPDATE ProjectDictionaryRegistrations
	SET
		UserID = @UserID,
		StudyProjectID = @StudyProjectID,
		ProjectRegistrationTransmissionID = @ProjectRegistrationTransmissionID,
		SegmentId = @SegmentId,
		SynonymManagementId = @SynonymManagementId,
		Updated = @Updated
	 WHERE ProjectDictionaryRegistrationID = @ProjectDictionaryRegistrationID

END

GO  