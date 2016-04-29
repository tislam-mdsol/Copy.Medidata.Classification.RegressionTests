IF EXISTS 
    (SELECT NULL FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = 'CRICompletedCodingJobs')
    DROP VIEW CRICompletedCodingJobs
GO
    CREATE VIEW CRICompletedCodingJobs
    AS
    (SELECT		EDC.EDCDataId,

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

                EDC.QueryComment AS QueryValue ,
				X.InvalidTask ,
                Y.QueryStatus ,

                EDC.AssignedCodingPath ,
				EDC.MedicalDictionaryLevelKey,
                SMM.MedicalDictionaryVersionLocaleKey ,

                US.Login,
				US.FirstName,

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

				JOIN dbo.Users US (NOLOCK)
					ON US.IMedidataId = EDC.UserUUID

				JOIN dbo.CodingRequests CR
					ON CR.CodingRequestId = EDC.CodingRequestId

				CROSS APPLY
				(
					SELECT InvalidTask = CASE WHEN ISNULL(EDC.QueryComment, NULL) = NULL THEN 0 ELSE 1 END
				) AS X
				CROSS APPLY
				(
					SELECT IsCodedTask = CASE WHEN ISNULL(EDC.AssignedCodingPath, NULL) = NULL THEN 0 ELSE 1 END,
						QueryStatus = CASE WHEN InvalidTask = 1 THEN 2 ELSE 0 END -- 2 means open, 0 means closed
				) AS Y
				CROSS APPLY
				(
					SELECT IsClosed = IsCodedTask | InvalidTask
				) AS Z
      WHERE Z.IsClosed = 1
    )
GO

