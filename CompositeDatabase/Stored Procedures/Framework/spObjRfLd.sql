/*
**
** Copyright© 2008, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Slavko Krstic skrstic@mdsol.com
**
** Complete history on bottom of file
*/

-- WORK IN PROGRESS

IF object_id('spObjRfLd') is not null
		DROP  Procedure  spObjRfLd
GO

CREATE Procedure spObjRfLd
	@ModelId int
AS

select ObjectiveReferenceID,OriginatingObjectType, TargetObjectType,ImplementingProperty, Integrity,ImplementingIDProperty from ObjectiveReferences objrefs where not exists (select null from ObjRefModelExclusions exc where exc.ObjRefId = objrefs.ObjectiveReferenceId) or exists (select null from ObjRefModelExclusions exc where exc.ObjRefId = objrefs.ObjectiveReferenceId and exc.ModelId=@ModelId)

go