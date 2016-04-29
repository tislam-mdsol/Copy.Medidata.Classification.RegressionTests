IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementGroupComponentLoadByGroup')
	DROP PROCEDURE spCodingElementGroupComponentLoadByGroup
GO
CREATE PROCEDURE dbo.spCodingElementGroupComponentLoadByGroup
(
	@codingElementGroupId INT
)
AS

	SELECT *
	FROM CodingElementGroupComponents
	WHERE CodingElementGroupID = @codingElementGroupId

GO
 