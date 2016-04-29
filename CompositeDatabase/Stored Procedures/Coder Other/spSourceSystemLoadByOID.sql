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

if exists (select * from sysobjects where type = 'P' and name = 'spSourceSystemLoadByOID')
	drop procedure dbo.spSourceSystemLoadByOID
GO
create procedure dbo.spSourceSystemLoadByOID
	@SourceSystemOID varchar(50)
as
begin
	select * from SourceSystems where OID = @SourceSystemOID
end
go
