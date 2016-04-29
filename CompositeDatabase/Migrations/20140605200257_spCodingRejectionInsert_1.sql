 /** $Workfile: spCodingRejectionInsert.sql $
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

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingRejectionInsert')
	DROP PROCEDURE dbo.spCodingRejectionInsert
GO

CREATE PROCEDURE dbo.spCodingRejectionInsert (
 @CodingRejectionID bigint output,
 @CodingElementID bigint,
 @UserID int,
 @Comment nvarchar(4000),
 @Created datetime output,
 @Updated datetime output,
 @SegmentID int
)
AS

BEGIN
	DECLARE @UtcDate DateTime
	
	SET @UtcDate = GetUtcDate()
	SELECT @Created = @UtcDate, @Updated = @UtcDate

	INSERT INTO dbo.CodingRejections (
	  CodingElementID,
	  UserID,
	  Comment,
	  Created,
	  Updated,
	  SegmentId
	 )
	 VALUES (
	  @CodingElementID,
	  @UserID,
	  @Comment,
	  @UtcDate,
	  @UtcDate,
	  @SegmentId
	 )

	 SET @CodingRejectionID = SCOPE_IDENTITY()
	
END

GO
