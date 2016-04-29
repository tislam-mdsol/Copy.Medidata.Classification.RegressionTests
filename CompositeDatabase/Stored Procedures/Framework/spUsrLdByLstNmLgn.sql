/*
** Copyright© 2008, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Justin Thomson jthomson@mdsol.com
**
*/

-- CONVERSION TO ORACLE COMPLETE

if object_id('spUsrLdByLstNmLgn') is not null
	drop procedure spUsrLdByLstNmLgn
go

create procedure spUsrLdByLstNmLgn
		@LastNameFilter nvarchar(255),
		@LoginFilter nvarchar(255)
AS

		SELECT
			*
		FROM 
			Users
		WHERE 
			UserID > 0
			AND LastName like '%' + COALESCE(@LastNameFilter, '') + '%'
			AND [Login] like '%' + COALESCE(@LoginFilter, '') + '%'
		ORDER BY
			LastName,
			[Login] desc
GO


/**
** Revision History:
** $Log: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spUserLoadByLastNameLogin.sql $
** 
** 1     3/03/08 3:18p Jthomson
** initial
** 
** $Header: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spUserLoadByLastNameLogin.sql 1     3/03/08 3:18p Jthomson $
** $Workfile: spUserLoadByLastNameLogin.sql $
**/