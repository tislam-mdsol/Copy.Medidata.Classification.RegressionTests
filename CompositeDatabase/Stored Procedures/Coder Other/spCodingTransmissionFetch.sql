﻿/** $Workfile:  $
**
** Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Mark Hwe [mhwe@mdsol.com]
**
** Complete history on bottom of file
**/

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingTransmissionFetch')
	DROP PROCEDURE dbo.spCodingTransmissionFetch
GO
create procedure dbo.spCodingTransmissionFetch
(
	@CodingTransmissionID bigint
)
as
	select * from CodingTransmissions where CodingTransmissionID = @CodingTransmissionID
GO
/**
** Revision History:
** $Log: $
** 
** 
** 
** $Header: $
** $Workfile: $
**/