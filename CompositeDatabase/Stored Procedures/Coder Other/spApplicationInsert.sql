/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Steve Myers smyers@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spApplicationInsert')
	BEGIN
		DROP  Procedure  spApplicationInsert
	END

GO

CREATE Procedure dbo.spApplicationInsert

	(
		@UUID NVARCHAR(255),
		@ApiID NVARCHAR(256),
		@Name NVARCHAR(256),
		@BaseUrl NVARCHAR(2000),
		@PublicKey NVARCHAR(500),
		@ApplicationTypeID INT,
		@Active BIT,
		@Deleted BIT,
		@IsAlwaysBypassTransmit BIT,
		@Created DATETIME OUTPUT,
		@Updated DATETIME OUTPUT,
		@ApplicationID INT OUTPUT,
		@SourceSystemID INT OUTPUT
	)

AS

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
	-- SourceSystem has 1 to 1 mapping with Application
	-- For each new Application created, make a corresponding SourceSystem entry
	EXEC dbo.spSourceSystemInsert 
		@ApiID,		-- @OID
		'',			-- @SourceSystemVersion
		@BaseUrl,	-- @ConnectionURI
		'eng',		-- @DefaultLocale
		NULL,		-- @Created datetime output
		NULL,		-- @Updated datetime output
		@SourceSystemID output,-- @SourceSystemID int output
		1,			-- @DefaultSegmentID
		''			-- @MarkingGroup nvarchar(50)

  
	INSERT INTO Application (
		UUID,
		ApiID,
		Name,
		BaseUrl,
		PublicKey,
		ApplicationTypeID,
		SourceSystemID,
		Active,
		Deleted,
		IsAlwaysBypassTransmit,
		Created,
		Updated
	) VALUES (
		@UUID,
		@ApiID,
		@Name,
		@BaseUrl,
		@PublicKey,
		@ApplicationTypeID,
		@SourceSystemID,
		@Active,
		@Deleted,
		@IsAlwaysBypassTransmit,
		@Created,
		@Updated
	)  
	
	SET @ApplicationID = SCOPE_IDENTITY()  	
	
END
GO
