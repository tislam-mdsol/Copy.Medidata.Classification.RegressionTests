/*
** Copyright© 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Madalina Tanasie	mtanasie@mdsol.com
**/


if object_id('spLclDtStrngCntxtsLd') is not null
	drop procedure spLclDtStrngCntxtsLd
go

create procedure spLclDtStrngCntxtsLd
AS

select ContextID as ContextId, ObjectTypeId as ObjectTypeId from LclDataStringContexts

GO
