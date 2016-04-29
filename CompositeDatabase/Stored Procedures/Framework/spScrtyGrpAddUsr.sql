/*
** Copyright© 2003, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: David Fenster dfenster@mdsol.com
**
*/

-- WORK IN PROGRESS

if object_id('spScrtyGrpAddUsr') is not null
	drop procedure spScrtyGrpAddUsr
GO

CREATE Procedure spScrtyGrpAddUsr
	@SecurityGroupID int,
	@UserID int
AS
	IF NOT EXISTS (SELECT NULL FROM SecurityGroupUser WHERE SecurityGroupID=@SecurityGroupID AND UserID=@UserID)
	INSERT INTO SecurityGroupUser
	(
		UserID,
		SecurityGroupID,
		Created,
		Updated
	)
	VALUES
	(
		@UserID,
		@SecurityGroupID,
		GetUTCDate(),
		GETUTCDATE()
	)
GO


/**
** Revision History:
** $Log: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spSecurityGroupAddUser.sql $
** 
** 2     12/18/06 9:36p Sryabkov
** commented out GRANT EXEC
** 
** 1     10/12/06 4:31p Dfenster
** Added spSecurityGroupAddUser and spSecurityGroupRemoveUser
** $Header: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spSecurityGroupAddUser.sql 2     12/18/06 9:36p Sryabkov $
** $Workfile: spSecurityGroupAddUser.sql $
**/ 