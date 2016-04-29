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

if object_id('spLclztnLdDtStrByIdFrActvSgmts') is not null
	drop procedure spLclztnLdDtStrByIdFrActvSgmts
go

create procedure spLclztnLdDtStrByIdFrActvSgmts
	@stringId int,
	@locale char(3),
	@SegmentID int
AS

--select distinct ls.StringID, ls.String as String, ls.Locale as Locale
--from LocalizedDataStrings ls
----left join LclDataStringReferences lr on lr.LclStringID = ls.StringID
--where ls.SegmentID = @SegmentID 
----and lr.StringReferenceID is null 
--and ls.locale = @locale

SELECT DISTINCT LDSPK.StringID, 
	CASE WHEN LDS.String IS NULL THEN N'['+ LDS_Original.String + N']'
		ELSE LDS.String
		END AS String, @locale AS Locale
FROM LocalizedDataStringPKs LDSPK
	LEFT JOIN LocalizedDataStrings LDS
		ON LDS.StringID = LDSPK.StringId
		AND LDS.SegmentID = LDSPK.SegmentID
		AND LDS.Locale = @locale
		AND LDSPK.SegmentID = @SegmentID
	JOIN LocalizedDataStrings LDS_Original
		ON LDS_Original.StringID = LDSPK.StringId
		AND LDS_Original.SegmentID = LDSPK.SegmentID
		AND LDS_Original.Locale = LDSPK.InsertedInLocale
WHERE LDSPK.SegmentID = @SegmentID


GO