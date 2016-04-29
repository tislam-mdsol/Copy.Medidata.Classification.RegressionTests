 /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2008, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Jalal Uddin juddin@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingSourceTermReferenceFetch')
	DROP PROCEDURE spCodingSourceTermReferenceFetch
GO
create procedure dbo.spCodingSourceTermReferenceFetch
(
	@SourceTermReferenceId bigint
)
as
select * from CodingSourceTermReferences where SourceTermReferenceId=@SourceTermReferenceId
GO