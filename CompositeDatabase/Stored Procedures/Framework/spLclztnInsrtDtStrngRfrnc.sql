/** 
** Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Madalina Tanasie mtanasie@mdsol.com
**/

if object_id('spLclztnInsrtDtStrngRfrnc') is not null
	drop procedure spLclztnInsrtDtStrngRfrnc
go

create procedure spLclztnInsrtDtStrngRfrnc
(
	@StringId int,
	@ObjectId int,
	@PropertyName varchar(100),
	@ObjectTypeId int,
	@SegmentID int
)
as

if not exists (select 1 from LclDataStringReferences where ObjectTypeId = @ObjectTypeId and PropertyName=@PropertyName and ObjectId = @ObjectId and SegmentID = @SegmentID)
begin
	insert into LclDataStringReferences (LclStringID, ObjectTypeID, PropertyName, ObjectId, SegmentID)
	values (@StringId, @ObjectTypeId, @PropertyName, @ObjectId, @SegmentID)
end
else
begin
	update LclDataStringReferences  set LclStringID = @StringId
	where ObjectTypeId = @ObjectTypeId and PropertyName=@PropertyName and ObjectId = @ObjectId and SegmentID = @SegmentID

end

go  