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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDataMigrationDetailUpdate')
	DROP PROCEDURE spDataMigrationDetailUpdate
GO

CREATE PROCEDURE dbo.spDataMigrationDetailUpdate
(
	@DataMigrationDetailID INT,
	@DataMigrationID INT,

	@ObjectTypeID INT,
	@ObjectID INT,

	@DataMigrationRunID BIGINT,
	@IsProcessed BIT,

	@Created DATETIME,
	@Updated DATETIME OUTPUT
)
AS
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Updated = @UtcDate  

  
	UPDATE DataMigrationDetails
	SET
		DataMigrationID = @DataMigrationID,
		ObjectTypeID = @ObjectTypeID,
		ObjectID = @ObjectID,
		DataMigrationRunID = @DataMigrationRunID,
		IsProcessed = @IsProcessed,

		Updated = @Updated
	WHERE DataMigrationDetailID = @DataMigrationDetailID


GO    