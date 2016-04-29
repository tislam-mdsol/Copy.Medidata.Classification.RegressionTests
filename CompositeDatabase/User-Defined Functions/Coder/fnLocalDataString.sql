IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnLocalDataString')
BEGIN
	DROP FUNCTION dbo.[fnLocalDataString]
END
GO
CREATE function [dbo].[fnLocalDataString]
(
	@StringID as int, 
	@Locale as varchar(3), 
	@SegmentID INT
) returns nvarchar(4000)
begin
	declare @string nvarchar(4000)
	set @string=(SELECT 
				String
			FROM
				LocalizedDataStrings
			WHERE
				StringID=@StringID AND
				Locale=@Locale AND
				SegmentID = @SegmentID)
				
	IF (@string IS NULL)
	BEGIN
		
		-- get the english string if no local found
		SELECT @string = '['+dbo.fnLocalDataString(@StringID, InsertedInLocale, @SegmentID)+']'
		FROM LocalizedDataStringPKs
		WHERE StringId = @StringID
			AND SegmentID = @SegmentID
		
	END
	
	return @string
end
GO