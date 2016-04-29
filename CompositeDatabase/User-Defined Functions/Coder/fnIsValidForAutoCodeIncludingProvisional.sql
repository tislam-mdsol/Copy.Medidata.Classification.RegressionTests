/* 
** Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Altin Vardhami [avardhami@mdsol.com]
**/ 

IF object_id('fnIsValidForAutoCodeIncludingProvisional') IS NOT NULL
	DROP FUNCTION dbo.fnIsValidForAutoCodeIncludingProvisional
GO

CREATE FUNCTION [dbo].fnIsValidForAutoCodeIncludingProvisional
(
    @IsAutoApproval BIT,
    @ForcePrimaryPath BIT,
	@IsExactMatch BIT,
	@SynonymStatus TINYINT,
	@PathCount INT
)
RETURNS BIT
AS
BEGIN

	IF (@SynonymStatus > 0)
		RETURN dbo.fnIsValidForAutoCode(@IsAutoApproval, @ForcePrimaryPath, @IsExactMatch, 2, @PathCount)

	RETURN 0

END