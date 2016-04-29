/*
*
* Due to allowing a CodingRequest
* with same UUID to update
* an existing Coding Element
* a new system action needs
* to be added to help coding
* history make sense
*
* Connor Ross cross@mdsol.com
*/

DECLARE @segmentId INT
DECLARE @VerbatimUpdateWFName NVARCHAR(15) = 'VerbatimUpdate'

IF NOT EXISTS( SELECT NULL FROM WorkflowSystemActionR WHERE WorkflowSystemActionID = 22)
BEGIN

	INSERT INTO WorkflowSystemActionR (ActionName, ApplicationID, Active, Created, Updated)
	VALUES (@VerbatimUpdateWFName, 1, 1, GETUTCDATE(), GETUTCDATE())
END
 /* TODO: I don't think system actions have a localization, but how else do I get it in coding history? */