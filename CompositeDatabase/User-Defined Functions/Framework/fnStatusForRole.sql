/*
** Copyright© 2006, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Keith Howells  khowells@mdsol.com
**
** This function returns the datastatus for a role 
**
*/

-- WORK IN PROGRESS

if object_id('fnStatusForRole') is not null
	drop function fnStatusForRole
go

CREATE FUNCTION fnStatusForRole(@rolelist varchar(1000), @roleid int) returns int as
BEGIN
	if @rolelist is null return null
	declare @idx int, @nextequals int, @rolechar varchar(6), @datastatus int, @found bit, @startidx int, @len int
	declare @endstatus int
	set @rolechar = rtrim(cast(@roleid as varchar))
	set @len = len(@rolechar)
	set @found=0
	set @startidx=1
	while @found=0
	begin
	  set @idx = charindex(@rolechar,@rolelist,@startidx)
	  if @idx = 0  -- shouldn't happen, but need to break out
		set @found = 1
	  else if (@idx=1 or substring(@rolelist,@idx-1,1) in (' ',','))
			   and @idx+@len < len(@rolelist)
			   and substring(@rolelist,@idx+@len,1) in (',','=')
		set @found =1
	  else set @startidx = @idx + 1
	end
	if @idx = 0
	  set @datastatus=null
	else
	begin
	  set @nextequals = charindex('=',@rolelist, @idx)
	  if @nextequals=0
		set @datastatus=null
	  else
	  begin
		set @endstatus = charindex(' ',@rolelist,@nextequals)
		if @endstatus = 0 set @endstatus = len(@rolelist)+1
		set @datastatus=cast(substring(@rolelist,@nextequals+1,@endstatus-@nextequals-1) as int)
	  end  
	end 
	return @datastatus
END

go