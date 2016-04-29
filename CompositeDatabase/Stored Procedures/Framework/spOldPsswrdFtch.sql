/*
** Copyright© 2003, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Jeffrey Cohen jcohen@medidatasolutions.com
**
**/

-- WORK IN PROGRESS

IF object_id('spOldPsswrdFtch') is not null
		DROP  Procedure  spOldPsswrdFtch
GO

CREATE Procedure spOldPsswrdFtch
	@UserID int,
	@OldPassword nvarchar(50)
AS
	SELECT     MAX(Changed) AS Changed
	FROM         OldPasswords
	WHERE     (UserID = @UserID) AND (OldPassWord LIKE @OldPassword)

GO

/**
** Revision History:
** $Log: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spOldPasswordFetch.sql $
** 
** 4     12/18/06 9:36p Sryabkov
** commented out GRANT EXEC
** 
** 1     5/17/05 2:55p Iwong
** 
** 1     10/15/03 3:32p Jcohen
** Initial Version
**
** $Header: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spOldPasswordFetch.sql 4     12/18/06 9:36p Sryabkov $
** $Workfile: spOldPasswordFetch.sql $
**/