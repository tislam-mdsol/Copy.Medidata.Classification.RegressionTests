/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/ 


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spBOTElementInsert')
	DROP PROCEDURE dbo.spBOTElementInsert
GO

CREATE PROCEDURE dbo.spBOTElementInsert
(
    @SegmentId INT,
    @UserId INT,
    @SegmentedCodingPatternId BIGINT,
    @IsForwardBOT BIT,
    @CommentReason NVARCHAR(500),
    @BotLog VARCHAR(500),
	
	@Created DATETIME OUTPUT,
	@Updated DATETIME OUTPUT,
	@BOTElementID INT OUTPUT
)
AS

BEGIN
	DECLARE @UtcDate DATETIME  
	SET @UtcDate = GETUTCDATE()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  
	
  
	INSERT INTO BOTElements (  
		SegmentId,
		UserId,
		SegmentedCodingPatternId,
		IsForwardBOT,
		CommentReason,
		BotLog,
		
		Created,
		Updated
	) VALUES (  
		@SegmentId,
		@UserId,
		@SegmentedCodingPatternId,
		@IsForwardBOT,
		@CommentReason,
		@BotLog,
		
		@Created,
		@Updated
	)  
	
	SET @BOTElementID = SCOPE_IDENTITY()  	
	
END
GO
