/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// Burbea's spectacularly fast string parsing utility
//
// ------------------------------------------------------------------------------------------------------*/


IF EXISTS (SELECT * FROM sysobjects WHERE type in ('TF','IF') AND name = 'fnParseDelimitedString_XML')
BEGIN
DROP FUNCTION dbo.fnParseDelimitedString_XML
END
GO
-- I changed the type from a TF to an IF so this is the only way to be sure. 
create function dbo.fnParseDelimitedString_XML(@str nvarchar(max),@sep nchar(1))
returns table
as
return
(
select x.i.value('(./text())[1]','nvarchar(4000)') [item]
from (select xmllist= dbo.fnFormatXMLFromDL(@str,@sep) ) a
cross apply xmllist.nodes('i') x(i)
)

go
