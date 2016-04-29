/*
** Copyright© 2011, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Altin Vardhami avardhami@mdsol.com
**/


if object_id('spLclztnLdDtStrByLocaleFrActvSgmts') is not null
	drop procedure spLclztnLdDtStrByLocaleFrActvSgmts
go
create procedure dbo.spLclztnLdDtStrByLocaleFrActvSgmts
(
 @locale char(3),    
 @SegmentID int    
 )
AS    
--returns the strings in requested locale or if not found in the locale in which they have been created     
select distinct pk.StringID, ls.String as String, ls.Locale as Locale, ls.TranslationStatus as TranslationStatus    
 from LocalizedDataStringPKs pk     
 join LocalizedDataStrings ls on pk.StringId = ls.StringID and ls.Locale=@locale     
where pk.SegmentID = @SegmentID  