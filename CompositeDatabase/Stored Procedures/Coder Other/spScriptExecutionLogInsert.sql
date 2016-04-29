/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Steve Myers smyers@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spScriptExecutionLogInsert')
	BEGIN
		DROP  Procedure  spScriptExecutionLogInsert
	END
GO

CREATE Procedure dbo.spScriptExecutionLogInsert
	(
		@AppVersion VARCHAR(50),
		@ScriptName VARCHAR(256),
		@ScriptRunByDbLogin VARCHAR(50),
		@AppliedBy VARCHAR(50),
		@AppliedFrom VARCHAR(50),
		@StartTime DATETIME,
		@EndTime DATETIME,
		@ResultMessage VARCHAR(1000),
		@SQLResultCode VARCHAR(20),
		@SegmentID INT,
		@StudyID BIGINT
	)
AS

BEGIN

	-- retrieve the ID for this version (creating if doesn't already exist)
	DECLARE @AppVersionID AS INT

	SELECT @AppVersionID = AppVersionID
	FROM AppVersions WHERE Version = @AppVersion

	IF @AppVersionID IS NULL
	BEGIN
		-- insert as Inactive
		INSERT INTO AppVersions (Version, Active, Updated) VALUES (@AppVersion, 0, GetUtcDate())
		SET @AppVersionID = SCOPE_IDENTITY()
	END

	-- make script execution entry
	INSERT INTO ScriptExecutionLog (
		AppVersionID,
		ScriptName,
		ScriptRunByDbLogin,
		AppliedBy,
		AppliedFrom,
		StartTime,
		EndTime,
		ResultMessage,
		SQLResultCode,
		SegmentID,
		StudyID
	) VALUES (  
		@AppVersionID,
		@ScriptName,
		@ScriptRunByDbLogin,
		@AppliedBy,
		@AppliedFrom,
		@StartTime,
		@EndTime,
		@ResultMessage,
		@SQLResultCode,
		@SegmentID,
		@StudyID
	)  

END
GO
