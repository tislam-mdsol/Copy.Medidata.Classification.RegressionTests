/*
** Copyright© 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Vikas Choithani (vchoithani@mdsol.com)
**
*/

-- WORK IN PROGRESS

if object_id('spLclztnLdStrngsByLclFrPrdct') is not null
	drop procedure spLclztnLdStrngsByLclFrPrdct
go

create procedure spLclztnLdStrngsByLclFrPrdct
	@ProductName varchar(4), 
	@Locale char(3)
as

select 
	StringName, String 
from LocalizedStrings 
where 
	ProductName = @ProductName and Locale = @Locale

go 
