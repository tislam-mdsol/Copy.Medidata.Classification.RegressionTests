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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spInteractionUpdate')
	DROP PROCEDURE spInteractionUpdate
GO

CREATE PROCEDURE dbo.spInteractionUpdate 
	@InteractionID int,
	@UserID int,
	@SessionID varchar(36),
	@LastAttemptedURL nvarchar(2000),
	@Start datetime,
	@LastAccess datetime,
	@Finish datetime,
	@NetWorkAddress varchar(255),
	@InteractionStatus int,
	@ClickCount int,
	@EncryptionKey varchar(50)

AS
BEGIN

	SET NOCOUNT ON

	UPDATE [dbo].[Interactions] SET
		UserID = @UserID,
		SessionID = @SessionID,
		LastAttemptedURL = @LastAttemptedURL,
		Start = @Start,
		LastAccess = @LastAccess,
		Finish = @Finish,
		NetWorkAddress = @NetWorkAddress,
		InteractionStatus = @InteractionStatus,
		ClickCount = @ClickCount,
		EncryptionKey = @EncryptionKey
	WHERE
		InteractionID = @InteractionID

END