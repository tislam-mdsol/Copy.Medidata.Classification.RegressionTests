/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementGroupUpdate')
	DROP PROCEDURE spCodingElementGroupUpdate
GO

CREATE PROCEDURE dbo.spCodingElementGroupUpdate 
(
	@CodingElementGroupId BIGINT,  
	@MedicalDictionaryID INT,  
	@DictionaryLevelID INT,  
	@DictionaryLocale CHAR(3),
	@CompSuppCount INT,
	
	@GroupVerbatimId INT,
	@Created DATETIME,  
	@Updated DATETIME OUTPUT,
	@SegmentId INT
)  
AS  
  
BEGIN  

	SELECT @Updated = GetUtcDate()  

	UPDATE CodingElementGroups
	SET
		MedicalDictionaryID = @MedicalDictionaryID,  
		DictionaryLevelID = @DictionaryLevelID,  
		DictionaryLocale = @DictionaryLocale,
		CompSuppCount = @CompSuppCount,
		GroupVerbatimId = @GroupVerbatimId,
		SegmentId = @SegmentId,
		Updated = @Updated
	 WHERE CodingElementGroupId = @CodingElementGroupId

END

GO