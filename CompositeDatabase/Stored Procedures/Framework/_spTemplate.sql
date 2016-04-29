/*
** Copyright© 2008, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: INSERT YOUR NAME AND EMAIL ADDRESS HERE (for existing SPs, do not change)
**
** Rave 5.6.3 name (if applicable): 
**
** Notes:
**
*/ 

-- WORK IN PROGRESS

if object_id('spTemplate') is not null
	drop procedure spTemplate
go

create procedure spTemplate
as
	return 0
go

-----------------------------------------------------------------------------------------
/*

Below are the instructions, DO NOT COPY TO YOUR STORED PROCEDURE

-----------------------------------------------------------------------------------------

The template header above is for new stored procedures.

-----------------------------------------------------------------------------------------

When copying stored procedure code from 5.6.3:

1) Preserve the existing header but
	- Remove '$Workfile: spStoredProcedureName.sql' at the top of the header
	- Do not change the original author's name 
	- Remove '** Complete history on bottom of file' because the might not be history at the bottom  
	  or it won't be full 
	- Specify the old stored procedure name in the comments (see the template header above)
2) Do NOT remove the footer

-----------------------------------------------------------------------------------------

For both new SPs and the ones copied from 5.6.3:

Do not use square brackets and  PRINT statements. THE FOLLOWING IS WRONG

IF object_id('[rave].[spStoredProcedureName]') is not null
...
PRINT 'Creating Procedure spStoredProcedureName'

-----------------------------------------------------------------------------------------

Possible status labels are (only one can be present at a time):

-- WORK IN PROGRESS
-- READY FOR REVIEW
-- BEING REVIEWED
-- CONVERT TO ORACLE
-- CONVERSION TO ORACLE IN PROGRESS
-- CONVERSION TO ORACLE COMPLETE

-----------------------------------------------------------------------------------------
SEE 'Sql Rules.doc' in Team Explorer in Visual Studio for the full list of guidelines
(nycrndtfs001.ad.mdsol.com/Rave 5.7 WIP/Documents/Database Development/Sql Rules.doc)
-----------------------------------------------------------------------------------------

*/

