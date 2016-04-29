/** $Workfile: spCodingAssignmentDelete.sql $
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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingAssignmentDelete')
	DROP PROCEDURE spCodingAssignmentDelete
GO

CREATE PROCEDURE spCodingAssignmentDelete (
	@CodingAssignmentID bigint
	-- @SegmentID INT
)
AS

BEGIN
	DELETE FROM dbo.CodingAssignment
	WHERE CodingAssignmentID = @CodingAssignmentID
END

GO
