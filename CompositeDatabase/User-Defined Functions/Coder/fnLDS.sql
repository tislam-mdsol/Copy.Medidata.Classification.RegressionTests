/** $Workfile: fnLDS.sql $
**
** Copyright(c) 2007, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Jalal Uddin [juddin@mdsol.com]
**
** Complete history on bottom of file
**/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnLDS')
BEGIN
	DROP FUNCTION dbo.fnLDS
END
GO

CREATE function dbo.fnLDS(@StringID as int, @Locale as char(3)) returns nvarchar(4000)
begin
	declare @string nvarchar(4000)
	declare @default_locale char(3)
	set @string=(SELECT String FROM LocalizedDataStrings WHERE StringID = @StringID AND Locale = @Locale)
	if @string IS NULL
	begin
		SELECT @default_locale = ConfigValue FROM Configuration WHERE Tag = 'DefaultLocale'
		set @string=(SELECT String FROM LocalizedDataStrings WHERE StringID = @StringID AND Locale = @default_locale)
	end
	return @string
end
GO

/**
** Revision History:
** $Log: /Coding Workbench/Database Scripts/User Defined Functions/fnLDS.sql $
** 
** 1     3/30/07 4:03p Juddin
** Initial Check In
** 
** 
** $Header: /Coding Workbench/Database Scripts/User Defined Functions/fnLDS.sql 1     3/30/07 4:03p Juddin $
** $Workfile: fnLDS.sql $
**/ 