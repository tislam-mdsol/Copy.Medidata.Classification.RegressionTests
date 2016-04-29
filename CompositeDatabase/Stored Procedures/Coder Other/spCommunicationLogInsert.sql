/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCommunicationLogInsert')
	DROP PROCEDURE spCommunicationLogInsert
GO

CREATE PROCEDURE dbo.spCommunicationLogInsert 
(
	@CommunicationLogId BIGINT OUTPUT,  
	
	@Active BIT,
	@WebURL NVARCHAR(1000),
	@IMedidataAppId INT,
	@TransmissionStarted DATETIME,
	@WebTimeDuration INT,
	@OtherTimeDuration1 INT,
	@OtherTimeDuration2 INT,
	@OtherTimeDuration3 INT,
	@HttpStatusCode INT,
	@ErrorData NVARCHAR(1000),
	@WebTransmissionSize INT,
	@WebTransmissionTypeId INT,
	@IsSecurityCheckOK BIT,
	@IsMessageParsedOK BIT,
		
	@Created DATETIME OUTPUT,  
	@Updated DATETIME OUTPUT
)  
AS  
  
BEGIN  
	DECLARE @UtcDate DATETIME  
	
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  

	INSERT INTO dbo.CommunicationLogs (  
		Active,
		WebURL,
		IMedidataAppId,
		TransmissionStarted,
		WebTimeDuration,
		OtherTimeDuration1,
		OtherTimeDuration2,
		OtherTimeDuration3,
		HttpStatusCode,
		ErrorData,
		WebTransmissionSize,
		WebTransmissionTypeId,
		IsSecurityCheckOK,
		IsMessageParsedOK,

		Created,  
		Updated  
	 ) 
	 VALUES (  
		@Active,
		@WebURL,
		@IMedidataAppId,
		@TransmissionStarted,
		@WebTimeDuration,
		@OtherTimeDuration1,
		@OtherTimeDuration2,
		@OtherTimeDuration3,
		@HttpStatusCode,
		@ErrorData,
		@WebTransmissionSize,
		@WebTransmissionTypeId,
		@IsSecurityCheckOK,
		@IsMessageParsedOK,

		@UtcDate,  
		@UtcDate  
	 )
	 
	 SET @CommunicationLogId = SCOPE_IDENTITY()  
END

GO 