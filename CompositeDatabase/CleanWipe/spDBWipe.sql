IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDBWipe')
	DROP PROCEDURE spDBWipe
GO

-- Db wipe tailored for Coder_V1 on sandbox
-- wipes on other DBs must consider the ids on the relevant tables
-- (see the identity reset section)
-- Parameter defaults match the source db (see above)
-- Runtime on Sandbox (~40GB db) : <21minutes

CREATE PROCEDURE dbo.spDBWipe
(
     @imedidataId_For_MedidataReserved1_Segment NVARCHAR(100)  = N'6b7df735-7526-4dfd-a334-3fef3b8e3118'
    ,@imedidataId_For_CoderAdmin_User           NVARCHAR(100)  = N'04677919-3e75-4e1c-80d2-0fb2a561a3f9'
    ,@imedidataId_For_ApplicationType_Coder     NVARCHAR(100)  = N'a4b09686-8c56-11e0-8306-12313b067011'
    ,@imedidataId_For_Application               NVARCHAR(200)  = N'b14c5063-2cb4-40db-8d82-284475f0a444'
    ,@url_For_Application                       NVARCHAR(2000) = N'https://coder-sandbox.imedidata.net/CoderCloud'
    ,@name_For_Application                      NVARCHAR(256)  = N'Coder Sandbox'
    ,@publicKey_For_Application                 NVARCHAR(500)  = N'-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCa6euYwRnqia6LsED4CY4aGhXZ
yB1971ywjXcOoWxxXTUT0F7lqGcJrBly/4pQweMDn9oiMlUTAh4jv1LW7R8FU1yb
GutvaaOVF8GGzf524JNVy8JRmQwB982WbGLj1EesLrXycf+Ugd6zibkf2K1J67OQ
NCosIANFcWjFrdKlLwIDAQAB
-----END PUBLIC KEY-----'

)
AS  
BEGIN

    --production check
    IF NOT EXISTS (
		    SELECT NULL 
		    FROM CoderAppConfiguration
		    WHERE Active = 1 AND IsProduction = 0)
    BEGIN
	    PRINT N'THIS IS A PRODUCTION ENVIRONMENT - DB Wipe Script must not proceed!'
	    RETURN
    END

    -- 1. Clean ALL client data
    -- Sandbox runtime (10m:17s)

    DECLARE @segmentOids TABLE(Id INT IDENTITY(1,1), SegmentOID VARCHAR(50))
    DECLARE @SegmentOID VARCHAR(50)

    INSERT INTO @segmentOids
    SELECT OID FROM Segments

    DECLARE @i INT = 1

    WHILE (1 = 1)
    BEGIN

        SELECT @SegmentOID = MAX(SegmentOID)
        FROM @segmentOids
        WHERE Id = @i

        IF (@SegmentOID IS NULL) BREAK

        EXEC spCodingElementsCleanup @SegmentOID, 1, 1, 1, 1

        SET @i = @i + 1

    END

    -- 2. Clean all remaining user data (missed on script above)
    -- Sandbox runtime (1m:14s)
        
    TRUNCATE TABLE CodingJobErrors
    TRUNCATE TABLE CoderQueryHistory
    TRUNCATE TABLE CsvCodingJobErrorToken
    TRUNCATE TABLE DictionaryLicenceInformations
    TRUNCATE TABLE DictionarySegmentConfigurations
    TRUNCATE TABLE DoNotAutoCodeTerms
    TRUNCATE TABLE DoNotAutoCodeLists
    TRUNCATE TABLE InvalidTaskQueue
    TRUNCATE TABLE LongAsyncTaskHistory
    TRUNCATE TABLE OutTransmissionLogs
    TRUNCATE TABLE OutTransmissions
    TRUNCATE TABLE RuntimeLocks
    TRUNCATE TABLE StudyProjects
    TRUNCATE TABLE SynonymListResetReport
    TRUNCATE TABLE SynonymUploadErrors
	DELETE FROM SynonymUploadRequests
    TRUNCATE TABLE TransmissionQueueItemLoadSourceTransmissions
    TRUNCATE TABLE TransmissionQueueItems
    TRUNCATE TABLE WorkflowTaskData
    TRUNCATE TABLE WorkflowTaskHistory

    -- 2. Step two - clean ALL meta data
    -- Sandbox runtime (0m:0s)
    
    TRUNCATE TABLE CodingElementGroupComponents
    TRUNCATE TABLE CodingElementGroups
    TRUNCATE TABLE GroupVerbatimEng
    TRUNCATE TABLE GroupVerbatimJpn
    TRUNCATE TABLE GroupVerbatimChn
    TRUNCATE TABLE GroupVerbatimKor
    TRUNCATE TABLE CodingPatterns
    TRUNCATE TABLE SupplementFieldKeys

    -- 3. Step three - clean ALL injected user data

    -- (RETAIN minimal set of required data)
    TRUNCATE TABLE LoginAttempts
    TRUNCATE TABLE UserObjectWorkflowRole

    DELETE FROM ObjectSegments
    WHERE SegmentId > 10
        OR (ObjectTypeId = 17 AND ObjectId > 2)

    DELETE FROM RoleActions
    WHERE SegmentId > 10

    DELETE FROM Roles
    WHERE SegmentId > 10

    DELETE FROM Configuration
    WHERE SegmentId > 10

    DELETE FROM LocalizedDataStrings
    WHERE SegmentId > 10

    DELETE FROM LocalizedDataStringPKs
    WHERE SegmentId > 10

    DELETE FROM UserObjectRole
    WHERE SegmentId > 10
		OR GrantToObjectId > 2

    DELETE FROM Segments
    WHERE SegmentId > 10

    DELETE FROM Users
    WHERE UserId > 2
    
    DELETE FROM UserPreferences
    WHERE SegmentId > 10
        OR UserId > 2

    TRUNCATE TABLE WorkflowRoleActions
    TRUNCATE TABLE UserObjectWorkflowRole
    DELETE FROM WorkflowRoles

    -- 4. Step four - clean ALL administrative data
       
    TRUNCATE TABLE SourceSystemTestTransmission
	DELETE FROM ApplicationAdmin
	DELETE FROM Application
    DELETE FROM SourceSystems
    DELETE FROM ApplicationType
    TRUNCATE TABLE ApplicationTrackableObject
    TRUNCATE TABLE AuthenticationServerTokens
    TRUNCATE TABLE MOTDAudits
    TRUNCATE TABLE OutServiceHeartBeats

    -- 5 : reset SQL identity counters
    SET IDENTITY_INSERT ApplicationType ON
        INSERT INTO ApplicationType (ApplicationTypeId, IMedidataId, Name, IsCoderAppType, Active, Deleted, Created, updated, IsAlwaysBypassTransmit)
        VALUES(1, @imedidataId_For_ApplicationType_Coder, 'Coder', 0, 1, 0, GETUTCDATE(), GETUTCDATE(), 0)
    SET IDENTITY_INSERT ApplicationType OFF

    SET IDENTITY_INSERT SourceSystems ON
        INSERT INTO SourceSystems(SourceSystemId, OID, SourceSystemVersion, ConnectionURI, DefaultLocale, 
	        Created, Updated, DefaultSegmentId, Username, Password, MarkingGroup)
        VALUES(1, @imedidataId_For_Application, '', @url_For_Application, 'eng', GETUTCDATE(), GETUTCDATE(), 1, NULL, NULL, '')
    SET IDENTITY_INSERT SourceSystems OFF
    
    SET IDENTITY_INSERT Application ON
        INSERT INTO Application (ApplicationId, ApiID, Name, BaseUrl, PublicKey, ApplicationTypeID, Active, Deleted, 
            Created, Updated, SourceSystemID, IsAlwaysBypassTransmit, UUID)
        VALUES(1, @imedidataId_For_Application, @name_For_Application, @url_For_Application, @publicKey_For_Application, 1, 1, 0, 
            GETUTCDATE(), GETUTCDATE(), 1, 0, @imedidataId_For_Application)
    SET IDENTITY_INSERT Application OFF

    SET IDENTITY_INSERT ApplicationAdmin ON
        INSERT INTO ApplicationAdmin (ApplicationAdminId, ApplicationID, IsCoderApp, Active, Deleted, IsCronEnabled, Created, Updated)
        VALUES(1, 1, 0, 1, 0, 0, GETUTCDATE(), GETUTCDATE())
    SET IDENTITY_INSERT ApplicationAdmin OFF

    DBCC CHECKIDENT ('[Application]'                    , RESEED, 2)
    DBCC CHECKIDENT ('[ApplicationAdmin]'               , RESEED, 2)
    DBCC CHECKIDENT ('[ApplicationTrackableObject]'     , RESEED, 2)
    DBCC CHECKIDENT ('[ApplicationType]'                , RESEED, 2)
    DBCC CHECKIDENT ('[BotElements]'                    , RESEED, 1)
    DBCC CHECKIDENT ('[CoderQueries]'                   , RESEED, 1)
    DBCC CHECKIDENT ('[CoderQueryHistory]'              , RESEED, 1)
    DBCC CHECKIDENT ('[CodingAssignment]'               , RESEED, 1)
    DBCC CHECKIDENT ('[CodingElementGroupComponents]'   , RESEED, 1)
    DBCC CHECKIDENT ('[CodingElementGroups]'            , RESEED, 1)
    DBCC CHECKIDENT ('[CodingElements]'                 , RESEED, 1)
    DBCC CHECKIDENT ('[CodingJobErrors]'                , RESEED, 1)
    DBCC CHECKIDENT ('[CodingPatterns]'                 , RESEED, 1)
    DBCC CHECKIDENT ('[CodingRejections]'               , RESEED, 1)
    DBCC CHECKIDENT ('[CodingRequestCsvData]'           , RESEED, 1)
    DBCC CHECKIDENT ('[CodingRequests]'                 , RESEED, 1)
    DBCC CHECKIDENT ('[CodingSourceTermSupplementals]'  , RESEED, 1)
    DBCC CHECKIDENT ('[Configuration]'                  , RESEED, 300)
    DBCC CHECKIDENT ('[CsvCodingJobErrorToken]'         , RESEED, 1)
    DBCC CHECKIDENT ('[DictionaryLicenceInformations]'  , RESEED, 1)
    DBCC CHECKIDENT ('[DictionarySegmentConfigurations]', RESEED, 1)
    DBCC CHECKIDENT ('[DoNotAutoCodeLists]'             , RESEED, 1)
    DBCC CHECKIDENT ('[DoNotAutoCodeTerms]'             , RESEED, 1)

    SET IDENTITY_INSERT GroupVerbatimChn ON
        INSERT INTO GroupVerbatimChn(GroupVerbatimId, VerbatimText, Created)
        VALUES(0, N'', GETUTCDATE())
    SET IDENTITY_INSERT GroupVerbatimChn OFF

    SET IDENTITY_INSERT GroupVerbatimEng ON
        INSERT INTO GroupVerbatimEng(GroupVerbatimId, VerbatimText, Created)
        VALUES(0, '', GETUTCDATE())
    SET IDENTITY_INSERT GroupVerbatimEng OFF

    SET IDENTITY_INSERT GroupVerbatimJpn ON
        INSERT INTO GroupVerbatimJpn(GroupVerbatimId, VerbatimText, Created)
        VALUES(0, N'', GETUTCDATE())
    SET IDENTITY_INSERT GroupVerbatimJpn OFF

    SET IDENTITY_INSERT GroupVerbatimKor ON
        INSERT INTO GroupVerbatimKor(GroupVerbatimId, VerbatimText, Created)
        VALUES(0, N'', GETUTCDATE())
    SET IDENTITY_INSERT GroupVerbatimKor OFF

    DBCC CHECKIDENT ('[GroupVerbatimChn]'              , RESEED, 1)
    DBCC CHECKIDENT ('[GroupVerbatimEng]'              , RESEED, 1)
    DBCC CHECKIDENT ('[GroupVerbatimJpn]'              , RESEED, 1)
    DBCC CHECKIDENT ('[GroupVerbatimKor]'              , RESEED, 1)
    DBCC CHECKIDENT ('[InvalidTaskQueue]'              , RESEED, 1)
    DBCC CHECKIDENT ('[LocalizedDataStringPKs]'        , RESEED, 5200)
    DBCC CHECKIDENT ('[LocalizedDataStrings]'          , RESEED, 13000)
    DBCC CHECKIDENT ('[LoginAttempts]'                 , RESEED, 1)
    DBCC CHECKIDENT ('[LongAsyncTaskHistory]'          , RESEED, 1)
    DBCC CHECKIDENT ('[LongAsyncTasks]'                , RESEED, 1)
    DBCC CHECKIDENT ('[MOTDAudits]'                    , RESEED, 1)
    DBCC CHECKIDENT ('[ObjectSegments]'                , RESEED, 20)
    DBCC CHECKIDENT ('[OutServiceHeartBeats]'          , RESEED, 1)
    DBCC CHECKIDENT ('[OutTransmissionLogs]'           , RESEED, 1)
    DBCC CHECKIDENT ('[OutTransmissions]'              , RESEED, 1)
    DBCC CHECKIDENT ('[ProjectDictionaryRegistrations]', RESEED, 1)
    DBCC CHECKIDENT ('[ProjectRegistrationTransms]'    , RESEED, 1)
    DBCC CHECKIDENT ('[QueryConfirmations]'            , RESEED, 1)
    DBCC CHECKIDENT ('[RoleActions]'                   , RESEED, 6000)
    DBCC CHECKIDENT ('[Roles]'                         , RESEED, 1000)
    DBCC CHECKIDENT ('[SegmentedGroupCodingPatterns]'  , RESEED, 1)
    DBCC CHECKIDENT ('[ServiceHeartBeats]'             , RESEED, 1)
    DBCC CHECKIDENT ('[SourceSystems]'                 , RESEED, 1)
    DBCC CHECKIDENT ('[SourceSystemTestTransmission]'  , RESEED, 1)
    DBCC CHECKIDENT ('[StudyDictionaryVersion]'        , RESEED, 1)
    DBCC CHECKIDENT ('[StudyDictionaryVersionHistory]' , RESEED, 1)
    DBCC CHECKIDENT ('[StudyMigrationTraces]'          , RESEED, 1)
    DBCC CHECKIDENT ('[StudyProjects]'                 , RESEED, 1)
    DBCC CHECKIDENT ('[SupplementFieldKeys]'           , RESEED, 1)
    DBCC CHECKIDENT ('[SynonymMigrationEntries]'       , RESEED, 1)
    DBCC CHECKIDENT ('[SynonymMigrationMngmt]'         , RESEED, 1)
    DBCC CHECKIDENT ('[SynonymMigrationSuggestions]'   , RESEED, 1)
    DBCC CHECKIDENT ('[SynonymUploadErrors]'           , RESEED, 1)
    DBCC CHECKIDENT ('[SynonymUploadRequests]'         , RESEED, 1)
    DBCC CHECKIDENT ('[TrackableObjects]'              , RESEED, 1)
    DBCC CHECKIDENT ('[TransmissionQueueItems]'        , RESEED, 1)
    DBCC CHECKIDENT ('[UserObjectRole]'                , RESEED, 1300)
    DBCC CHECKIDENT ('[UserObjectWorkflowRole]'        , RESEED, 1)
    DBCC CHECKIDENT ('[UserPreferences]'               , RESEED, 20)
    DBCC CHECKIDENT ('[Users]'                         , RESEED, 10)
    DBCC CHECKIDENT ('[UserSettings]'                  , RESEED, 1)
    DBCC CHECKIDENT ('[WorkflowRoleActions]'           , RESEED, 1)
    DBCC CHECKIDENT ('[WorkflowRoles]'                 , RESEED, 1)
    DBCC CHECKIDENT ('[WorkflowTaskData]'              , RESEED, 1)
    DBCC CHECKIDENT ('[WorkflowTaskHistory]'           , RESEED, 1)

    UPDATE Users
    SET IMedidataId = @imedidataId_For_CoderAdmin_User
    WHERE UserId = 2

    UPDATE Segments
    SET IMedidataId = @imedidataId_For_MedidataReserved1_Segment
    WHERE SegmentId = 1

END
