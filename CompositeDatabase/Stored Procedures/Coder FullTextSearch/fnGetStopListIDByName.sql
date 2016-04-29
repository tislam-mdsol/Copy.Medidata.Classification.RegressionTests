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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnGetStopListIDByName') BEGIN
	DROP FUNCTION dbo.fnGetStopListIDByName
END
GO
create function dbo.fnGetStopListIDByName(@stopListName sysname) returns int
as
begin
	return ( select stoplist_Id from sys.fulltext_stoplists where name=@stoplistname );
end