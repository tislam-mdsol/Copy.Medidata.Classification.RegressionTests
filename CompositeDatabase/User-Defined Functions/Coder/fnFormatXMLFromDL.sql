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


/* Generates a formatted XML stream from a delimited list,
   used by fnParseDelimitedString and FnSplitStringInt 
   used as a trick to allow the statements to be inline
   table functions. Without setting it to a variable first makes it super slow */
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnFormatXMLFromDL')
DROP FUNCTION dbo.[fnFormatXMLFromDL]
GO
create function dbo.fnFormatXMLFromDL(@input nvarchar(max),@sep nchar(1))
returns xml
--with schemabinding
as
begin
declare @xml xml = cast('<i>'+replace(@input,@sep,'</i><i>')+'</i>' as xml)
return @xml
end
go
