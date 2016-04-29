/**
** Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Altin Vardhami avardhami@mdsol.com
**/

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spQueryConfirmationFetch')
	DROP PROCEDURE dbo.spQueryConfirmationFetch
GO
  
CREATE PROCEDURE dbo.spQueryConfirmationFetch
(  
	@QueryConfirmationId BIGINT
)  
AS  
BEGIN

	SELECT *
	FROM dbo.QueryConfirmations
	WHERE QueryConfirmationId = @QueryConfirmationId

END  
GO