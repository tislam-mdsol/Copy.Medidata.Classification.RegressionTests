/*
**
** Copyright© 2008, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Debbie Silberberg
**
** Complete history on bottom of file
*/

IF object_id('spSpgPthsLd') is not null
		DROP  Procedure  spSpgPthsLd
GO

CREATE Procedure spSpgPthsLd
AS
select * from SpugPaths

go 