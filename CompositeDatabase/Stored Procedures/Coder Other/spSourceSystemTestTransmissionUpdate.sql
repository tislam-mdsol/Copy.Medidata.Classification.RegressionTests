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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSourceSystemTestTransmissionUpdate')
	DROP PROCEDURE spSourceSystemTestTransmissionUpdate
GO

CREATE PROCEDURE dbo.spSourceSystemTestTransmissionUpdate 
(
	@SourceSystemTestTransmissionID BIGINT,
	@ApplicationID INT,
	@IsSuccessful BIT,
	@ResponseStatus NVARCHAR(100),
	@ResponseDetail NVARCHAR(max),
	@Exception NVARCHAR(max),
	@Created DATETIME,  
	@Updated DATETIME OUTPUT
)  
AS  
  
BEGIN  

	SELECT @Updated = GetUtcDate()  

	UPDATE SourceSystemTestTransmission
	SET
		ApplicationID = @ApplicationID,  
		IsSuccessful = @IsSuccessful,
		ResponseStatus = @ResponseStatus,
		ResponseDetail = @ResponseDetail,
		Exception = @Exception,
		Updated = @Updated
	 WHERE SourceSystemTestTransmissionID = @SourceSystemTestTransmissionID

END

GO