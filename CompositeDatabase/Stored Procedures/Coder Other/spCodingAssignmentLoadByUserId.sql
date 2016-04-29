/**
**
** Copyright(c) 2008, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Jalal Uddin [juddin@mdsol.com], Altin : added segment
**
** Complete history on bottom of file
**/

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingAssignmentLoadByUserId')
	DROP PROCEDURE dbo.spCodingAssignmentLoadByUserId
GO

CREATE PROCEDURE dbo.spCodingAssignmentLoadByUserId 
(
	@UserId int,
	@SegmentID INT
)
AS
BEGIN
SET NOCOUNT ON
                                                                                                       
	select * 
	from CodingAssignment 
	where UserID = @UserId
		AND SegmentID = @SegmentID

END

GO

 