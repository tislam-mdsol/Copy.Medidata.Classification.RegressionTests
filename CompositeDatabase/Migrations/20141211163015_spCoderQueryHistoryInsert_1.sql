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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoderQueryHistoryInsert')
	DROP PROCEDURE spCoderQueryHistoryInsert
GO

CREATE PROCEDURE dbo.spCoderQueryHistoryInsert 
(
	@QueryRepeatKey NVARCHAR(50),
	@QueryStatus TINYINT,
	@PriorQueryStatus TINYINT,
	@Recipient NVARCHAR (450),
	@QueryText NVARCHAR(4000), 
	@QueryResponse NVARCHAR(4000),
	@UserRef NVARCHAR(100),
	@DateTimeStamp DATETIME,
	@QueryId INT,
	@Created DATETIME OUTPUT,
	@QueryHistoryId INT OUTPUT
)
AS

BEGIN
	DECLARE @UtcDate DateTime
	SET @UtcDate = GetUtcDate()
	SELECT @Created = @UtcDate

	INSERT INTO CoderQueryHistory (  
		QueryRepeatKey,
		QueryStatus,
		PriorQueryStatus,
		Recipient,
		QueryText,
		QueryResponse,
		UserRef,
		DateTimeStamp,
		QueryId
	) VALUES (  
		@QueryRepeatKey,
		@QueryStatus,
		@PriorQueryStatus,
		@Recipient,
		@QueryText, 
		@QueryResponse,
		@UserRef,
		@DateTimeStamp,
		@QueryId
	)  

	SET @QueryHistoryId = SCOPE_IDENTITY()  
END

GO