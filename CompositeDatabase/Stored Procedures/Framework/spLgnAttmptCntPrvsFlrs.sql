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

if object_id('spLgnAttmptCntPrvsFlrs') is not null
	drop procedure spLgnAttmptCntPrvsFlrs
go

create procedure spLgnAttmptCntPrvsFlrs
	@LoginName nvarchar(50)
AS
	DECLARE @LastSuccess DateTime;
	DECLARE @PreviousSuccess DateTime;
	 
	SELECT @LastSuccess = MAX (Attempted)
	FROM LoginAttempts 
	WHERE LoginName = @LoginName
	AND Success > 0
	
	SELECT @PreviousSuccess = MAX (Attempted)
	FROM LoginAttempts 
	WHERE LoginName = @LoginName
	AND Success > 0
	AND Attempted <> @LastSuccess	

	IF ( @LastSuccess IS NOT NULL AND @PreviousSuccess IS NOT NULL)
	BEGIN
	SELECT COUNT(*) as 'Count' FROM LoginAttempts WHERE 
	Attempted > @PreviousSuccess
	AND Attempted < @LastSuccess
	AND LoginName = @LoginName 
	AND Success = 0
	END

GO

/**
** Revision History:
** $Log: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spLoginAttemptCountPreviousFailures.sql $
** 
** 4     12/18/06 9:35p Sryabkov
** commented out GRANT EXEC
** 
** 1     5/17/05 2:55p Iwong
** 
** 2     10/11/04 5:25p Iwong
** Added names to the select clause
** 
** 1     11/04/03 11:32a Jcohen
** Initial Version
**
** $Header: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spLoginAttemptCountPreviousFailures.sql 4     12/18/06 9:35p Sryabkov $
** $Workfile: spLoginAttemptCountPreviousFailures.sql $
**/