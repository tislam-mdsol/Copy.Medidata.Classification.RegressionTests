/** $Workfile: spTransmissionQueueItemLoadAll.sql $
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
IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spTransmissionQueueItemLoadAll')
	DROP PROCEDURE dbo.spTransmissionQueueItemLoadAll
GO

CREATE PROCEDURE dbo.spTransmissionQueueItemLoadAll
AS

BEGIN
	SELECT *
	FROM dbo.TransmissionQueueItems
	WHERE SuccessCount = 0
END

GO

/**
** Revision History:
** $Log:  $
**
**
** $Header: $
** $Workfile: $
**/
