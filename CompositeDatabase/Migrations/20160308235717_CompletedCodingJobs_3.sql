IF EXISTS 
    (SELECT NULL FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = 'CompletedCodingJobs')
    DROP VIEW CompletedCodingJobs
GO
    CREATE VIEW CompletedCodingJobs
    AS
    (SELECT    COALESCE(CE.CodingElementId, 0) CodingElementId ,
                CE.IsInvalidTask ,
                CE.IsClosed ,
                T.ExternalObjectOID AS StudyOID ,
                T.ExternalObjectName AS StudyName ,
				T.TrackableObjectID AS StudyID,
                CE.SourceSubject AS Subject ,
                CE.SourceField ,
                CE.SourceForm ,
                CE.VerbatimTerm ,
                CQ.QueryText AS QueryValue ,
                CE.QueryStatus ,
                CE.MedicalDictionaryLevelKey ,
                CE.CodingElementGroupId ,
                CE.AssignedSegmentedGroupCodingPatternId ,
                CE.AssignedCodingPath ,
                SMM.MedicalDictionaryVersionLocaleKey ,
                UserData.Login,
				UserData.FirstName,
                CE.Created ,
                CE.BatchOID ,
                CE.SourceEvent ,
                CE.SourceLine ,
                CE.SourceSITE as [Site],
                CE.SourceSystemId,
                COALESCE(CSV.FileName, '') AS [FileName] ,
                COALESCE(CSV.UserID, '') AS [UserId],
				COALESCE(CE.SegmentId,0) AS SegmentId
      FROM      CodingElements CE (NOLOCK)
                JOIN StudyDictionaryVersion SDV (NOLOCK) ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionID
				JOIN SynonymMigrationMngmt SMM (NOLOCK) ON SDV.SynonymManagementID = SMM.SynonymMigrationMngmtID
                JOIN TrackableObjects T (NOLOCK) ON T.TrackableObjectID = SDV.StudyID
                JOIN dbo.CodingRequestCsvData CSV (NOLOCK) ON CE.CodingRequestId = CSV.CodingRequestId
			    OUTER APPLY ( SELECT    TOP  1 UserId, Created
										--Users.Login, Users.FirstName
                              FROM      dbo.CodingAssignment (NOLOCK)
                              WHERE     CodingElementID = CE.CodingElementId
							  ORDER BY CodingAssignmentID DESC
                            ) AS CA
                OUTER APPLY ( SELECT TOP 1
                                       Comment AS QueryText, UserId, Created
							  FROM      CodingRejections (NOLOCK)
							  WHERE     CodingElementID = CE.CodingElementId
							  ORDER BY CodingRejectionID DESC
							) AS CQ
				OUTER APPLY
				(
					SELECT Login, FirstName
					FROM Users
					WHERE UserID = (SELECT 
						CASE WHEN CA.UserId IS NULL THEN CQ.UserID 
						ELSE CASE WHEN CQ.UserId IS NULL THEN CA.UserID
							ELSE CASE WHEN CA.Created > CQ.Created THEN CA.UserID ELSE CQ.UserID END
							END
						END)
				) AS UserData
      WHERE     CE.IsClosed = 1
    )
GO
