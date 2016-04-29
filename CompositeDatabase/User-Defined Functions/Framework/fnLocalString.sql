/*
** Copyright(c) 2005-2006, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Debasis Goswami (dgoswami@mdsol.com)
**
*/

-- WORK IN PROGRESS

if object_id('fnLocalString') is not null
	drop function fnLocalString
go

create function fnLocalString(@key as varchar(50), @locale as char(3)) returns nvarchar(4000)
begin
	declare @ReturnString as nvarchar(4000)
	select @ReturnString = (select [String] from dbo.LocalizedStrings 
		where [StringName] = @key and [Locale] = @locale)
	if (@ReturnString is null)
	begin
		select @ReturnString = '[' + @KEY + ']'
	end
	return @ReturnString
end
go


/**
** Revision History:
** $Log: /Viper/Medidata 5 RAVE Database Project/User-Defined Functions/fnLocalString.sql $
** 
** 6     12/29/06 7:55p Khowells
** Performance improvement - corrected the datatypes of the arguments so
** an index is used in the search
** 
** 4     2/17/06 6:03p Dgoswami
** Replaced varchar with nvarchar.
** 
** 2     6/21/05 4:01p Dgoswami
** Updated the function to return [key] if the locale string was not
** found.
** 
** 1     6/16/05 4:13p Dgoswami
** Reads from table dbo.LocalizedStrings
**
** $Header: /Viper/Medidata 5 RAVE Database Project/User-Defined Functions/fnLocalString.sql 6     12/29/06 7:55p Khowells $
** $Workfile: fnLocalString.sql $
**/