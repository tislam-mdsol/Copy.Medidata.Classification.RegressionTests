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
** Complete history on bottom of file
**/

-- WORK IN PROGRESS

if object_id('spLgnAttmptCntFlrs') is not null
	drop procedure spLgnAttmptCntFlrs
go

create procedure spLgnAttmptCntFlrs
	@LoginName nvarchar(50)
AS
	SELECT
		COUNT(*) as [Count]
	FROM
		LoginAttempts
	WHERE 
		LoginName = @LoginName 
		AND Success = 0
		AND Attempted > (SELECT	MAX(Attempted)
						FROM	LoginAttempts 
						WHERE	LoginName = @LoginName
								AND Success > 0)
GO



/**
** Revision History:
** $Log: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spLoginAttemptCountFailures.sql $
** 
** 5     12/18/06 9:35p Sryabkov
** commented out GRANT EXEC
** 
** 3     12/23/05 3:36p Bpontes
** Modified Procedure so that it looked for any Sucess Code of greater
** then 0, this allows the system to count the Unlock code of 2 and reset
** the number of failed login attempts
** 
** 1     5/17/05 2:55p Iwong
** 
** 3     10/11/04 5:23p Iwong
** added names to the select clause
** 
** 2     10/21/03 6:23p Jcohen
** Account for a login ID that never succeeded
** 
** 1     10/21/03 6:03p Jcohen
** Initial Version
**
** $Header: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spLoginAttemptCountFailures.sql 5     12/18/06 9:35p Sryabkov $
** $Workfile: spLoginAttemptCountFailures.sql $
**/