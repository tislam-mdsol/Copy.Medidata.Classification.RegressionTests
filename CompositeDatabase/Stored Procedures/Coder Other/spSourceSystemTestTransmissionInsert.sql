/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Steve Myers smyers@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSourceSystemTestTransmissionInsert')
	BEGIN
		DROP  Procedure  spSourceSystemTestTransmissionInsert
	END

GO

CREATE Procedure dbo.spSourceSystemTestTransmissionInsert

	(
		@ApplicationID INT,
		@IsSuccessful BIT,
		@ResponseStatus NVARCHAR(100),
		@ResponseDetail NVARCHAR(max),
		@Exception NVARCHAR(max),
		@Created DATETIME OUTPUT,
		@Updated DATETIME OUTPUT,
		@SourceSystemTestTransmissionID BIGINT OUTPUT
	)

AS

BEGIN
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
	-- check if there is an existing row for this ApplicationID
	DECLARE @ExistingSourceSystemTestID AS BIGINT

	SELECT @ExistingSourceSystemTestID = SourceSystemTestTransmissionID
	FROM SourceSystemTestTransmission WHERE ApplicationID = @ApplicationID

	IF @ExistingSourceSystemTestID IS NULL
	BEGIN
		-- insert new row
		INSERT INTO SourceSystemTestTransmission (  
			ApplicationID,
			IsSuccessful,
			ResponseStatus,
			ResponseDetail,
			Exception,
			Created,
			Updated
		) VALUES (  
			@ApplicationID,
			@IsSuccessful,
			@ResponseStatus,
			@ResponseDetail,
			@Exception,
			@Created,
			@Updated
		)  		
		SET @SourceSystemTestTransmissionID = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		-- update existing row
		EXEC dbo.spSourceSystemTestTransmissionUpdate
			@ExistingSourceSystemTestID,
			@ApplicationID,
			@IsSuccessful,
			@ResponseStatus,
			@ResponseDetail,
			@Exception,
			@Created,  
			@Updated

		SET @SourceSystemTestTransmissionID = @ExistingSourceSystemTestID		
	END

END
GO
