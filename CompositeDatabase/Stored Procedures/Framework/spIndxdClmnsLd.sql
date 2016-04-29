/*
** Copyright© 2008, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Vikas Choithani vchoithani@mdsol.com
**
*/ 

-- WORK IN PROGRESS
 
if object_id('spIndxdClmnsLd') is not null
	drop procedure spIndxdClmnsLd
go

CREATE Procedure spIndxdClmnsLd
as

select OBJECT_NAME(ic.object_id) as TableName,c.name as ColumnNames from sys.index_columns ic 
inner join sys.columns c on c.object_id=ic.object_id and ic.column_id=c.column_id
inner join sys.tables t on t.object_id=c.object_id
where ic.key_ordinal = 1
order by TableName
go
