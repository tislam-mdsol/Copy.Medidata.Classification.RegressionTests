SET NOCOUNT ON 
go

CREATE TABLE #ProductionSupportNamedQuery
    (
     id INT IDENTITY
    ,Tag VARCHAR(50) NOT NULL
    ,Link NVARCHAR(200) NOT NULL
    ,Action VARCHAR(15) NOT NULL
    )

-- DO NOT WRITE ABOVE THIS LINE ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Rave and Coder integration related procedures
INSERT INTO #ProductionSupportNamedQuery ([Tag], Link, [Action]) VALUES('Terms submitted in Rave not showing up in Coder'  , 'spPSRaveToCoderIssue',                                    '-INSERT-')
INSERT INTO #ProductionSupportNamedQuery ([Tag], Link, [Action]) VALUES('Terms submitted in Coder not showing up in Rave'  , 'spPSCoderToRaveIssue',                                    '-INSERT-')
INSERT INTO #ProductionSupportNamedQuery ([Tag], Link, [Action]) VALUES('Get Coding Request ODM'                           ,'spGetCodingRequestODM',                                    '-INSERT-')
INSERT INTO #ProductionSupportNamedQuery ([Tag], Link, [Action]) VALUES('Project Dictionary Registrations'                 , 'spPSProjectRegistrations',                                '-INSERT-')
INSERT INTO #ProductionSupportNamedQuery ([Tag], Link, [Action]) VALUES('Transmissions by Study'                           , 'spPSRecentTransmissions',                                 '-INSERT-')
INSERT INTO #ProductionSupportNamedQuery ([Tag], Link, [Action]) VALUES('Transmission Queue Information by QueueItemId'    , 'spPSRaveTransmissionQueueInformationById',                '-INSERT-')
INSERT INTO #ProductionSupportNamedQuery ([Tag], Link, [Action]) VALUES('Study Coding Task Report By Dictionary'           , 'spPSExtendedDictionaryTaskReport',                        '-INSERT-')
INSERT INTO #ProductionSupportNamedQuery ([Tag], Link, [Action]) VALUES('Outbound MSG Queue - Health By Segment'           , 'spPsOutQueueHealthBySegment',                             '-INSERT-')
INSERT INTO #ProductionSupportNamedQuery ([Tag], Link, [Action]) VALUES('Outbound MSG Queue - Hourly Thruput For Two Weeks', 'spPsOutQueueThroughputForTwoWeeksByHour',                 '-INSERT-')
INSERT INTO #ProductionSupportNamedQuery ([Tag], Link, [Action]) VALUES('Outbound MSG Queue - Longest For 7 Days'          , 'spPsOutQueueLongestTransactions',                         '-INSERT-')
INSERT INTO #ProductionSupportNamedQuery ([Tag], Link, [Action]) VALUES('Outbound Queue - Prioritize Study'                , 'spOutTransmissionsPrioritizeStudy',                       '-INSERT-')
INSERT INTO #ProductionSupportNamedQuery ([Tag], Link, [Action]) VALUES('Segment Study Report'                             , 'spPsSegmentStudyReport',                                  '-INSERT-')
INSERT INTO #ProductionSupportNamedQuery ([Tag], Link, [Action]) VALUES('Study Migration Terms To Requeue'                 , 'spPSTermsRequiringRequeueDueToStudyMigrationSendFailure', '-INSERT-')
INSERT INTO #ProductionSupportNamedQuery ([Tag], Link, [Action]) VALUES('Requeued RWS Failure Reasons'                     , 'spPSTransmissionRWSFailureReasonBySegment',               '-INSERT-')
INSERT INTO #ProductionSupportNamedQuery ([Tag], Link, [Action]) VALUES('Study Migration - Fail Stuck Migration'           , 'spPSFailStuckStudyMigration',                             '-INSERT-')

-- Reporting related procedures
INSERT INTO #ProductionSupportNamedQuery ([Tag], Link, [Action]) VALUES('Coding Task Activity',                                     'spPSCodingTaskReport',                     '-INSERT-')
                                                                                                                                                                                 
-- Dictionary procedures																			                                								             
INSERT INTO #ProductionSupportNamedQuery ([Tag], Link, [Action]) VALUES('Medical Dictionary',                                       'spDictionaryRefLoadAll',                   '-UPDATE-')
INSERT INTO #ProductionSupportNamedQuery ([Tag], Link, [Action]) VALUES('Medical Dictionary Version',                               'spDictionaryVersionRefLoadAll',            '-UPDATE-')
INSERT INTO #ProductionSupportNamedQuery ([Tag], Link, [Action]) VALUES('Dictionary Upload Status',                                 'spDuGetDictionaryUploadStatus',            '-DELETE-')
                                                                                                                                                                                 
-- Study Synch procedures																						                    								             
INSERT INTO #ProductionSupportNamedQuery ([Tag], Link, [Action]) VALUES('Remove badly synched Study And Project',                   'spCoder_CMP_013',                          '-UPDATE-')


-- DO NOT WRITE BELOW THIS LINE ---------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS ( SELECT  Tag
            FROM    #ProductionSupportNamedQuery
            GROUP BY Tag
            HAVING  COUNT(*) > 1 ) 
    BEGIN
    -- will return duplicate entries
        SELECT  *
        FROM    #ProductionSupportNamedQuery
        WHERE   Tag IN ( SELECT Tag
                         FROM   #ProductionSupportNamedQuery
                         GROUP BY Tag
                         HAVING COUNT(*) > 1 )
        ORDER BY Tag

        RAISERROR ('The script contains duplicate entries (see the recordset). Remove duplicates and re-run the script. Script aborted', 16, 1)
    END
ELSE 
    BEGIN


        -- Insert into ProductionSupportNamedQueries those entries 
        -- from #ProductionSupportNamedQuery that are missing from ProductionSupportNamedQueries
        INSERT  INTO [ProductionSupportNamedQueries]
                ( 
                 [QueryName]
                ,[SPName]
                ,[Created]
                ,[Updated]
                )
                SELECT  tmp.Tag
                       ,tmp.Link
                       ,GETUTCDATE()
                       ,GETUTCDATE()
                FROM    #ProductionSupportNamedQuery tmp
                        LEFT JOIN ProductionSupportNamedQueries P ON tmp.Tag = P.QueryName
                WHERE   P.QueryName IS NULL
    
        -- Update those records in HelpContexts that exists in
        -- #HelpContext and are marked with with Action = '-UPDATE-'
        UPDATE  ProductionSupportNamedQueries
        SET     [SPName] = tmp.Link
               ,Updated = GETUTCDATE()
        FROM    #ProductionSupportNamedQuery tmp
                LEFT JOIN ProductionSupportNamedQueries P ON tmp.Tag = P.QueryName
        WHERE   P.QueryName IS NOT NULL
                AND UPPER(tmp.Action) IN ( '-INSERT-' , '-UPDATE-' )
    
        -- Delete those records in HelpContexts that exists in
        -- #HelpContext and are marked with Action = '-DELETE-'
        DELETE  ProductionSupportNamedQueries
        FROM    #ProductionSupportNamedQuery tmp
                LEFT JOIN ProductionSupportNamedQueries P ON tmp.Tag = P.QueryName
        WHERE   P.QueryName IS NOT NULL
                AND UPPER(tmp.Action) = '-DELETE-'
    END

DROP TABLE #ProductionSupportNamedQuery  