 


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND 
			name = 'spMetrics')
	BEGIN
		DROP Procedure dbo.spMetrics
	END
GO	

CREATE procedure dbo.spMetrics
(
	@Segment		INT,
	@SourceSystemID	INT,
	@StartTime		DateTime,
	@EndTime		DateTime
) 
AS
BEGIN


DECLARE @Metrics TABLE(Metric NVARCHAR(MAX), [Count] BIGINT)


----------------------------------
--
-- Project Registration Metrics
--
----------------------------------

DECLARE @FilteredProjReg TABLE(
	[TransmissionResponses] [nvarchar](max) NULL,
	[ProjectRegistrationSucceeded] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[SegmentId] [int])

INSERT INTO @FilteredProjReg([TransmissionResponses],[ProjectRegistrationSucceeded],[Created],[SegmentId])
SELECT PRT.[TransmissionResponses]
      ,PRT.[ProjectRegistrationSucceeded]
      ,PRT.[Created]
      ,ISNULL(PRT.[SegmentId], 0)
  FROM [ProjectRegistrationTransms] as PRT
  WHERE @Segment IN (-1, PRT.SegmentId)
  AND PRT.Created BETWEEN @StartTime AND @EndTime
  

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.000.OutBound.ProjReg.Total', COUNT(*)
FROM @FilteredProjReg
Group By SegmentId
  

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.200.OutBound.ProjReg.Success', COUNT(*)
FROM @FilteredProjReg
WHERE ProjectRegistrationSucceeded = 1
Group By SegmentId

DELETE @FilteredProjReg
WHERE ProjectRegistrationSucceeded = 1

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.ProjReg.StudyNotExist', COUNT(*)
FROM @FilteredProjReg
WHERE TransmissionResponses LIKE '%ReasonCode="RWS00014"%'
Group By SegmentId

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.ProjReg.BadUrl_NotFound', COUNT(*)
FROM @FilteredProjReg
WHERE TransmissionResponses LIKE '%Failed to get security token; HTTP Error The remote server returned an error: (404) Not Found..%'
Group By SegmentId

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.500.OutBound.ProjReg.Unknown', COUNT(*)
FROM @FilteredProjReg
WHERE TransmissionResponses LIKE '%Message:\[\]%' ESCAPE '\'
Group By SegmentId

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.500.OutBound.ProjReg.SecurityToken_500Error', COUNT(*)
FROM @FilteredProjReg
WHERE TransmissionResponses LIKE '%; HTTP Error The remote server returned an error: (500) Internal Server Error.. HTTP Status InternalServerError\]%' ESCAPE '\'
Group By SegmentId

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.ProjReg.SecurityToken_NotFound', COUNT(*)
FROM @FilteredProjReg
WHERE TransmissionResponses LIKE '%; HTTP Error The remote server returned an error: (404) Not Found.. HTTP Status NotFound\]%' ESCAPE '\'
Group By SegmentId

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.401.OutBound.ProjReg.BadUrl_Unauthorized', COUNT(*)
FROM @FilteredProjReg
WHERE TransmissionResponses LIKE '%ErrorClientResponseMessage="Incorrect login and password combination."%'
Group By SegmentId

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.500.OutBound.ProjReg.Unknown_500Error', COUNT(*)
FROM @FilteredProjReg
WHERE NOT TransmissionResponses LIKE '%\[ (HTTP InternalServerError)\]%' ESCAPE '\'
Group By SegmentId

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.503.OutBound.ProjReg.Url_Unavailable', COUNT(*)
FROM @FilteredProjReg
WHERE TransmissionResponses LIKE '%HTTP Error The remote server returned an error: (503) Server Unavailable.. HTTP Status ServiceUnavailable\]%' ESCAPE '\'
Group By SegmentId

----------------------------------
--
-- OutTransmission
--
----------------------------------

DECLARE @FilteredOutQueue TABLE(
	[SegmentId] [int] Not NULL,
	[SourceSystemID] [int] NOT NULL,
	[TransmissionTypeID] [int] NOT NULL,
	[Acknowledged] [bit] NOT NULL,
	[TransmissionSuccess] [bit] NOT NULL,
	[TransmissionDate] [datetime] NULL,
	[HttpStatusCode] [int] NULL,
	[ResponseText] [nvarchar](max) NULL)

INSERT INTO @FilteredOutQueue(
       [SegmentId]
      ,[SourceSystemID]
      ,[TransmissionTypeID]
      ,[Acknowledged]
      ,[TransmissionSuccess]
      ,[TransmissionDate]
      ,[HttpStatusCode]
      ,[ResponseText])
SELECT 
       ISNULL(TQI.[SegmentId],0)
      ,OT.[SourceSystemID]
      ,OT.[TransmissionTypeID]
      ,OT.[Acknowledged]
      ,OT.[TransmissionSuccess]
      ,OT.[TransmissionDate]
      ,OT.[HttpStatusCode]
      ,OT.[ResponseText]
  FROM [OutTransmissions] as OT
  LEFT JOIN [TransmissionQueueItems] as TQI on OT.OutTransmissionID = TQI.OutTransmissionID
  where OT.TransmissionTypeID <> 2225  -- dont include project registration
  AND OT.TransmissionTypeID <> 2182 -- dont include MFS
  AND @Segment IN (-1, TQI.SegmentID) -- If filtered on segment to last try
  AND @SourceSystemID IN (-1, TQI.SourceSystemId)
  AND OT.Created BETWEEN @StartTime AND @EndTime

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.000.OutBound.Rejection.Total', COUNT(*)
FROM @FilteredOutQueue
WHERE TransmissionTypeID = 2185
Group By SegmentId


SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.000.OutBound.Assignment.Total', COUNT(*)
FROM @FilteredOutQueue
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH SuccessCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE [TransmissionSuccess] = 1
OR HttpStatusCode = 200)

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.200.OutBound.Rejection.Success', COUNT(*)
FROM SuccessCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.200.OutBound.Assignment.Success', COUNT(*)
FROM SuccessCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId


DELETE @FilteredOutQueue
WHERE [TransmissionSuccess] = 1
OR HttpStatusCode = 200

;WITH BadUrl_NotFoundCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%Failed to get security token; HTTP Error The remote server returned an error: (404) Not Found..%')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.Rejection.BadUrl_NotFound', COUNT(*)
FROM BadUrl_NotFoundCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.Assignment.BadUrl_NotFound', COUNT(*)
FROM BadUrl_NotFoundCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH StudyNotFoundCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%ReasonCode="RWS00014"%')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.Rejection.StudyNotFound', COUNT(*)
FROM StudyNotFoundCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.Assignment.StudyNotFound', COUNT(*)
FROM StudyNotFoundCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH SubjectNotActiveCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%ReasonCode="RWS00019"%')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.400.OutBound.Rejection.SubjectNotActive', COUNT(*)
FROM SubjectNotActiveCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.400.OutBound.Assignment.SubjectNotActive', COUNT(*)
FROM SubjectNotActiveCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH MultipleSubjectCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%ReasonCode="RWS00021"%')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.409.OutBound.Rejection.MultipleSubject', COUNT(*)
FROM MultipleSubjectCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.409.OutBound.Assignment.MultipleSubject', COUNT(*)
FROM MultipleSubjectCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH ContextChangeCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%ReasonCode="RWS00100"%')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.409.OutBound.Rejection.ContextChange', COUNT(*)
FROM ContextChangeCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.409.OutBound.Assignment.ContextChange', COUNT(*)
FROM ContextChangeCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH RecordLockedCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%ReasonCode="RWS00040"%')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.409.OutBound.Rejection.RecordLocked', COUNT(*)
FROM RecordLockedCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.409.OutBound.Assignment.RecordLocked', COUNT(*)
FROM RecordLockedCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH FormLockedCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%ReasonCode="RWS00036"%')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.409.OutBound.Rejection.FormLocked', COUNT(*)
FROM FormLockedCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.409.OutBound.Assignment.FormLocked', COUNT(*)
FROM FormLockedCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH SubjectNotFoundCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%ReasonCode="RWS00023"%')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.Rejection.SubjectNotFound', COUNT(*)
FROM SubjectNotFoundCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.Assignment.SubjectNotFound', COUNT(*)
FROM SubjectNotFoundCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH SecurityToken_NotFoundCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%; HTTP Error The remote server returned an error: (404) Not Found.. HTTP Status NotFound')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.Rejection.SecurityToken_NotFound', COUNT(*)
FROM SecurityToken_NotFoundCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.Assignment.SecurityToken_NotFound', COUNT(*)
FROM SecurityToken_NotFoundCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH FieldFrozenCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%ReasonCode="RWS00048"%')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.409.OutBound.Rejection.FieldFrozen', COUNT(*)
FROM FieldFrozenCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.409.OutBound.Assignment.FieldFrozen', COUNT(*)
FROM FieldFrozenCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH DataNotInDictionaryCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%ReasonCode="RWS00047"%')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.409.OutBound.Rejection.DataNotInDictionary', COUNT(*)
FROM DataNotInDictionaryCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.409.OutBound.Assignment.DataNotInDictionary', COUNT(*)
FROM DataNotInDictionaryCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH BadUrl_UnableToConnectCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%; HTTP Error Unable to connect to the remote server. HTTP Status ')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.Rejection.BadUrl_UnableToConnect', COUNT(*)
FROM BadUrl_UnableToConnectCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.Assignment.BadUrl_UnableToConnect', COUNT(*)
FROM BadUrl_UnableToConnectCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH BadUrl_DNSNotResovledCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%; HTTP Error The remote name could not be resolved: ''%')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.Rejection.BadUrl_DNSNotResovled', COUNT(*)
FROM BadUrl_DNSNotResovledCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.Assignment.BadUrl_DNSNotResovled', COUNT(*)
FROM BadUrl_DNSNotResovledCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH UserNotAuthorizedCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%ReasonCode="RWS00097"%')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.401.OutBound.Rejection.UserNotAuthorizedCTE', COUNT(*)
FROM UserNotAuthorizedCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.401.OutBound.Assignment.UserNotAuthorizedCTE', COUNT(*)
FROM UserNotAuthorizedCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH SecurityToken_500ErrorCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%; HTTP Error The remote server returned an error: (500) Internal Server Error.. HTTP Status InternalServerError')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.500.OutBound.Rejection.SecurityToken_500Error', COUNT(*)
FROM SecurityToken_500ErrorCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.500.OutBound.Assignment.SecurityToken_500Error', COUNT(*)
FROM SecurityToken_500ErrorCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH RecordNotFoundCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%ReasonCode="RWS00037"%')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.Rejection.RecordNotFound', COUNT(*)
FROM RecordNotFoundCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.Assignment.RecordNotFound', COUNT(*)
FROM RecordNotFoundCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH InternalRaveWebServiceUnavailableCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%ErrorClientResponseMessage="Internal Error - Web Service currently unavailable.%')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.503.OutBound.Rejection.InternalRaveWebServiceUnavailable', COUNT(*)
FROM InternalRaveWebServiceUnavailableCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.503.OutBound.Assignment.InternalRaveWebServiceUnavailable', COUNT(*)
FROM InternalRaveWebServiceUnavailableCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH SiteNotFoundCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%ReasonCode="RWS00017"%')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.Rejection.SiteNotFound', COUNT(*)
FROM SiteNotFoundCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.Assignment.SiteNotFound', COUNT(*)
FROM SiteNotFoundCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH CodingDictionaryNotFoundCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%ReasonCode="RWS00098"%')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.Rejection.CodingDictionaryNotFound', COUNT(*)
FROM CodingDictionaryNotFoundCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.Assignment.CodingDictionaryNotFound', COUNT(*)
FROM CodingDictionaryNotFoundCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH DynamicSearchUpdateNotSupportedCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%ReasonCode="RWS00095"%')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.400.OutBound.Rejection.DynamicSearchUpdateNotSupported', COUNT(*)
FROM DynamicSearchUpdateNotSupportedCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.400.OutBound.Assignment.DynamicSearchUpdateNotSupported', COUNT(*)
FROM DynamicSearchUpdateNotSupportedCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH FieldLockedCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%ReasonCode="RWS00044"%')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.409.OutBound.Rejection.FieldLocked', COUNT(*)
FROM FieldLockedCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.409.OutBound.Assignment.FieldLocked', COUNT(*)
FROM FieldLockedCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH TimedOutCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE 'The operation has timed out')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.408.OutBound.Rejection.Request.TimedOut', COUNT(*)
FROM TimedOutCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.408.OutBound.Assignment.Request.TimedOut', COUNT(*)
FROM TimedOutCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH DerivedFieldUpdatedNotSupportedCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%ReasonCode="RWS00049"%')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.400.OutBound.Rejection.DerivedFieldUpdatedNotSupported', COUNT(*)
FROM DerivedFieldUpdatedNotSupportedCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.400.OutBound.Assignment.DerivedFieldUpdatedNotSupported', COUNT(*)
FROM DerivedFieldUpdatedNotSupportedCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH SecurityToken_TimedOutCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%; HTTP Error The operation has timed out. HTTP Status ')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.408.OutBound.Rejection.SecurityToken.TimedOut', COUNT(*)
FROM SecurityToken_TimedOutCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.408.OutBound.Assignment.SecurityToken.TimedOut', COUNT(*)
FROM SecurityToken_TimedOutCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH SecurityToken_NotReturnedCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE 'No security token received in response header from Server. HTTP Status NotFound. URL %')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.417.OutBound.Rejection.SecurityToken_NotReturned', COUNT(*)
FROM SecurityToken_NotReturnedCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.417.OutBound.Assignment.SecurityToken_NotReturned', COUNT(*)
FROM SecurityToken_NotReturnedCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH FormNotFoundCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%ReasonCode="RWS00033"%')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.Rejection.FormNotFound', COUNT(*)
FROM FormNotFoundCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.404.OutBound.Assignment.FormNotFound', COUNT(*)
FROM FormNotFoundCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH Url_UnavailableCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE ResponseText LIKE '%; HTTP Error The remote server returned an error: (503) Server Unavailable.. HTTP Status ServiceUnavailable')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.503.OutBound.Rejection.Url_Unavailable', COUNT(*)
FROM Url_UnavailableCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.503.OutBound.Assignment.Url_Unavailable', COUNT(*)
FROM Url_UnavailableCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId

;WITH Five00ErrorCTE AS (
SELECT
 SegmentId
,TransmissionTypeID
FROM @FilteredOutQueue
WHERE HttpStatusCode = 500 AND ResponseText = '')

INSERT INTO @Metrics(Metric,[Count])
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.500.OutBound.Rejection.500Error', COUNT(*)
FROM Five00ErrorCTE
WHERE TransmissionTypeID = 2185
Group By SegmentId
UNION
SELECT 'Coder.Segment' + CAST(SegmentId as NVARCHAR(24)) + '.Rave.500.OutBound.Assignment.500Error', COUNT(*)
FROM Five00ErrorCTE
WHERE TransmissionTypeID = 2075
Group By SegmentId


----------------------------------
--
-- Output Metrics
--
----------------------------------

SELECT * FROM @Metrics
END
GO