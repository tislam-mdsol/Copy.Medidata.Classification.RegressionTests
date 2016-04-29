IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCriEdcDataUpdate')
	DROP PROCEDURE dbo.spCriEdcDataUpdate
GO
  
CREATE PROCEDURE dbo.spCriEdcDataUpdate (  
 @EdcDataID BIGINT, 
 
 -- state control
 @TimeStamp DATETIME,
 @WasUpdated BIT OUTPUT,

 -- variant properties
 @AssignedCodingPath VARCHAR(300),
 @QueryComment NVARCHAR(4000),
 @UserUUID NVARCHAR(50)
)  
AS  
BEGIN 
 
 UPDATE dbo.EDCData SET 
  
  TimeStamp          = @TimeStamp,
  AssignedCodingPath = @AssignedCodingPath,
  QueryComment       = @QueryComment,
  UserUUID           = @UserUUID,
  Updated            = GETUTCDATE()

 WHERE EdcDataID     = @EdcDataID
	AND @TimeStamp > TimeStamp
	
 -- check if we updated
 IF (@@ROWCOUNT = 0)
	SET @WasUpdated = 0
 ELSE
	SET @WasUpdated = 1
 
END  
  
GO
