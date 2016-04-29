IF EXISTS 
    (SELECT NULL FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = 'CompletedCodingJobs')
    DROP VIEW CompletedCodingJobs
GO
    CREATE VIEW CompletedCodingJobs
    AS
    (SELECT		CE.CodingElementId,

                T.ExternalObjectOID AS StudyOID ,
                T.ExternalObjectName AS StudyName ,
				T.TrackableObjectID AS StudyID,

                EDC.Subject,
                EDC.Field AS SourceField,
                EDC.Form AS SourceForm,
                EDC.Event,
                EDC.Line,
                EDC.Site,
                EDC.VerbatimTerm ,

				EDC.SupplementFieldKey0,
				EDC.SupplementFieldKey1,
				EDC.SupplementFieldKey2,
				EDC.SupplementFieldKey3,
				EDC.SupplementFieldKey4,
                    
				EDC.SupplementFieldVal0,
				EDC.SupplementFieldVal1,
				EDC.SupplementFieldVal2,
				EDC.SupplementFieldVal3,
				EDC.SupplementFieldVal4,

                CQ.QueryText AS QueryValue ,
				CE.IsInvalidTask ,
                CE.QueryStatus ,
                CE.AssignedCodingPath ,
                US.Login,
				US.FirstName,

				EDC.MedicalDictionaryLevelKey,
                SMM.MedicalDictionaryVersionLocaleKey ,

                EDC.Created ,
                EDC.BatchOID ,

                CR.SourceSystemId ,
				T.SegmentId ,

                COALESCE(CSV.FileName, '') AS [FileName] ,
                COALESCE(CSV.UserID, '') AS [UserId]
      FROM      EDCData EDC (NOLOCK)

                JOIN TrackableObjects T (NOLOCK) 
					ON T.TrackableObjectID = EDC.StudyUUID

                JOIN StudyDictionaryVersion SDV (NOLOCK) 
					ON EDC.RegistrationName = SDV.RegistrationName
					AND T.TrackableObjectID = SDV.StudyID

				JOIN SynonymMigrationMngmt SMM (NOLOCK) 
					ON SDV.SynonymManagementID = SMM.SynonymMigrationMngmtID

                JOIN dbo.CodingRequestCsvData CSV (NOLOCK) 
					ON EDC.CodingRequestId = CSV.CodingRequestId

				JOIN dbo.CodingRequests CR
					ON CR.CodingRequestId = EDC.CodingRequestId

				JOIN dbo.CodingElements CE
					ON CE.EDCDataId = EDC.EDCDataID

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
				) AS US
      WHERE CE.IsClosed = 1
    )
GO

