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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDataMigrationRunUpdate')
	DROP PROCEDURE spDataMigrationRunUpdate
GO

CREATE PROCEDURE dbo.spDataMigrationRunUpdate
(
	@DataMigrationRunID INT,
	@DataMigrationID INT,

	@IsFailed BIT,
	@IsSucceeded BIT,
	@ExceptionData NVARCHAR(MAX),

	@Created DATETIME,
	@Updated DATETIME OUTPUT
)
AS
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Updated = @UtcDate  

  
	UPDATE DataMigrationRuns
	SET
		DataMigrationID = @DataMigrationID,

		IsFailed = @IsFailed,
		IsSucceeded = @IsSucceeded,
		ExceptionData = @ExceptionData,

		Updated = @Updated
	WHERE DataMigrationRunID = @DataMigrationRunID


GO    