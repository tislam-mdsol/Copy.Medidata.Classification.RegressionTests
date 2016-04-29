IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyProjectUpdate')
	DROP PROCEDURE spStudyProjectUpdate
GO

CREATE PROCEDURE dbo.spStudyProjectUpdate 
(
	@StudyProjectId BIGINT,  
	
	@ProjectName NVARCHAR(440),
	@iMedidataId NVARCHAR(50),  
	@SegmentID INT,
	  
	@Updated DATETIME OUTPUT
)  
AS  
BEGIN  

	SELECT @Updated = GetUtcDate()  

	UPDATE StudyProjects
	SET
		ProjectName = @ProjectName,  
		iMedidataId = @iMedidataId,
		SegmentID = @SegmentID,
		Updated = @Updated
	 WHERE StudyProjectId = @StudyProjectId

END

GO   