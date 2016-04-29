IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spProjectDictionaryRegistrationInsert')
	BEGIN
		DROP  Procedure  spProjectDictionaryRegistrationInsert
	END

GO

CREATE Procedure dbo.spProjectDictionaryRegistrationInsert
(
	@UserID INT,
	@InteractionID INT,
	@StudyProjectID INT,
	@ProjectRegistrationTransmissionID INT,
	@SegmentId INT,
	@SynonymManagementId INT,
	
	@Created DATETIME OUTPUT,
	@Updated DATETIME OUTPUT,
	@ProjectDictionaryRegistrationID INT OUTPUT
)
AS

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
  
	INSERT INTO ProjectDictionaryRegistrations (  
		UserID,
		InteractionID,
		StudyProjectID,
		ProjectRegistrationTransmissionID,
		SegmentId,
		SynonymManagementId,
		
		Created,
		Updated
	) VALUES (  
		@UserID,
		@InteractionID,
		@StudyProjectID,
		@ProjectRegistrationTransmissionID,
		@SegmentId,
		@SynonymManagementId,
		
		@Created,
		@Updated
	)
	
	SET @ProjectDictionaryRegistrationID = SCOPE_IDENTITY()  	
	
END
GO
  