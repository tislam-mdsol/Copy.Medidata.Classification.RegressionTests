/*
** Copyright© 2008, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Isaac Wong iwong@mdsol.com
**
**/

-- WORK IN PROGRESS

if object_id('spActvtnFtchByUsrID') is not null
	drop procedure spActvtnFtchByUsrID
go

CREATE Procedure spActvtnFtchByUsrID
	@UserID int
AS

	SELECT * From Activations WHERE UserID = @UserID

GO


/**
** Revision History:
** $Log: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spActivationFetchByUserID.sql $
** 
** 4     12/18/06 9:34p Sryabkov
** commented out GRANT EXEC
** 
** 1     5/17/05 2:53p Iwong
** 
** 1     11/17/03 10:15a Iwong
** Added Activation Fetch, FetchByUserID, and Insert stored procedures
**
** $Header: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spActivationFetchByUserID.sql 4     12/18/06 9:34p Sryabkov $
** $Workfile: spActivationFetchByUserID.sql $
**/