IF object_id('fnPassesReclassifyAssignmentFilter') IS NOT NULL
	DROP FUNCTION dbo.fnPassesReclassifyAssignmentFilter
GO

CREATE FUNCTION [dbo].fnPassesReclassifyAssignmentFilter
(
    @IncludeAutoCodedItems BIT,
    @UserIDs VARCHAR(255),
	@CodingElementId INT
)
RETURNS BIT
AS
BEGIN

	IF EXISTS (
				SELECT NULL 
				FROM CodingAssignment CA 
				WHERE CA.CodingElementID = @CodingElementId
					AND CA.Active = 1
					AND CA.IsAutoCoded IN (0, @IncludeAutoCodedItems)
					-- user check
					AND CHARINDEX(CAST(ca.UserID AS VARCHAR)+',', @UserIDs) > 0)

		RETURN 1

	RETURN 0	

END
