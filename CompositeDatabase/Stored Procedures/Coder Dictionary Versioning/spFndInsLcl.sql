/* Copyright© 2010, Medidata Solutions Worldwide, All Rights Reserved.

 This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
 this file may not be disclosed to third parties, copied or duplicated in 
 any form, in whole or in part, without the prior written permission of
 Medidata Solutions Worldwide.

 Author: Altin Vardhami avardhami@mdsol.com
*/



if object_id('spFndInsLcl') is not null
	drop procedure spFndInsLcl
go

create procedure dbo.spFndInsLcl
	@StringName varchar(50), 
	@String nvarchar(2000), 
	@Locale char(3), 
	@StringTypeID varchar(50), 
	@ProductName char(4), 
	@TranslationStatus int
as

begin try

	IF NOT EXISTS (SELECT NULL FROM LocalizedStrings
		WHERE StringName = @StringName
			AND Locale = @Locale
			AND ProductName = @ProductName)
	BEGIN
		EXECUTE spLclStdStrngInsrt @StringName, @String, @Locale, @StringTypeID, @ProductName, @TranslationStatus
	END
end try
begin catch
	Declare	@ErrorSeverity int, 
			@ErrorState int,
			@ErrorLine int,
			@ErrorMessage nvarchar(4000),
			@ErrorProc nvarchar(4000)

    select 
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE(),
		@ErrorLine = ERROR_LINE(),
		@ErrorMessage = ERROR_MESSAGE(),
		@ErrorProc = ERROR_PROCEDURE()
	select @ErrorMessage = coalesce(@ErrorProc, 'spLclStdStrngInsrt') + ' (' + cast(@ErrorLine as nvarchar) + '): ' + @ErrorMessage
    raiserror (@ErrorMessage,  @ErrorSeverity, @ErrorState)
end catch 