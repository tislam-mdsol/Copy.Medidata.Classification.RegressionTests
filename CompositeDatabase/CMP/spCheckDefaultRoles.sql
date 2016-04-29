IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCheckDefaultRoles')
	DROP PROCEDURE spCheckDefaultRoles
GO

CREATE PROCEDURE dbo.spCheckDefaultRoles
AS
BEGIN

	SELECT 'Missing SegmentAdmin Role:', S.SegmentId, S.SegmentName
	FROM Segments S
		LEFT JOIN Roles R
			ON S.SegmentId = R.SegmentID
	WHERE R.RoleName = 'SegmentAdmin'
		AND R.RoleID IS NULL

	IF (@@ROWCOUNT <> 0)
	BEGIN
		PRINT 'Found Segments missing SegmentAdmin roles'
	END

	SELECT 'Missing ExternalVerbatimAdmin Role:',S.SegmentId, S.SegmentName
	FROM Segments S
		LEFT JOIN Roles R
			ON S.SegmentId = R.SegmentID
	WHERE R.RoleName = 'ExternalVerbatimAdmin'
		AND R.RoleID IS NULL

	IF (@@ROWCOUNT <> 0)
	BEGIN
		PRINT 'Found Segments missing ExternalVerbatimAdmin roles'
	END

END
