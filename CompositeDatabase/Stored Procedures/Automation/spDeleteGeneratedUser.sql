IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spDeleteGeneratedUser')
DROP PROCEDURE dbo.spDeleteGeneratedUser
GO

CREATE PROCEDURE [dbo].spDeleteGeneratedUser
( 
  @SegmentId INT,
  @Username  VARCHAR(50)
) 
AS

BEGIN
	--production check
	IF NOT EXISTS (
		SELECT NULL 
		FROM CoderAppConfiguration
		WHERE Active = 1 AND IsProduction = 0)
	BEGIN
	  PRINT N'THIS IS A PRODUCTION ENVIRONMENT - Test Script cannot proceed!'
	  RETURN
	END

DECLARE @UserId INT

SELECT
    @UserId = UserId
    from Users
    where [Login] = @Username

DELETE FROM Configuration                   where SegmentId = @SegmentId
DELETE FROM DictionaryLicenceInformations   where SegmentId = @SegmentId
DELETE FROM ObjectSegments                  where SegmentId = @SegmentId
DELETE FROM TrackableObjects                where SegmentId = @SegmentId
DELETE FROM StudyProjects                   where SegmentId = @SegmentId
DELETE FROM UserObjectWorkflowRole          where SegmentId = @SegmentId
DELETE FROM WorkflowRoleActions             where SegmentId = @SegmentId
DELETE FROM WorkflowRoles                   where SegmentId = @SegmentId
DELETE FROM UserObjectRole                  where SegmentId = @SegmentId
DELETE FROM RoleActions                     where SegmentId = @SegmentId
DELETE FROM Roles                           where SegmentId = @SegmentId
DELETE FROM DictionarySegmentConfigurations where SegmentId = @SegmentId
DELETE FROM Segments                        where SegmentId = @SegmentId
DELETE FROM DoNotAutoCodeTerms              where UserId = @UserId
DELETE FROM Users                           where UserId = @UserId

END