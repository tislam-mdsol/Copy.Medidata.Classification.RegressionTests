 /** 
** Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Debbie Silberberg  dsilberberg@mdsol.com
**/

IF object_id('spFndUdtUsg') is not null
		DROP  Procedure spFndUdtUsg
GO 

CREATE PROCEDURE spFndUdtUsg (@udtName varchar(30))
   AS
   BEGIN
		DECLARE @typeID int
		SELECT @typeID = user_type_id FROM sys.types WHERE name = @udtName
		
		SELECT o.name AS context_name,
			   o.type AS context_type, 
			   o.type_desc AS context_type_desc,
			   m.name AS member_name, 
			   m.type_desc AS member_type_desc
		FROM (
			SELECT object_id, name, 'SQL_COLUMN' AS type_desc
			  FROM sys.columns
			  WHERE user_type_id = @typeID
		 UNION ALL
			SELECT object_id, name, 'SQL_PROCEDURE_PARAMETER'
			  FROM sys.parameters
			  WHERE user_type_id = @typeID
		) AS m
    	JOIN sys.objects AS o
		ON o.object_id = m.object_id
    
END