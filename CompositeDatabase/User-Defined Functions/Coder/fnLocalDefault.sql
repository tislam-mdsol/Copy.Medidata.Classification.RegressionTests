IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnLocalDefault')
BEGIN
	DROP FUNCTION dbo.[fnLocalDefault]
END
GO
CREATE function [dbo].[fnLocalDefault](@StringID as int) returns nvarchar(4000)
begin
	declare @string nvarchar(4000)
	set @string=(SELECT 
				String
			FROM
				LocalizedDataStrings
			WHERE
				StringID=@StringID
				AND Locale='eng')
	return @string
end
GO