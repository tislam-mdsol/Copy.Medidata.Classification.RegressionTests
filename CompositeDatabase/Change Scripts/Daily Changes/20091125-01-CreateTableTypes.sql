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

if not exists(select null from sys.table_types where name='TermSearchResultType') begin
	CREATE TYPE dbo.TermSearchResultType AS TABLE 
	( 
		TermId bigint not null -- Primary key
		, LevelId int null
		, RecursionDepth tinyint
		, Rank decimal(10,2) null
		, NodePath VARCHAR(MAX)
	)
end
go
if not exists(select null from sys.table_types where name='SynonymResultType') begin
	CREATE TYPE dbo.SynonymResultType AS TABLE 
	( 
		TermId bigint not null Primary key
		, SynonymTermId bigint null
		, MatchPercent decimal(10,2) null
	)
end
go

if not exists(select null from sys.table_types where name='TermArrayType') begin
	CREATE TYPE dbo.TermArrayType AS TABLE 
	( 
		TermId bigint not null Primary key
	)
end
go