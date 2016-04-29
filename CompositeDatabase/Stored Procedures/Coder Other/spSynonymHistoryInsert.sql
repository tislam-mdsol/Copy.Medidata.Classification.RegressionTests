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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymHistoryInsert')
	DROP PROCEDURE spSynonymHistoryInsert
GO
CREATE PROCEDURE spSynonymHistoryInsert
(
	@SynonymTermID INT,
	@PriorSynonymTermID INT,
	@SynonymActionID INT,
	@SynonymSourceID INT,
	@Comment NVARCHAR(100),
	@UserID int,  
	@Created datetime output,  
	@Updated datetime output, 
	@SynonymHistoryID bigint output,
	@SegmentID INT
)
AS

BEGIN

	DECLARE @utcDate DATETIME
	
	SET @utcDate = GETUTCDATE()
	
	SELECT @Created = @utcDate,
		@Updated = @utcDate

	INSERT INTO SynonymHistory (
		SynonymTermID,
		PriorSynonymTermID,
		SynonymActionID,
		SynonymSourceID,
		Comment,
		SegmentID,
		UserID,
		Created,
		Updated
	) VALUES (
		@SynonymTermID,
		@PriorSynonymTermID,
		@SynonymActionID,
		@SynonymSourceID,
		@Comment,
		@SegmentID,
		@UserID,
		@Created,
		@Updated
	)
	
	SET @SynonymHistoryID = SCOPE_IDENTITY()
END
GO