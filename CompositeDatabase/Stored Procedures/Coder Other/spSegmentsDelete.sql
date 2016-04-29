/** $Workfile:  $
**
** Copyright(c) 2007, Medidata Solutions, Inc., All Rights Reserved.
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
-----------------------------------------------------------------------------------------
--spSegmentsDelete
-----------------------------------------------------------------------------------------
IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spSegmentsDelete')
	DROP PROCEDURE dbo.spSegmentsDelete
GO
create procedure dbo.spSegmentsDelete
(
	@SegmentId int
)
as
	delete from Segments where SegmentId=@SegmentId

	-- Traverse hierarchy for all segments and set start/end sequence
	exec spSegmentsBuildHierarchy
GO
/**
** Revision History:
** $Log: $
** 
** 
** 
** $Header: $
** $Workfile: $
**/   