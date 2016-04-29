IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spLclztnFndOrInsrtDtStrng')
	DROP PROCEDURE dbo.[spLclztnFndOrInsrtDtStrng]
GO
CREATE procedure [dbo].[spLclztnFndOrInsrtDtStrng]
    @String nvarchar(4000), -- modified to nvarchar to support japanese strings
	@Locale varchar(3),
	@StringId int output,
	@SegmentId int
as
set @StringId = null
--search the string
select @StringId = StringId from LocalizedDataStrings 
where String = @String and Locale = @Locale and SegmentId = @SegmentId
--if not found 
if (@StringId is null)
begin
	exec spLclztnInsrtDtStrng @String, @Locale, @SegmentID, @StringID output
end
