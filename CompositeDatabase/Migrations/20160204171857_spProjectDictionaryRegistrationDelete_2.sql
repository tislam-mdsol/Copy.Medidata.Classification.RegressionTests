IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spProjectDictionaryRegistrationDelete')
	DROP PROCEDURE spProjectDictionaryRegistrationDelete
GO

CREATE PROCEDURE dbo.spProjectDictionaryRegistrationDelete 
(
	@ProjectDictionaryRegistrationID BIGINT
)  
AS  
BEGIN  

	DELETE FROM ProjectDictionaryRegistrations
	WHERE ProjectDictionaryRegistrationID = @ProjectDictionaryRegistrationID

END

GO   