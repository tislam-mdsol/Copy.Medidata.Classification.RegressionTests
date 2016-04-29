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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDataMigrationRunInsert')
	DROP PROCEDURE spDataMigrationRunInsert
GO

CREATE PROCEDURE dbo.spDataMigrationRunInsert
(
	@DataMigrationRunID INT OUTPUT,
	@DataMigrationID INT,

	@IsFailed BIT,
	@IsSucceeded BIT,
	@ExceptionData NVARCHAR(MAX),

	@Created DATETIME OUTPUT,  
	@Updated DATETIME OUTPUT
)
AS
	DECLARE @UtcDate DATETIME  
	
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  

	INSERT INTO dbo.DataMigrationRuns (
		DataMigrationID,

		IsFailed,
		IsSucceeded,
		ExceptionData,
		
		Created,  
		Updated  
	 ) 
	 VALUES ( 
		@DataMigrationID,

		@IsFailed,
		@IsSucceeded,
		@ExceptionData,
		
		@UtcDate,  
		@UtcDate  
	 )
	 
	 SET @DataMigrationRunID = SCOPE_IDENTITY()  

GO    