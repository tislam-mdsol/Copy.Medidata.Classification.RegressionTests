﻿/** $Workfile:  $
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
--spSegmentsLoadAll
-----------------------------------------------------------------------------------------
IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spSegmentsLoadAll')
	DROP PROCEDURE dbo.spSegmentsLoadAll
GO
create procedure dbo.spSegmentsLoadAll
as
	select * from Segments
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