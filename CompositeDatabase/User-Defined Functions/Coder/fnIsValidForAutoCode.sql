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

IF object_id('fnIsValidForAutoCode') IS NOT NULL
	DROP FUNCTION dbo.fnIsValidForAutoCode
GO

CREATE FUNCTION [dbo].fnIsValidForAutoCode
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

	IF (@SynonymStatus = 2 AND
			  (
			       (@IsAutoApproval = 1 AND @PathCount <> 1 AND @ForcePrimaryPath = 0 )
					OR 
					@IsAutoApproval=0
					OR 
					@IsExactMatch = 0
			  )
		)
		RETURN 1

	RETURN 0	

END