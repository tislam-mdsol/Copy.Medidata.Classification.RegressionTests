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

-- CONVERSION TO ORACLE COMPLETE

if object_id('spUsrObjtRlUpsrt') is not null
	drop procedure spUsrObjtRlUpsrt
go

create procedure spUsrObjtRlUpsrt
	@GrantToObjectID int,
	@GrantToObjectTypeID tinyint,
	@GrantOnObjectID int,
	@GrantOnObjectTypeID tinyint,
	@RoleID int,
	@Active bit,
	@DenyObjectRole bit,
	@Count int output
as

if(@RoleID <= 0) SET @RoleID = NULL

if (@RoleID is null and @GrantOnObjectTypeID = 11 and @DenyObjectRole = 1)
	set @RoleID = -101
if (@RoleID is null and @GrantOnObjectTypeID = 61 and @DenyObjectRole = 1)
	set @RoleID = -102

if exists (select null from UserObjectRole where GrantToObjectID=@GrantToObjectID and GrantToObjectTypeID=@GrantToObjectTypeID and GrantOnObjectID=@GrantOnObjectID and GrantOnObjectTypeID=@GrantOnObjectTypeID)
begin
	update UserObjectRole set
		GrantToObjectID = @GrantToObjectID,
		GrantToObjectTypeID = @GrantToObjectTypeID,
		GrantOnObjectID = @GrantOnObjectID,
		GrantOnObjectTypeID = @GrantOnObjectTypeID,
		RoleID = @RoleID,
		Active = @Active,
		DenyObjectRole = @DenyObjectRole,
		Updated = GetUtcDate()
		where GrantToObjectID=@GrantToObjectID and GrantToObjectTypeID=@GrantToObjectTypeID and GrantOnObjectID=@GrantOnObjectID and GrantOnObjectTypeID=@GrantOnObjectTypeID
		set @Count = 1
end
else
begin		
	insert into UserObjectRole (
		GrantToObjectID,
		GrantToObjectTypeID,
		GrantOnObjectID,
		GrantOnObjectTypeID,
		RoleID,
		Active,
		DenyObjectRole,
		Created,
		Updated)
	values (
		@GrantToObjectID,
		@GrantToObjectTypeID,
		@GrantOnObjectID,
		@GrantOnObjectTypeID,
		@RoleID,
		@Active,
		@DenyObjectRole,
		GetUtcDate(),
		GetUtcDate())
		set @Count = 0
end
go

/**
** Revision History:
** $Log: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spUserObjectRoleUpsert.sql $
** 
** 6     12/18/06 9:37p Sryabkov
** commented out GRANT EXEC
** 
** 5     12/04/06 4:46p Dgoswami
** Introduced deny role.
** 
** 4     11/21/06 11:30a Dfenster
** roleid less than or equal to 0 means null.
** 
** 3     10/10/06 3:29p Dfenster
** Implemented ability to add or remove or deny users or security groups
** to secure objects.
** implemented role fetching.
** 
** 2     10/06/06 1:57p Dgoswami
** Changed datatype for types to tinyint.
** 
** 1     10/05/06 3:14p Dgoswami
** 
** $Header: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spUserObjectRoleUpsert.sql 6     12/18/06 9:37p Sryabkov $
** $Workfile: spUserObjectRoleUpsert.sql $
**/