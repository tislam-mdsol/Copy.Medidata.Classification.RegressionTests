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
*/

-- WORK IN PROGRESS

if object_id('spLgnAttmptInsrt') is not null
	drop procedure spLgnAttmptInsrt
go

create procedure spLgnAttmptInsrt
	@LoginName nvarchar(50),
	@LoginID int,
	@Attempted DateTime, -- not used
	@NetworkAddress nvarchar(255),
	@Success smallint,
	@AttemptID int OUTPUT
AS
	INSERT INTO LoginAttempts 
	(LoginName,
	LoginID,
	Attempted,
	NetworkAddress,
	Success)
	VALUES
	(@LoginName,
	@LoginID,
	getutcdate(),
	@NetworkAddress,
	@Success)
	
	set @AttemptID = SCOPE_IDENTITY() 

GO


/**
** Revision History:
** $Log: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spLoginAttemptInsert.sql $
** 
** 7     2/02/07 2:36p Sryabkov
** added/removed comments
** 
** 6     1/31/07 3:22p Jthomson
** RAVE 5 - #5546 : Ensure that all timestamps come from the Database
** Server
** 
** 5     12/18/06 9:35p Sryabkov
** commented out GRANT EXEC
** 
** 3     12/23/05 3:36p Bpontes
** changed Sucess from a bit to a small int
** 
** 1     5/17/05 2:55p Iwong
** 
** 1     10/21/03 6:04p Jcohen
** Initial Version
**
** $Header: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spLoginAttemptInsert.sql 7     2/02/07 2:36p Sryabkov $
** $Workfile: spLoginAttemptInsert.sql $
**/