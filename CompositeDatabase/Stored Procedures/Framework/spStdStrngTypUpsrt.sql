 /* Copyright© 2009, Medidata Solutions Worldwide, All Rights Reserved.

 This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
 this file may not be disclosed to third parties, copied or duplicated in 
 any form, in whole or in part, without the prior written permission of
 Medidata Solutions Worldwide.

 Author: Vikas Choithani (vchoithani@mdsol.com)
*/

-- WORK IN PROGRESS

if object_id('spStdStrngTypUpsrt') is not null
	drop procedure spStdStrngTypUpsrt
go

create procedure spStdStrngTypUpsrt
	@StringType varchar(50), 
	@DescriptionTag varchar(50), 
	@ProductName char(4)
as
begin
	declare @UtcDate datetime = GetUtcDate()
	declare @Created datetime = @UtcDate
	declare @Updated datetime = @UtcDate


	declare @ExistingStringTypeId int
	declare @ExistingDescriptionTag varchar(50)
	select @ExistingStringTypeId = StringTypeID, @ExistingDescriptionTag = DescriptionTag from StdStringTypeR where StringType = @StringType and ProductName = @ProductName
	
	if @ExistingStringTypeId is not null
	begin
		if(@DescriptionTag <> @ExistingDescriptionTag) --string comparision ..?
		begin
			update StdStringTypeR set DescriptionTag = @DescriptionTag, Updated = @Updated where StringTypeID = @ExistingStringTypeId
		end
	end
	else
	begin
		insert into StdStringTypeR(StringType, ProductName, DescriptionTag, Created, Updated) values
		(@StringType, @ProductName, @DescriptionTag, @Created, @Updated)
	end
end
go