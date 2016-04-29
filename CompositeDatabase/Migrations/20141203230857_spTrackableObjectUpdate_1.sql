/** $Workfile: spTrackableObjectUpdate.sql $
**
** Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spTrackableObjectUpdate')
	DROP PROCEDURE dbo.spTrackableObjectUpdate
GO

CREATE PROCEDURE dbo.spTrackableObjectUpdate (
	@TrackableObjectID bigint,
	@ExternalObjectTypeId bigint,
	@ExternalObjectId nvarchar(50),
	@ExternalObjectOID varchar(50),
	@ExternalObjectName nvarchar(2000),
	@ProtocolName nvarchar(2000),
	@Created datetime,
	@Updated datetime output,
	@ExternalObjectNameId int,
	@TaskCounter bigint,
	@IsTestStudy bit,
	@StudyProjectID INT,
	@SourceUpdatedAt DATETIME,
	@SegmentId int
)
AS

BEGIN
	DECLARE @UtcDate DateTime
	SET @UtcDate = GetUtcDate()
	SET @Updated = @UtcDate

	UPDATE dbo.TrackableObjects SET
		ExternalObjectTypeId = @ExternalObjectTypeId,
		ExternalObjectId = @ExternalObjectId,
		ExternalObjectOID = @ExternalObjectOID,
		ExternalObjectName = @ExternalObjectName,
		ProtocolName = @ProtocolName,
		SegmentId = @SegmentId,
		Created = Created,
		Updated = @UtcDate,
		ExternalObjectNameId = @ExternalObjectNameId,
		SourceUpdatedAt = @SourceUpdatedAt,
		--TaskCounter = @TaskCounter,
		IsTestStudy = @IsTestStudy,
		StudyProjectID = @StudyProjectID
	WHERE TrackableObjectID = @TrackableObjectID
END

GO
