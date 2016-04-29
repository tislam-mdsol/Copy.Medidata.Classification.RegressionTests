/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/ 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spMOTDAuditInsert')
	DROP PROCEDURE dbo.spMOTDAuditInsert
GO

CREATE PROCEDURE dbo.spMOTDAuditInsert
(
    @UserId INT,
    @MOTDMessage NVARCHAR(1000),
    @Locale CHAR(3),

	@Created DATETIME OUTPUT,
	@Updated DATETIME OUTPUT,
	@MOTDAuditID INT OUTPUT
)
AS

BEGIN
	DECLARE @UtcDate DATETIME  
	SET @UtcDate = GETUTCDATE()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
  
	INSERT INTO MOTDAudits (  
		UserId,
		MOTDMessage,
		Locale,
		
		Created,
		Updated
	) VALUES (  
		@UserId,
		@MOTDMessage,
		@Locale,
		
		@Created,
		@Updated
	)  
	
	SET @MOTDAuditID = SCOPE_IDENTITY()  	
	
END
GO
