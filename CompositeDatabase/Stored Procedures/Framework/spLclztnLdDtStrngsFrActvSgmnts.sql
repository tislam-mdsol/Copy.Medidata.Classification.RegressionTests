--spLclztnLdDtStrngsFrActvSgmntsByLcl 
/*
** Copyright© 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Madalina Tanasie mtanasie@mdsol.com
** Modified: Vikas Choithani vchoithani@mdsol.com
**/

--READY FOR REVIEW

if object_id('spLclztnLdDtStrngsFrActvSgmnts') is not null
	drop procedure spLclztnLdDtStrngsFrActvSgmnts
go

create procedure spLclztnLdDtStrngsFrActvSgmnts  
 @objectTypeId int,  
 @locale char(3),  
 @SegmentID int  
AS  
--returns the strings in requested locale or if not found in the locale in which they have been created   
select distinct pk.StringID, ls.String as String, ls.Locale as Locale, ls.TranslationStatus as TranslationStatus  
 from LocalizedDataStringPKs pk   
 join LclDataStringReferences ref on pk.StringId=ref.LclStringID and ref.objectTypeId = @objectTypeId   
 join LocalizedDataStrings ls on pk.StringId = ls.StringID and ls.Locale=@locale   
where pk.SegmentID = @SegmentID  