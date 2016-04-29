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
*/

-- WORK IN PROGRESS

if object_id('spScrtyGrpIsNmUnq') is not null
	drop procedure spScrtyGrpIsNmUnq
go

create procedure spScrtyGrpIsNmUnq
	@unique bit output,
	@SecurityGroupName nvarchar(4000),
	@Locale char(3)
as
begin
	if exists (
		select null from SecurityGroup 
			where dbo.fnlds(SecurityGroupNameID, @Locale) = @SecurityGroupName and Active=1)
		set @unique = 0
	else
		set @unique = 1
end
go

/**
** Revision History:
** $Log: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spSecurityGroupIsNameUnique.sql $
** 
** 4     12/18/06 9:36p Sryabkov
** commented out GRANT EXEC
** 
** 3     10/09/06 10:40a Juddin
** Added Locale
** 
** 2     10/06/06 2:08p Dgoswami
** Checking against active security groups only.
** 
** 1     10/05/06 3:28p Dgoswami
** 
** $Header: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spSecurityGroupIsNameUnique.sql 4     12/18/06 9:36p Sryabkov $
** $Workfile: spSecurityGroupIsNameUnique.sql $
**/     