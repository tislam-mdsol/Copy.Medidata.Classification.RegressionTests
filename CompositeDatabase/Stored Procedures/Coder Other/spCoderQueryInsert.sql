/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Bonnie Pan bpan@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoderQueryInsert')
	DROP PROCEDURE spCoderQueryInsert
GO

CREATE PROCEDURE dbo.spCoderQueryInsert 
(
	@CodingElementId INT,
	@QueryUUID NVARCHAR(50),
	@CodingElementGroupId INT,
	@QueryText NVARCHAR(1800), 
	@CodingContextURI NVARCHAR(4000),
	@CancelURI NVARCHAR(4000),
	@CancelVerb NVARCHAR(10),
	@Created DATETIME OUTPUT,
	@QueryId INT OUTPUT
)
AS

BEGIN
	DECLARE @UtcDate DateTime
	SET @UtcDate = GetUtcDate()
	SELECT @Created = @UtcDate

	INSERT INTO CoderQueries (  
		CodingElementId,
		QueryUUID,
		CodingElementGroupId,
		QueryText,
		CodingContextURI,
		CancelURI,
		CancelVerb
	) VALUES (  
		@CodingElementId,
		@QueryUUID,
		@CodingElementGroupId,
		@QueryText, 
		@CodingContextURI,
		@CancelURI,
		@CancelVerb
	)  

	SET @QueryId = SCOPE_IDENTITY()  
END

GO