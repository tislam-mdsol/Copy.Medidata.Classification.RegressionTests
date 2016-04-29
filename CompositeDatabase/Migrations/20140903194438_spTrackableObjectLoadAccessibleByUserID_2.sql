IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spTrackableObjectLoadAccessibleByUserID')
	DROP PROCEDURE spTrackableObjectLoadAccessibleByUserID
GO

CREATE procedure [dbo].[spTrackableObjectLoadAccessibleByUserID]
(
	@UserID INT,
	@SegmentId INT,
	@AllTrackableObjectsID INT
)
as
begin

	;WITH studyAccess (StudyId, IsDenied) AS
	(
		SELECT 
			GrantOnObjectId,  -- studyId
			CASE WHEN DenyObjectRole = 1 THEN 1 ELSE 0 END  -- IsDenied (cast to INT for ease of computation)
		FROM UserObjectWorkflowRole
		WHERE GrantToObjectId = @UserID 
			AND GrantOnObjectId = @AllTrackableObjectsID
			AND SegmentId = @SegmentId
			AND Active = 1
	),
	specificStudyAccess (StudyId, IsDenied) AS
	(
		-- 1. all studies denied/allowed
		SELECT TrackableObjectId, IsDenied
		FROM TrackableObjects T
			JOIN studyAccess SA
				ON T.SegmentId = @SegmentId
				AND SA.StudyId = @AllTrackableObjectsID
		UNION
		-- 2. some denied/allowed
		SELECT StudyId, IsDenied
		FROM studyAccess
	),
	aggregatedStudyAccess (StudyId, IsDenied) AS
	(
		SELECT StudyId, SUM(IsDenied)
		FROM specificStudyAccess
		GROUP BY StudyId
	)

	SELECT T.*
	FROM TrackableObjects T
		JOIN aggregatedStudyAccess A
			ON T.TrackableObjectID = A.StudyId
	WHERE A.IsDenied = 0
	ORDER BY T.ExternalObjectOID

end
 