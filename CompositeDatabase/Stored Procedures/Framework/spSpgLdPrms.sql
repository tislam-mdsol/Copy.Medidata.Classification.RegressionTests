/*
** Copyright© 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Slavko Krstic skrstic@mdsol.com
**
*/


IF object_id('spSpgLdPrms') is not null
	DROP  Procedure  spSpgLdPrms
GO

CREATE Procedure spSpgLdPrms
AS
SELECT SCHEMA_NAME(schema_id) schema_name
    ,o.name object_name
    ,o.type_desc
    ,p.parameter_id parameter_ordinal
    ,p.name parameter_name
    ,TYPE_NAME(p.user_type_id) parameter_type
    ,p.max_length
    ,p.precision
    ,p.scale
    ,p.is_output
FROM sys.procedures o
LEFT JOIN sys.parameters p ON o.object_id = p.object_id
WHERE o.name like 'gp%' and o.type='P'
ORDER BY schema_name, o.name, p.parameter_id
GO