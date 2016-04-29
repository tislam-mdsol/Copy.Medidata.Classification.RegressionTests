/*
** Copyright© 2008, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: [unknown]
**
** This procedure parses a welcome message and substitutes values for any names in braces
**
**/ 

-- WORK IN PROGRESS

IF object_id('spMdlFtchById') is not null
		DROP  Procedure  spMdlFtchById
GO

create proc spMdlFtchById @ModuleId int
as
	select * from modulesr where ModuleId = @ModuleId
GO
