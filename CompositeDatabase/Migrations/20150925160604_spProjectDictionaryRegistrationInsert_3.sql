IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spProjectDictionaryRegistrationInsert')
	BEGIN
		DROP  Procedure  spProjectDictionaryRegistrationInsert
	END

GO

CREATE Procedure dbo.spProjectDictionaryRegistrationInsert
(
	@UserID INT,
	@StudyProjectID INT,
	@ProjectRegistrationTransmissionID INT,
	@SegmentId INT,
	@SynonymManagementId INT,
	@RegistrationName NVARCHAR(100),
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
		RegistrationName,
		
		Created,
		Updated
	) VALUES (  
		@UserID,
		0, -- TODO : remove from model
		@StudyProjectID,
		@ProjectRegistrationTransmissionID,
		@SegmentId,
		@SynonymManagementId,
		@RegistrationName,
		
		@Created,
		@Updated
	)
	
	SET @ProjectDictionaryRegistrationID = SCOPE_IDENTITY() 
	
END
GO
  