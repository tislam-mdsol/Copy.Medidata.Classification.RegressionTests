 /* Copyright© 2009, Medidata Solutions Worldwide, All Rights Reserved.

 This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
 this file may not be disclosed to third parties, copied or duplicated in 
 any form, in whole or in part, without the prior written permission of
 Medidata Solutions Worldwide.

 Author: Vikas Choithani (vchoithani@mdsol.com)
*/

-- WORK IN PROGRESS

if object_id('spStdStrngTypInsrt') is not null
	drop procedure spStdStrngTypInsrt
go

create procedure spStdStrngTypInsrt
	@StringType varchar(50), 
	@ProductName char(4), 
	@DescriptionTag varchar(250)
as

	if exists(select null FROM StdStringTypeR WHERE StringType = @StringType and ProductName = @ProductName)
	begin
		raiserror('StringType - %s already exists in Product - %s. StringType must be unique within the Product.', 16, 1, @StringType, @ProductName)
	end
	else
	begin
		insert into StdStringTypeR (
			StringType, 
			ProductName, 
			DescriptionTag
		) values (
			@StringType, 
			@ProductName, 
			@DescriptionTag
		)
	end