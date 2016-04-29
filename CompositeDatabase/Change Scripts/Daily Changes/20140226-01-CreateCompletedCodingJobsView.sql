IF EXISTS 
    (SELECT NULL FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = 'CompletedCodingJobs')
    DROP VIEW CompletedCodingJobs
GO
    CREATE VIEW CompletedCodingJobs
    AS
    ( SELECT    CE.CodingElementId ,
                T.ExternalObjectOID AS StudyOID ,
                T.ExternalObjectName AS StudyName ,
                CE.SourceSubject AS Subject ,
                CE.SourceField ,
                CE.SourceForm ,
                CE.VerbatimTerm ,
                CQ.QueryText AS QueryValue ,
                CE.QueryStatus,
                CE.DictionaryLevelId ,
                CE.CodingElementGroupId ,
                CE.AssignedSegmentedGroupCodingPatternId ,
                CE.AssignedCodingPath ,
                SDV.DictionaryLocale ,
                DVR.OID AS DictionaryVersionOID ,
                DR.OID AS DictionaryOID ,
                dbo.fnLocalString(DR.OID, SDV.DictionaryLocale) AS DictionaryName ,
                CA.Login,
                DVR.Ordinal AS DictionaryVersionOrdinal,
                CE.Created,
				CR.BatchOID,
				ODM.Event,
				ODM.Line,
				ODM.Site
      FROM      CodingElements CE
                JOIN StudyDictionaryVersion SDV
                JOIN DictionaryVersionRef DVR ON DVR.DictionaryVersionRefID = SDV.DictionaryVersionId
                JOIN DictionaryRef DR ON DR.DictionaryRefID = SDV.MedicalDictionaryID ON CE.StudyDictionaryVersionId = SDV.StudyDictionaryVersionID
                JOIN TrackableObjects T ON T.TrackableObjectID = SDV.StudyID
                JOIN dbo.CodingRequests CR ON CE.CodingRequestId = CR.CodingRequestId
                OUTER APPLY ( SELECT    Users.Login
                              FROM      dbo.CodingAssignment CA
                                        JOIN Users ON CA.UserID = Users.UserID
                              WHERE     CA.CodingElementID = CE.CodingElementId
                            ) AS CA
                OUTER APPLY ( SELECT TOP 1
                                        QueryText
                              FROM      CoderQueries
                              WHERE     CodingElementId = CE.CodingElementId
                              ORDER BY  QueryId DESC
                            ) AS CQ
				CROSS APPLY
				(
					SELECT [Event], [Site], [Line]
					FROM
					(
						SELECT ReferenceName, ReferenceValue
						FROM CodingSourceTermReferences
						WHERE CodingSourceTermId = CE.CodingElementId
					) AS SourceTable
					PIVOT
					(
						MIN(SourceTable.ReferenceValue)
						FOR SourceTable.ReferenceName IN ([Event],[Site],[Line])
					) AS PivotTable
				) AS ODM
         WHERE CE.IsClosed = 1
    )
GO

