/** $Workfile: spLocalizedDataStringsFetch.sql $
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

if exists (select * from sysobjects where id = object_id(N'dbo.spLocalizedDataStringsFetch') and objectproperty(id, N'IsProcedure') = 1)
    drop procedure dbo.spLocalizedDataStringsFetch
go

create Procedure [dbo].[spLocalizedDataStringsFetch]
	@StringID int,
	@Locale char(3),
	@String nvarchar(2000) output
AS
	SELECT top 1 @String=String FROM LocalizedDataStrings 
	WHERE StringID = @StringID and Locale = @Locale
	
	
Go
/**
** Revision History:
** $Log: $
** 
** 
** 
** $Header: $
** $Workfile: $
**/ 