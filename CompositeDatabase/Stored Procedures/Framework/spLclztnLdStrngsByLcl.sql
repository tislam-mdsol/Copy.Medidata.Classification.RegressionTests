/**
** Copyright© 2003, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Jeffrey Cohen jcohen@medidatasolutions.com
**
** Complete history on bottom of file
**
** Rave 5.6.3 name: spLocalizationGetStringsByLocale
**
**/

-- CONVERSION TO ORACLE COMPLETE

if object_id('spLclztnLdStrngsByLcl') is not null
	drop procedure spLclztnLdStrngsByLcl
go

create procedure spLclztnLdStrngsByLcl
	@loc char(3)
as

select 
	String, StringName 
from LocalizedStrings 
where 
	Locale = @loc

go


/**
** Revision History:
** 
** 4     12/18/06 9:35p Sryabkov
** commented out GRANT EXEC
** 
** 1     5/17/05 2:55p Iwong
** 
** 4     12/01/04 3:20p Iwong
** 
** 3     9/22/03 4:29p Jcohen
** Use StringName instead of StringID
** 
** 2     6/03/03 3:48p Jcohen
**
** $Header: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spLocalizationGetStringsByLocale.sql 4     12/18/06 9:35p Sryabkov $
** $Workfile: spLocalizationGetStringsByLocale.sql $
**/