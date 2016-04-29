/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2014, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spObjectSegmentInsert')
	DROP PROCEDURE spObjectSegmentInsert
GO
CREATE PROCEDURE dbo.spObjectSegmentInsert
(
	@ObjectID INT, 
	@ObjectTypeId INT,
	@SegmentId INT,
	@Readonly BIT,
	@DefaultSegment BIT,
	@Deleted BIT,

	@ObjectSegmentID bigint output,
	@Created datetime output,  
	@Updated datetime output  
)
AS

BEGIN

	DECLARE @UtcDate Datetime
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  

	INSERT INTO dbo.ObjectSegments 
	(
		ObjectID, ObjectTypeId, SegmentId, ReadOnly, DefaultSegment, Deleted, Created, Updated
	) VALUES (
		@ObjectID, @ObjectTypeId, @SegmentId, @Readonly, @DefaultSegment, @Deleted, @Created, @Updated
	)
	SET @ObjectSegmentID = SCOPE_IDENTITY()
END
