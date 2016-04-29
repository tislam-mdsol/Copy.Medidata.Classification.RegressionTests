/** 
** Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Debbie Silberberg  dsilberberg@mdsol.com
**/

IF object_id('spLclztnRfrncsBlkSv') is not null
		DROP  Procedure spLclztnRfrncsBlkSv
GO 

create procedure spLclztnRfrncsBlkSv
(@lclTable LocalizationRefT readonly)
as
begin
	MERGE LclDataStringReferences AS lclRefs
	USING  @lclTable AS udt
	ON (lclRefs.ObjectTypeId = udt.ObjectTypeId 
	and lclRefs.PropertyName=udt.PropertyName and lclRefs.ObjectId = udt.ObjectId)
	WHEN MATCHED 
		THEN UPDATE SET LclStringID = udt.StringId 
	WHEN NOT MATCHED THEN
		INSERT (LclStringID, ObjectTypeID, PropertyName, ObjectId)
			VALUES (udt.StringId, udt.ObjectTypeID, udt.PropertyName, udt.ObjectID);
end	
	