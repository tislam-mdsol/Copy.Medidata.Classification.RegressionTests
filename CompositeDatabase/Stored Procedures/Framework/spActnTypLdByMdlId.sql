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

if object_id('spActnTypLdByMdlId') is not null
	drop procedure spActnTypLdByMdlId
go

create procedure spActnTypLdByMdlId
	@ModuleID int
as
	select * from ActionTypeR T inner join ModuleActions M on M.ActionType = T.ActionType
	where M.ModuleID = @ModuleID
GO

/**
** Revision History:
** $Log: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spActionTypeLoadByModuleId.sql $
** 
** 2     12/18/06 9:34p Sryabkov
** commented out GRANT EXEC
** 
** 1     10/09/06 4:26p Dgoswami
** 
** $Header: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spActionTypeLoadByModuleId.sql 2     12/18/06 9:34p Sryabkov $
** $Workfile: spActionTypeLoadByModuleId.sql $
**/

