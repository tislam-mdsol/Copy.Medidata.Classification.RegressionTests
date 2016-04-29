/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Sneha Saikumar ssaikumar@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF  EXISTS (SELECT * FROM sys.objects WHERE TYPE='p' and NAME = 'spGetCodingRequestODM')
DROP PROCEDURE [dbo].[spGetCodingRequestODM]
GO

CREATE PROCEDURE [dbo].[spGetCodingRequestODM]

@CodingRequestID int

AS
BEGIN

Select XmlContent from CodingRequests where CodingRequestID = @CodingRequestID

END
GO


