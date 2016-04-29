 /** $Workfile: fnFormat.sql $
**
** Copyright© 2006, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Vladimir Kochetkov (VKochetkov@mdsol.com)
**
** Complete history on bottom of file
**/

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fnFormat]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[fnFormat]
GO

Create function [dbo].[fnFormat](@Format nvarchar(2000), @Values nvarchar(2000), @Delimiter char) returns nvarchar(4000)
BEGIN	-- replaces {0}, {1}, {2}, etc in @Format with corresponding values from @Values

declare @CharIndex0 int, @CharIndex int, @LoopIndex int, @Value nvarchar(2000)

set @CharIndex0 = 0
set @LoopIndex = 0
while 1 = 1 begin
	select @CharIndex = CharIndex(@Delimiter, @Values, @CharIndex0)
	if @CharIndex = 0 break
	set @Value = substring(@Values, @CharIndex0, @CharIndex - @CharIndex0)
	set @CharIndex0 = @CharIndex + 1
	set @Format = replace(@Format, '{' + cast(@LoopIndex as nvarchar(20)) + '}', @Value)
	set @LoopIndex = @LoopIndex + 1
end
set @Value = substring(@Values, @CharIndex0, len(@Values) - @CharIndex0 + 1)
set @Format = replace(@Format, '{' + cast(@LoopIndex as nvarchar(20)) + '}', @Value)

return @Format

END

GO
