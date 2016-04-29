/** $Workfile: spCodingTransmissionSuccessByCodingSourceTerm.sql $
**
** Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingTransmissionSuccessByCodingSourceTerm')
	DROP PROCEDURE spCodingTransmissionSuccessByCodingSourceTerm
GO

CREATE PROCEDURE dbo.spCodingTransmissionSuccessByCodingSourceTerm
	@CodingSourceTermID bigint
AS

BEGIN
	declare @foundSuccessfulTransmission bit = 0
	if exists (
		select *
		from CodingTransmissions
		where CodingSourceTermID = @CodingSourceTermID and TransmissionSuccess = 1
	)
	set @foundSuccessfulTransmission = 1

	select @foundSuccessfulTransmission
END
GO
