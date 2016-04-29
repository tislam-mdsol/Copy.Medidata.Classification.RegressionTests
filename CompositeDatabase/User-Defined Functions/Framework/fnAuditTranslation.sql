if exists (select * from dbo.sysobjects where id = object_id(N'dbo.fnAuditTranslation') and xtype in (N'FN', N'IF', N'TF'))
drop function dbo.fnAuditTranslation
GO


create function dbo.fnAuditTranslation (
@UnformattedString nvarchar(2000),
@PropertyName nvarchar(2000),
@NewData nvarchar(2000),
@OldData nvarchar(2000),
@Detail1 nvarchar(2000),
@Detail2 nvarchar(2000),
@Detail3 nvarchar(2000),
@Detail4 nvarchar(2000),
@Detail5 nvarchar(2000),
@ObjectTypeName nvarchar(500),
@Locale varchar(3))
returns nvarchar(2000)
as
Begin
 declare @formattedString nvarchar(2000), @TmpString nvarchar(2000)
 set @formattedString = @UnformattedString
 
 set @TmpString = replace(@formattedString, '{0}', @PropertyName)
 if (@TmpString is not null) set @formattedString = @TmpString
 set @TmpString = replace(@formattedString, '{1}', @NewData)
 if (@TmpString is not null) set @formattedString = @TmpString
 set @TmpString = replace(@formattedString, '{2}', @OldData)
 if (@TmpString is not null) set @formattedString = @TmpString
 set @TmpString = replace(@formattedString, '{3}', @Detail1)
 if (@TmpString is not null) set @formattedString = @TmpString
 set @TmpString = replace(@formattedString, '{4}', @Detail2)
 if (@TmpString is not null) set @formattedString = @TmpString
 set @TmpString = replace(@formattedString, '{5}', @Detail3)
 if (@TmpString is not null) set @formattedString = @TmpString
 set @TmpString = replace(@formattedString, '{6}', @Detail4)
 if (@TmpString is not null) set @formattedString = @TmpString
 set @TmpString = replace(@formattedString, '{7}', @Detail5)
 if (@TmpString is not null) set @formattedString = @TmpString
 set @TmpString = replace(@formattedString, '{8}', @ObjectTypeName)
 if (@TmpString is not null) set @formattedString = @TmpString
 
 if(charindex('{!3}',@formattedString) > 0)
 Begin
	 set @TmpString = replace(@formattedString, '{!3}', dbo.fnLDS(@Detail1, @locale))
	 if (@TmpString is not null) set @formattedString = @TmpString
 End
 
 if(charindex('{!4}',@formattedString) > 0)
 Begin
 set @TmpString = replace(@formattedString, '{!4}', dbo.fnLDS(@Detail2, @locale))
 if (@TmpString is not null) set @formattedString = @TmpString
 End
 
 if(charindex('{!5}',@formattedString) > 0)
 Begin
 set @TmpString = replace(@formattedString, '{!5}', dbo.fnLDS(@Detail3, @locale))
 if (@TmpString is not null) set @formattedString = @TmpString
 End
 
 if(charindex('{!6}',@formattedString) > 0)
 Begin
 set @TmpString = replace(@formattedString, '{!6}', dbo.fnLDS(@Detail4, @locale))
 if (@TmpString is not null) set @formattedString = @TmpString
 End
 
 if(charindex('{!7}',@formattedString) > 0)
 Begin
 set @TmpString = replace(@formattedString, '{!7}', dbo.fnLDS(@Detail5, @locale))
 if (@TmpString is not null) set @formattedString = @TmpString
 End
 
 return @formattedString
End
GO


