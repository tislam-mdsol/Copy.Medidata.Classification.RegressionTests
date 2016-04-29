/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2014, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Eric Grun egrun@mdsol.com
//
// Change a project name and each study associated with this project
// Assumes standard naming convention for study '<project name> (studytype)'
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_ChangeProjectName')
	DROP PROCEDURE dbo.spCoder_CMP_ChangeProjectName
GO

CREATE PROCEDURE dbo.spCoder_CMP_ChangeProjectName
(
	@CurrentProjectName NVARCHAR(440),
	@SegmentName NVARCHAR(255),
	@DestinationProjectName NVARCHAR(440)
)
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @StudyProjectId INT, 
		@errorString NVARCHAR(MAX), 
		@successString NVARCHAR(MAX),
		@SegmentId INT

	SELECT @SegmentId = SegmentId
	FROM Segments 
	WHERE SegmentName = @SegmentName

	IF (@SegmentId IS NULL)
	BEGIN
	    SET @errorString = N'ERROR: No such segment found!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	SELECT @StudyProjectId = StudyProjectId
	FROM dbo.StudyProjects
	WHERE ProjectName = @CurrentProjectName
	    AND SegmentID = @SegmentId
	
	IF (@StudyProjectId IS NULL)
	BEGIN
	    SET @errorString = N'ERROR: No such study project found!' + @CurrentProjectName
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	BEGIN TRY

		BEGIN TRANSACTION

			IF EXISTS (SELECT StudyProjectId
				FROM dbo.StudyProjects
				WITH (XLOCK) -- exclusive lock on StudyProjects table to prevent insert of duplicate project before update statement
				WHERE ProjectName = @DestinationProjectName
					AND SegmentID = @SegmentId)

			BEGIN
				SET @errorString = N'ERROR: There is already a project named' + @DestinationProjectName
				PRINT @errorString
				RAISERROR(@errorString, 16, 1)
				RETURN 1
			END

			--update the project name
			UPDATE StudyProjects
			SET ProjectName = @DestinationProjectName
			WHERE StudyProjectId = @StudyProjectId

			DECLARE @Temp_StudyNameChange TABLE (OriginalName NVARCHAR(2000), UpdatedName NVARCHAR(2000))

			--update the study names
			UPDATE tk
			SET tk.ExternalObjectName = @DestinationProjectName + right(tk.ExternalObjectName, len(tk.ExternalObjectName) - len(@CurrentProjectName))
			OUTPUT 
				DELETED.ExternalObjectName,
				INSERTED.ExternalObjectName
			INTO
				@Temp_StudyNameChange
			FROM TrackableObjects tk
			WHERE tk.StudyProjectId = @StudyProjectId
			AND CHARINDEX(@CurrentProjectName, tk.ExternalObjectName) = 1

			DECLARE @updatestring NVARCHAR(MAX)
			SELECT @updatestring = COALESCE(@updatestring, N'Updated studies:' + CHAR(13)) + CHAR(9) + OriginalName + N' => ' + UpdatedName + CHAR(13)
			FROM @Temp_StudyNameChange
			PRINT @updatestring
	 
			SET @successString = N'Success! '+ @CurrentProjectName +N' project name has been changed to: '+@DestinationProjectName
			PRINT @successString

		 COMMIT TRANSACTION
	 END TRY

	 BEGIN CATCH

		ROLLBACK TRANSACTION
		DECLARE
			@ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE(),
			@ErrorNumber INT = ERROR_NUMBER(),
			@ErrorSeverity INT = ERROR_SEVERITY(),
			@ErrorState INT = ERROR_STATE(),
			@ErrorLine INT = ERROR_LINE(),
			@ErrorProcedure NVARCHAR(200) = ISNULL(ERROR_PROCEDURE(), '-');
		SELECT @errorString = N'CMP ERROR: Transaction Error Message - Error %d, Severity %d, State %d, Procedure %s, Line %d, Message: %s';
		RAISERROR (@errorString, @ErrorSeverity, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage)

	 END CATCH
END