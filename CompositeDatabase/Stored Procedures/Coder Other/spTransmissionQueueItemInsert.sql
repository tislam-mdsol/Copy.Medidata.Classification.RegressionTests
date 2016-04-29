/** $Workfile: spTransmissionQueueItemInsert.sql $
**
** Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of
** this file may not be disclosed to third parties, copied or duplicated in
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Mark Hwe [mhwe@mdsol.com]
**
** Complete history on bottom of file
**/
IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spTransmissionQueueItemInsert')
	DROP PROCEDURE dbo.spTransmissionQueueItemInsert
GO

CREATE PROCEDURE dbo.spTransmissionQueueItemInsert (
	@TransmissionQueueItemID bigint output,
	@ObjectTypeID int,
	@ObjectID bigint,
	@StudyOID varchar(50),
	@FailureCount int,
	@SuccessCount int,
	--@LastFailedTransmissionDate datetime,
	--@LastSuccessfulTransmissionDate datetime,
	@SourceSystemID int,
	--@HttpStatusCode int,
	--@WebExceptionStatus varchar(50),
	--@ResponseText varchar(max),
	@SegmentID INT,
	@CumulativeFailCount INT,
	@OutTransmissionID BIGINT,
	@ServiceWillContinueSending BIT,
	@IsForUnloadService BIT,
	@Created datetime output,
	@Updated datetime output
)
AS

BEGIN
	DECLARE @UtcDate DateTime
	SET @UtcDate = GetUtcDate()
	SELECT @Created = @UtcDate, @Updated = @UtcDate


   INSERT INTO dbo.TransmissionQueueItems (
			ObjectTypeID,
			ObjectID,
			StudyOID,
			FailureCount,
			SuccessCount,
			--LastFailedTransmissionDate,
			--LastSuccessfulTransmissionDate,
			SourceSystemID,
			--HttpStatusCode,
			--WebExceptionStatus,
			--ResponseText,
			SegmentID,
			CumulativeFailCount,
			OutTransmissionID,
			ServiceWillContinueSending,
			IsForUnloadService,
			Created,
			Updated
		 ) VALUES (
			@ObjectTypeID,
			@ObjectID,
			@StudyOID,
			@FailureCount,
			@SuccessCount,
			--@LastFailedTransmissionDate,
			--@LastSuccessfulTransmissionDate,
			@SourceSystemID,
			--@HttpStatusCode,
			--@WebExceptionStatus,
			--@ResponseText,
			@SegmentID,
			@CumulativeFailCount,
			@OutTransmissionID,
			@ServiceWillContinueSending,
			@IsForUnloadService,
			@Created,
			@Updated
		)
		SELECT @TransmissionQueueItemID = SCOPE_IDENTITY(), @Created = @UtcDate
	
END

GO

