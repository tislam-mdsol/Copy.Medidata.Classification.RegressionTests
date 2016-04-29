  /** $Workfile: spTrackableObjectInsert.sql $
**
** Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Mark Hwe mhwe@mdsol.com
**
** Complete history on bottom of file
**/
IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spTrackableObjectInsert')
	DROP PROCEDURE dbo.spTrackableObjectInsert
GO
  
CREATE PROCEDURE dbo.spTrackableObjectInsert (
 @TrackableObjectID bigint output,
 @ExternalObjectTypeId bigint,
 @ExternalObjectId nvarchar(50),
 @ExternalObjectOID varchar(50),
 @ExternalObjectName nvarchar(2000),
 @ProtocolName nvarchar(2000),
 @Created datetime output,
 @Updated datetime output,
 @ExternalObjectNameId int,
 @TaskCounter int,
 @IsTestStudy bit,
 @StudyProjectID INT,
 @AuditStudyGroupUUID NVARCHAR(100),
 @SourceUpdatedAt DATETIME,
 @SegmentId int
)
AS

BEGIN
 DECLARE @UtcDate DateTime
 SET @UtcDate = GetUtcDate()
 SELECT @Updated = @UtcDate, @Created = @UtcDate

 INSERT dbo.TrackableObjects (AuditStudyGroupUUID, ExternalObjectTypeId, ExternalObjectId, ExternalObjectOID, ExternalObjectName, ProtocolName, SegmentId, Created, Updated, ExternalObjectNameId, TaskCounter, IsTestStudy, StudyProjectID, SourceUpdatedAt)
  VALUES (@AuditStudyGroupUUID, @ExternalObjectTypeId, @ExternalObjectId, @ExternalObjectOID, @ExternalObjectName, @ProtocolName, @SegmentId, @Created, @Updated, @ExternalObjectNameId, @TaskCounter, @IsTestStudy, @StudyProjectID, @SourceUpdatedAt)
 SET @TrackableObjectID = SCOPE_IDENTITY()
END

GO
