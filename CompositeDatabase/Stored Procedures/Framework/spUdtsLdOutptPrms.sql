/*
** Copyright© 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Debbie Silberberg dsilberberg@mdsol.com
**
*/


IF object_id('spUdtsLdOutptPrms') is not null
	DROP  Procedure  spUdtsLdOutptPrms
GO

-- join on types is hacky way to get the true name of the udt
CREATE Procedure [dbo].[spUdtsLdOutptPrms]
AS
SELECT o.object_id, 
       o.name AS object_name, 
	   c.name AS column_name,
	   t.name as type_name 
FROM sys.columns c 
JOIN sys.objects o ON o.object_id = c.object_id
JOIN sys.types t ON CHARINDEX(t.name, o.name, 3) =4
WHERE o.type = 'TT' AND t.name like '%Out[_]%'
order by o.name, c.column_id

GO 