/*
** Copyright(c) 2006, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Debasis Goswami (dgoswami@mdsol.com)
**
**/

-- WORK IN PROGRESS

if object_id('spActnTypLdByMdlAndNm') is not null
	drop procedure spActnTypLdByMdlAndNm
go

create procedure spActnTypLdByMdlAndNm 
@ModuleId int , 
@ActionName nvarchar(500)
as
select * from ModuleActions
 join ActionTypeR on ModuleActions.ActionType = ActionTypeR.ActionType
where ModuleId = @ModuleId and Name = @ActionName 
GO

