/*
** Copyright© 2004, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Unknown, added to VSS by Sergei Ryabkov sryabkov@mdsol.com
**
*/

-- CONVERSION TO ORACLE COMPLETE

if object_id('fnLocalDefault') is not null
	drop function fnLocalDefault
go

create function fnLocalDefault(@StringID as int) returns nvarchar(4000)
begin
	declare @string nvarchar(4000)
	set @string=(SELECT 
				String
			FROM
				LocalizedDataStrings
			WHERE
				StringID=@StringID
				AND Locale='eng')
	return @string
end
GO


/**
** Revision History:
** $Log: /IceMan/Medidata 5 RAVE Database Project/User-Defined Functions/fnLocalDefault.sql $
** 
** 1     5/17/05 2:58p Iwong
** 
** 1     12/01/04 1:53p Sryabkov
** 
** $Header: /IceMan/Medidata 5 RAVE Database Project/User-Defined Functions/fnLocalDefault.sql 1     5/17/05 2:58p Iwong $
** $Workfile: fnLocalDefault.sql $
**/