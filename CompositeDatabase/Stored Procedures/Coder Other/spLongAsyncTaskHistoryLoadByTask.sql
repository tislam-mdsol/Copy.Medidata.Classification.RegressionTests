/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spLongAsyncTaskHistoryLoadByTask')
	DROP PROCEDURE spLongAsyncTaskHistoryLoadByTask
GO

CREATE PROCEDURE dbo.spLongAsyncTaskHistoryLoadByTask 
(
	@TaskId INT,
	@MaxHistory INT
)  
AS  
BEGIN  

	SELECT TOP (@MaxHistory) *
	FROM LongAsyncTaskHistory
	WHERE TaskId = @TaskId
	ORDER BY TaskHistoryId DESC

END

GO