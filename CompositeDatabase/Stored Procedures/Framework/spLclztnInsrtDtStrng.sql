/*
** Copyright© 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Madalina Tanasie mtanasie@mdsol.com
**/

-- WORK IN PROGRESS

if object_id('spLclztnInsrtDtStrng') is not null
	drop procedure spLclztnInsrtDtStrng
go

create procedure spLclztnInsrtDtStrng
	@String nvarchar(4000),
	@Locale varchar(10) = 'eng',
	@SegmentId int,
	@StringID int output
AS
	insert LocalizedDataStringPKs (InsertedInLocale, SegmentId) values (@Locale, @SegmentId)
	SET @StringID = SCOPE_IDENTITY()

	INSERT LocalizedDataStrings(
		StringID,
		String,
		Locale,
		TranslationStatus,
		SegmentID)
	Values 
		(@StringID,
		@String, 
		@Locale,
		2,
		@SegmentId)
GO
