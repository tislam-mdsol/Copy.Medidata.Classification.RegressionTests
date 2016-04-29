IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGetAutoApprovalConfiguration')
	DROP PROCEDURE spGetAutoApprovalConfiguration
GO

CREATE PROCEDURE dbo.spGetAutoApprovalConfiguration(
      @SegmentId INT,
	  @DictionaryKey NVARCHAR(100)
)
AS
BEGIN 


	SELECT IsAutoApproval
	FROM DictionarySegmentConfigurations
	WHERE SegmentId = @SegmentId 
		AND MedicalDictionaryKey = @DictionaryKey

END
GO