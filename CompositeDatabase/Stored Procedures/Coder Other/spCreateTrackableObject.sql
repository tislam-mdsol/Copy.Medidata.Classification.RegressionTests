/** $Workfile: spCreateTrackableObject.sql $
**
** Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Jalal Uddin [juddin@mdsol.com]
**
** Complete history on bottom of file
**/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCreateTrackableObject')
	DROP PROCEDURE spCreateTrackableObject
GO

create procedure dbo.spCreateTrackableObject
(
	@ExternalObjectId NVARCHAR(500),
	@ExternalObjectOID VARCHAR(50),
	@ProtocolName NVARCHAR(500),
	@SegmentId INT,
	@IsTestStudy BIT,
	@TrackableObjectiD BIGINT OUTPUT
)
as
begin
		
	IF EXISTS (SELECT NULL FROM [dbo].[TrackableObjects] WHERE ExternalObjectId=@ExternalObjectId AND ExternalObjectOID=@ExternalObjectOID) BEGIN
		SELECT @TrackableObjectiD = TrackableObjectiD FROM [dbo].[TrackableObjects] WHERE ExternalObjectId=@ExternalObjectId AND ExternalObjectOID=@ExternalObjectOID
	END
	ELSE BEGIN
		INSERT INTO [dbo].[TrackableObjects]
		   ([ExternalObjectTypeId]
		   ,[ExternalObjectId]
		   ,[ExternalObjectOID]
		   ,[ExternalObjectName]
		   ,[ProtocolName]
		   ,[SegmentId]
		   ,[Created]
		   ,[Updated]
		   ,[ExternalObjectNameId]
		   ,[TaskCounter]
		   ,[IsTestStudy])
		 VALUES
		   (1
		   ,@ExternalObjectId
		   ,@ExternalObjectOID
		   ,@ExternalObjectOID
		   ,@ProtocolName
		   ,@SegmentId
		   ,GETUTCDATE()
		   ,GETUTCDATE()
		   ,0
		   ,0
		   ,@IsTestStudy)
		
		SELECT @TrackableObjectiD = SCOPE_IDENTITY()
		
	END
END
GO