IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGetAutoApprovalConfiguration')
	DROP PROCEDURE spGetAutoApprovalConfiguration
GO

CREATE PROCEDURE dbo.spGetAutoApprovalConfiguration(
      @SegmentId INT,
	  @DictionaryId INT
)
AS
BEGIN 


	SELECT IsAutoApproval
	FROM DictionarySegmentConfigurations
	WHERE SegmentId = @SegmentId 
		AND DictionaryId =@DictionaryId

END
GO