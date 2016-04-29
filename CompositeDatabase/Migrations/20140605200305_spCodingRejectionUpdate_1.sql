/** $Workfile: spCodingRejectionUpdate.sql $
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

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingRejectionUpdate')
	DROP PROCEDURE dbo.spCodingRejectionUpdate
GO

CREATE PROCEDURE dbo.spCodingRejectionUpdate (
 @CodingRejectionID bigint,
 @CodingElementID bigint,
 @UserID int,
 @Comment nvarchar(4000),
 @Created datetime,
 @Updated datetime output,
 @SegmentID int
)
AS

BEGIN
 DECLARE @UtcDate DateTime
 SET @UtcDate = GetUtcDate()
 SET @Updated = @UtcDate

 UPDATE dbo.CodingRejections SET
  CodingElementID = @CodingElementID,
  SegmentId = @SegmentId,
  UserID = @UserID,
  Comment = @Comment,
  Created = Created,
  Updated = @UtcDate
 WHERE CodingRejectionID = @CodingRejectionID
END

GO
