IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   type = 'P'
                    AND name = 'CMP_UpdateStudyProjectName' ) 
    DROP PROCEDURE dbo.CMP_UpdateStudyProjectName

GO

CREATE PROCEDURE dbo.CMP_UpdateStudyProjectName
    (
     @segmentName VARCHAR(250),
	 @studyProjectId int,
	 @oldProjectName nvarchar(440),
	 @newProjectName nvarchar(440)
    )
AS 
    BEGIN
    
        DECLARE @segmentId INT
           ,@startId INT
           ,@errorString NVARCHAR(MAX)

        SELECT  @segmentId = SegmentId
        FROM    Segments
        WHERE   SegmentName = @segmentName

		
        IF ( @segmentId IS NULL ) 
            BEGIN

                SELECT  'Cannot find Segment'

                RETURN 0

            END


		IF(Not(Exists(Select * from StudyProjects 
					  where StudyProjectId = @studyProjectId 
					    and SegmentID = @segmentId
						and projectName = @oldProjectName)))
		   Begin

				SELECT  'Cannot find Study Project: '+@segmentName+':'+Convert(varchar,@studyProjectId)+':'+@oldProjectName

                RETURN 0
		   End

        BEGIN TRY

            BEGIN TRANSACTION

			Update StudyProjects
			Set
				  ProjectName = @newProjectName
				 ,Updated     = GETUTCDATE()
			where SegmentID = @segmentId and StudyProjectId = @studyProjectId and ProjectName = @oldProjectName

			if(@@ROWCOUNT= 1)
				Print  'Updated study project ('+@segmentName+':'+Convert(varchar,@studyProjectId)+') name from '+@oldProjectName +' to ' + @newProjectName
			else
				print  'Cannot update study project: '+@segmentName+':'+Convert(varchar,@studyProjectId)+':'+@oldProjectName

            COMMIT TRANSACTION

        END TRY

        BEGIN CATCH

            ROLLBACK TRANSACTION

            SET @errorString = N'CMP ERROR: Transaction Error Message - '
                + ERROR_MESSAGE()

        --PRINT @errorString

            RAISERROR(@errorString, 16, 1)

        END CATCH	

    END