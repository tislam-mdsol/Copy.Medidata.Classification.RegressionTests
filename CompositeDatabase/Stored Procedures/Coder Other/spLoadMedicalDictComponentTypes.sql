 /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Mark Hwe mhwe@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spLoadMedicalDictComponentTypes')
	DROP Procedure spLoadMedicalDictComponentTypes
GO

create procedure dbo.spLoadMedicalDictComponentTypes
as
begin

select d.MedicalDictionaryId, t.ComponentTypeID, t.OID ComponentOID
from MedicalDictionary d inner join MedicalDictComponentTypes t on d.MedicalDictionaryId = t.MedicalDictionaryID

end	
