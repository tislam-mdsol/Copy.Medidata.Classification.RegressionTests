/*
** Copyright© 2003, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Jeffrey Cohen jcohen@mdsol.com
**
**/

-- WORK IN PROGRESS

if object_id('spActvtnFndByCd') is not null
	drop procedure spActvtnFndByCd
go


CREATE Procedure spActvtnFndByCd
	@ActivationCode char(8)
AS
SELECT * from activations
WHERE ActivationCode =  @ActivationCode
GO


/**
** Revision History:
** $Log: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spActivationFindByCode.sql $
** 
** 4     12/18/06 9:34p Sryabkov
** commented out GRANT EXEC
** 
** 1     5/17/05 2:53p Iwong
** 
** 3     2/16/04 1:13a Jcohen
** Updates as part of project cleanup
** 
** 2     5/28/03 11:54a Sgagliardo
** prefix with dbo.
** 
** 1     5/21/03 11:43a Jcohen
** Initial Version
**
** $Header: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spActivationFindByCode.sql 4     12/18/06 9:34p Sryabkov $
** $Workfile: spActivationFindByCode.sql $
**/