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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spOutTransmissionInsert')
	BEGIN
		DROP  Procedure  spOutTransmissionInsert
	END

GO

CREATE Procedure dbo.spOutTransmissionInsert
(
	@SourceSystemID INT,
	@TransmissionTypeID INT,
	
	@Acknowledged BIT,
	@AcknowledgeDate DATETIME,
	@TransmissionSuccess BIT,
	@TransmissionDate DATETIME,
	
	@HttpStatusCode INT,
	@WebExceptionStatus VARCHAR(50),
	@TextToTransmit NVARCHAR(MAX), -- compressed?
	@ResponseText NVARCHAR(MAX), -- compressed?
	
	@Created DATETIME OUTPUT,
	@Updated DATETIME OUTPUT,
	@OutTransmissionID INT OUTPUT
)
AS

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
  
	INSERT INTO OutTransmissions (  
		SourceSystemID,
		TransmissionTypeID,
		
		Acknowledged,
		AcknowledgeDate,
		TransmissionSuccess,
		TransmissionDate,
		
		HttpStatusCode,
		WebExceptionStatus,
		TextToTransmit,
		ResponseText,
		
		Created,
		Updated
	) VALUES (  
		@SourceSystemID,
		@TransmissionTypeID,
		
		@Acknowledged,
		@AcknowledgeDate,
		@TransmissionSuccess,
		@TransmissionDate,
		
		@HttpStatusCode,
		@WebExceptionStatus,
		@TextToTransmit,
		@ResponseText,

		@Created,
		@Updated
	)  
	
	SET @OutTransmissionID = SCOPE_IDENTITY()  	
	
END
GO
  