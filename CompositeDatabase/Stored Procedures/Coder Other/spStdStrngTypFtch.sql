/*
** Copyright© 2008, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Madhavi Matta mmatta@mdsol.com
**
*/

-- WORK IN PROGRESS

if object_id('spStdStrngTypFtch') is not null
	drop procedure spStdStrngTypFtch
go

create procedure spStdStrngTypFtch(@StringTypeId int)
as
	select * from StdStringTypeR where StringTypeId = @StringTypeId

go
