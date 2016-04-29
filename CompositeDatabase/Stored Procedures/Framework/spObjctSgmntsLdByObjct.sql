IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spObjctSgmntsLdByObjct')
	DROP PROCEDURE spObjctSgmntsLdByObjct
GO
CREATE PROCEDURE dbo.spObjctSgmntsLdByObjct
(
	@ObjectID INT,
	@ObjectTypeID INT
)
AS

	SELECT * 
	FROM ObjectSegments 
	WHERE ObjectTypeID = @ObjectTypeID
		AND ObjectID = @ObjectID

GO  