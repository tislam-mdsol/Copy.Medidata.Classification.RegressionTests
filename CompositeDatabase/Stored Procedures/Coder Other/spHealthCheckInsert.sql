/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Donghan Wang dwang@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spHealthCheckInsert')
	DROP PROCEDURE spHealthCheckInsert
GO
create procedure dbo.spHealthCheckInsert
(
	@HealthCheckID BIGINT OUTPUT,
	@SP_Detect VARCHAR(256),
	@SP_Fix VARCHAR(256),
	@Description VARCHAR(256)
)
AS	

BEGIN
	INSERT INTO HealthChecksR (  
		SP_Detect,
		SP_Fix,
		[Description]
	) VALUES (  
		@SP_Detect,
		@SP_Fix,
		@Description
	)  
	
	SET @HealthCheckID = SCOPE_IDENTITY()  	
	
END
GO      
 
