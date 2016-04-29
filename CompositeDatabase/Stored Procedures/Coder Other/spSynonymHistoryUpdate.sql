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


IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spSynonymHistoryUpdate')
	DROP PROCEDURE spSynonymHistoryUpdate
GO
  
CREATE PROCEDURE spSynonymHistoryUpdate (  
	@SynonymHistoryID bigint,
	@SynonymTermID INT,
	@PriorSynonymTermID INT,
	@SynonymActionID INT,
	@SynonymSourceID INT,
	@Comment NVARCHAR(100),
	@UserID int,  
	@Created datetime,
	@Updated datetime output,
	@SegmentID INT
)
AS  
  
BEGIN  
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SET @Updated = @UtcDate  

	UPDATE dbo.SynonymHistory SET  
		SynonymTermID = @SynonymTermID,
		PriorSynonymTermID = @PriorSynonymTermID,
		SynonymActionID = @SynonymActionID,
		SynonymSourceID = @SynonymSourceID,
		Comment = @Comment,
		SegmentID = @SegmentID,
		UserID = @UserID,
		Created = @Created,
		Updated = @UtcDate  
	WHERE SynonymHistoryID = @SynonymHistoryID
	
END  
  
GO
