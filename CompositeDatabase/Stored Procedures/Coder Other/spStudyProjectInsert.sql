/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyProjectInsert')
	DROP PROCEDURE spStudyProjectInsert
GO

CREATE PROCEDURE dbo.spStudyProjectInsert 
(
	@StudyProjectId BIGINT OUTPUT,  
	
	@ProjectName NVARCHAR(440),
	@iMedidataId NVARCHAR(50),  
	@SegmentID INT,
	
	@Created DATETIME OUTPUT,  
	@Updated DATETIME OUTPUT
)  
AS  
  
BEGIN  
	DECLARE @UtcDate DATETIME  
	
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, @Updated = @UtcDate  

	INSERT INTO dbo.StudyProjects (
		ProjectName,
		iMedidataId,
		SegmentID,
		
		Created,  
		Updated  
	 ) 
	 VALUES ( 
		@ProjectName,
		@iMedidataId,
		@SegmentID,
		
		@UtcDate,  
		@UtcDate  
	 )
	 
	 SET @StudyProjectId = SCOPE_IDENTITY()  
END

GO  