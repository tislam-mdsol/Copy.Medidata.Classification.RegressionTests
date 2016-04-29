IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGetAutoApprovalConfiguration')
	DROP PROCEDURE spGetAutoApprovalConfiguration
GO

CREATE PROCEDURE dbo.spGetAutoApprovalConfiguration(
      @SegmentId INT,
	  @DictionaryId INT,
	  @DictionaryObjectTypeId INT
)
AS
BEGIN 


	SELECT VALUE AS IsAutoApproval
	FROM ObjectSegmentAttributes OSA
	JOIN ObjectSegments OS ON OS.ObjectSegmentId = OSA.ObjectSegmentID
	WHERE OS.SegmentId = @SegmentId 
	AND OS.ObjectTypeId = @DictionaryObjectTypeId
	AND OS.ObjectId =@DictionaryId
	AND OSA.Tag='IsAutoApproval'
	AND OS.Deleted= 0


END
GO