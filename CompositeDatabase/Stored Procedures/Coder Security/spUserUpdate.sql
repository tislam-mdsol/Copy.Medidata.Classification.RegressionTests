/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2014, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUserUpdate')
	DROP PROCEDURE spUserUpdate
GO

CREATE PROCEDURE dbo.spUserUpdate 
(
	@UserID BIGINT,  
	@FirstName NVARCHAR(255),
	@LastName NVARCHAR(255),
	@TimeZoneInfo NVARCHAR(255),
	@Email NVARCHAR(255),
	@Login NVARCHAR(50),
	@Locale CHAR(3),
	@Active BIT,
	@Updated DATETIME OUTPUT
)  
AS  
  
BEGIN  

	SELECT @Updated = GetUtcDate()  

	UPDATE Users
	SET
		FirstName = @FirstName,
		LastName = @LastName,
		Email = @Email,
		[Login] = @Login,
		Locale = @Locale,
		Active = @Active,
		TimeZoneInfo = 	@TimeZoneInfo,
		Updated = @Updated
	 WHERE UserID = @UserID

END

GO 