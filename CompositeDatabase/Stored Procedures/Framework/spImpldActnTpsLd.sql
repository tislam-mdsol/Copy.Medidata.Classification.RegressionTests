/*
** Copyright© 2005, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Isaac Wong iwong@mdsol.com
** Moved By: Arsen Karapetyan
*/

-- WORK IN PROGRESS

if object_id('spImpldActnTpsLd') is not null
	drop procedure spImpldActnTpsLd
go

create procedure spImpldActnTpsLd
	/* Param List */
AS

select * from ImpliedActionTypes

GO


/**
** Revision History:
** $Log: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spImpliedActionTypesLoad.sql $
** 
** 4     12/18/06 9:35p Sryabkov
** commented out GRANT EXEC
** 
** 1     5/17/05 2:55p Iwong
** 
** 1     4/21/05 3:24p Iwong
** Added spImpliedActionTypesLoad to the project.
**
** $Header: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spImpliedActionTypesLoad.sql 4     12/18/06 9:35p Sryabkov $
** $Workfile: spImpliedActionTypesLoad.sql $
**/