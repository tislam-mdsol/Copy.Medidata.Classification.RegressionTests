/*
** Copyrightę 2008, Medidata Solutions, Inc., All Rights Reserved.
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

if object_id('spStdStrngTypLd') is not null
	drop procedure spStdStrngTypLd
go

create procedure spStdStrngTypLd
as
	select * from StdStringTypeR

go

