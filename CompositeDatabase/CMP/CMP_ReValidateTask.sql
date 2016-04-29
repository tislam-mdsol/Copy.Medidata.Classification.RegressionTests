/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2014, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
//
// revalidates a task which is marked invalid in Coder
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_ReValidateTask')
	DROP PROCEDURE spCoder_CMP_ReValidateTask
GO

CREATE PROCEDURE dbo.spCoder_CMP_ReValidateTask
(  
	@SegmentName NVARCHAR(100),
	@Subject NVARCHAR(100),
	@Verbatim NVARCHAR(450)
)  
AS
BEGIN

	DECLARE @taskID BIGINT

	DECLARE @errorString NVARCHAR(MAX)

	-- find the taskID
	SELECT @taskID = CodingElementId
	FROM CodingElements
	WHERE SourceSubject = @Subject
		AND VerbatimTerm = @Verbatim
		AND IsInvalidTask = 1
		AND SegmentId IN (SELECT SegmentId FROM Segments WHERE SegmentName = @SegmentName)

	-- make sure it's the only task
	IF (1 < (SELECT COUNT(*)
		FROM CodingElements
		WHERE SourceSubject = @Subject
			AND VerbatimTerm = @Verbatim
			AND IsInvalidTask = 1
			AND SegmentId IN (SELECT SegmentId FROM Segments WHERE SegmentName = @SegmentName)))
	BEGIN
		SET @errorString = N'ERROR: More than one such task found - please be more specific!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	BEGIN TRY
	BEGIN TRANSACTION
	
		UPDATE CodingElements
		SET IsInvalidTask = 0,
			CacheVersion = CacheVersion + 10
		WHERE CodingElementId = @taskID

		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION

		SET @errorString = N'CMP ERROR: Transaction Error Message - ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH	

END
