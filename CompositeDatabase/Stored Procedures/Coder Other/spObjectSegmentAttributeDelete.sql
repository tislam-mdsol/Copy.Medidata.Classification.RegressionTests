/** 
** Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Altin Vardhami [avardhami@mdsol.com]
**/
----------------------------------------------------------------------------
--spObjectSegmentAttributeDelete
----------------------------------------------------------------------------
if exists (select * from sysobjects where id = object_id(N'dbo.spObjectSegmentAttributeDelete') and objectproperty(id, N'IsProcedure') = 1)
    drop procedure dbo.spObjectSegmentAttributeDelete
go

Create Procedure dbo.spObjectSegmentAttributeDelete
(
	@ObjectSegmentAttributeId int
)
as

	delete from ObjectSegmentAttributes
	where ObjectSegmentAttributeId=@ObjectSegmentAttributeId
	
GO 