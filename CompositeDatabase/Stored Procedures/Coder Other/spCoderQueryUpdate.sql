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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoderQueryUpdate')
	DROP PROCEDURE spCoderQueryUpdate
GO
CREATE PROCEDURE dbo.spCoderQueryUpdate
(
	@QueryId INT,
	@CodingElementId INT,
	@QueryUUID NVARCHAR(50),
	@CodingElementGroupId INT,
	@QueryText NVARCHAR(4000), 
	@CodingContextURI NVARCHAR(4000),
	@CancelURI NVARCHAR(4000),
	@CancelVerb NVARCHAR(10),
	@Updated DATETIME
)
AS	
BEGIN

	
	UPDATE CoderQueries
	SET
		CodingElementId = @CodingElementId,
		QueryUUID = @QueryUUID,
		CodingElementGroupId = @CodingElementGroupId,
		QueryText = @QueryText,
		CodingContextURI = @CodingContextURI,
		CancelURI = @CancelURI,
		CancelVerb = @CancelVerb,
		Updated = @Updated
	 WHERE QueryId = @QueryId
	 	
END
GO  