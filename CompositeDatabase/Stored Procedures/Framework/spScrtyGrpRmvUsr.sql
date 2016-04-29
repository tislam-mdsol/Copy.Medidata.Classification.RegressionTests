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

if object_id('spScrtyGrpRmvUsr') is not null
	DROP  Procedure  spScrtyGrpRmvUsr
go

CREATE Procedure spScrtyGrpRmvUsr
	@SecurityGroupID int,
	@UserID int
AS
	DELETE FROM SecurityGroupUser WHERE SecurityGroupID=@SecurityGroupID AND UserID=@UserID
	
GO

/**
** Revision History:
** $Log: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spSecurityGroupRemoveUser.sql $
** 
** 2     12/18/06 9:36p Sryabkov
** commented out GRANT EXEC
** 
** 1     10/12/06 4:31p Dfenster
** Added spSecurityGroupAddUser and spSecurityGroupRemoveUser
** $Header: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spSecurityGroupRemoveUser.sql 2     12/18/06 9:36p Sryabkov $
** $Workfile: spSecurityGroupRemoveUser.sql $
**/ 