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
--spSegmentsFetch
-----------------------------------------------------------------------------------------
IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spSegmentsFetch')
	DROP PROCEDURE dbo.spSegmentsFetch
GO
create procedure dbo.spSegmentsFetch
(
	@SegmentId int
)
as
	select * from Segments where SegmentID=@SegmentId
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