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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spObjectSegmentUpdate')
	DROP PROCEDURE spObjectSegmentUpdate
GO
CREATE PROCEDURE dbo.spObjectSegmentUpdate
(
	@ObjectSegmentID bigint,
	@ObjectID INT, 
	@ObjectTypeId INT,
	@SegmentId INT,
	@Readonly BIT,
	@DefaultSegment BIT,
	@Deleted BIT,

	@Created datetime,  
	@Updated datetime output  
)
AS

BEGIN

	DECLARE @UtcDate Datetime
	SET @UtcDate = GetUtcDate()  
	SELECT  @Updated = @UtcDate  

	UPDATE dbo.ObjectSegments
	SET DefaultSegment = @DefaultSegment,
		Readonly = @Readonly,
		Deleted = @Deleted,
		Updated = @Updated
	WHERE ObjectSegmentID = @ObjectSegmentID

END

