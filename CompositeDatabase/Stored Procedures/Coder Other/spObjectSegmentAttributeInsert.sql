 /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/ 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spObjectSegmentAttributeInsert')
	DROP PROCEDURE dbo.spObjectSegmentAttributeInsert
GO

CREATE PROCEDURE dbo.spObjectSegmentAttributeInsert (
	@ObjectSegmentID int, 
	@Tag varchar(50), 
	@Value nvarchar(200),
	@ObjectSegmentAttributeID bigint output,
	@Created datetime output,  
	@Updated datetime output  
)
AS

BEGIN

	DECLARE @UtcDate Datetime
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  

	INSERT INTO dbo.ObjectSegmentAttributes 
	(
		ObjectSegmentID, Tag, Value, Created, Updated
	) VALUES (
		@ObjectSegmentID, @Tag, @Value, @Created, @Updated
	)
	SET @ObjectSegmentAttributeID = SCOPE_IDENTITY()
END
GO