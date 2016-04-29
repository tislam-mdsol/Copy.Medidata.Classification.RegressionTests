/*
** Copyright© 2005, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Sergei Ryabkov sryabkov@mdsol.com,
** modified by Altin Vardhami avardhami@mdsol.com - upgraded to Coder/Framework Localization
**
*/

-- CONVERSION TO ORACLE COMPLETE

if object_id('fnLDS') is not null
	drop function fnLDS
go

create function fnLDS(@StringID as int, @Locale as char(3)) returns nvarchar(4000)
begin
	declare @string nvarchar(4000)

	SELECT @string = NULL


	SELECT @string = String 
	FROM LocalizedDataStrings 
	WHERE StringID = @StringID 
		AND Locale = @Locale

	if @string IS NULL
	begin
		
		SELECT @string = N'[' + LDS.String + N']'
		FROM LocalizedDataStrings LDS
			JOIN LocalizedDataStringPKs LDSPK
				ON LDS.StringID = LDSPK.StringID
				AND LDSPK.StringID = @StringID
				AND LDS.Locale = LDSPK.InsertedInLocale
		
	
		-- this should never be executed. We should always have strings for all locales
		--SELECT @default_locale = ConfigValue FROM Configuration WHERE Tag = 'DefaultLocale'
		--set @string=(SELECT String FROM LocalizedDataStrings WHERE StringID = @StringID AND Locale = @default_locale)
	end
	return @string
end
GO
