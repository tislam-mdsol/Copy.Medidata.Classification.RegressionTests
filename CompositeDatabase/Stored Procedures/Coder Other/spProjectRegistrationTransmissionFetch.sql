/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spProjectRegistrationTransmissionFetch')
	DROP PROCEDURE spProjectRegistrationTransmissionFetch
GO
CREATE PROCEDURE dbo.spProjectRegistrationTransmissionFetch
(
	@ProjectRegistrationTransmissionID int
)
AS
	
	SELECT *
	FROM ProjectRegistrationTransms
	WHERE ProjectRegistrationTransmissionID = @ProjectRegistrationTransmissionID

	
GO  
  