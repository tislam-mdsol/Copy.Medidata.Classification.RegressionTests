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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spInteractionInsert')
	DROP PROCEDURE spInteractionInsert
GO
CREATE PROCEDURE dbo.spInteractionInsert
	@UserID int,
	@SessionID varchar(36),
	@LastAttemptedURL nvarchar(2000),
	@Start datetime,
	@LastAccess datetime,
	@Finish datetime,
	@NetWorkAddress varchar(255),
	@InteractionStatus int,
	@ClickCount int,
	@EncryptionKey varchar(50),
	@InteractionID int OUTPUT

AS
BEGIN

	SET NOCOUNT ON

	INSERT INTO [dbo].[Interactions] (
		UserID,
		SessionID,
		LastAttemptedURL,
		Start,
		LastAccess,
		Finish,
		NetWorkAddress,
		InteractionStatus,
		ClickCount,
		EncryptionKey
	) VALUES (
		@UserID,
		@SessionID,
		@LastAttemptedURL,
		@Start,
		@LastAccess,
		@Finish,
		@NetWorkAddress,
		@InteractionStatus,
		@ClickCount,
		@EncryptionKey
	)

	SET @InteractionID = SCOPE_IDENTITY()

END
