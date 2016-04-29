/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2008, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Jalal Uddin juddin@mdsol.com
// required by automation
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementsCleanup')
	DROP PROCEDURE [dbo].[spCodingElementsCleanup]
GO
CREATE PROCEDURE [dbo].[spCodingElementsCleanup]
(
	@SegmentOID VARCHAR(50),
	@ResetSynonymState BIT,
	@ResetStudyRegistration BIT,
	@ResetStudies BIT,
	@ResetJobManagement BIT,
	@AgreementToRunInProduction VARCHAR(255) = ''
)
AS
BEGIN

 --production check
 IF EXISTS (
		SELECT NULL 
		FROM CoderAppConfiguration
		WHERE Active = 1 AND IsProduction = 1
				AND LTRIM(RTRIM(LOWER(@AgreementToRunInProduction))) <> 'allow run in production')
BEGIN
	PRINT N'THIS IS A PRODUCTION ENVIRONMENT - Test Script cannot proceed!'
	PRINT N'To Override add @AgreementToRunInProduction parameter to end with exact value:'
	PRINT N'''allow run in production'''
	RETURN
END

	DECLARE @SegmentID INT
	
	SELECT @SegmentID = SegmentID
	FROM Segments
	WHERE OID = @SegmentOID
	
	IF (@SegmentID IS NULL)
		RETURN
		
	-- STUDY REGISTRATION
	IF (@ResetSynonymState = 1 Or @ResetStudies = 1 OR @ResetStudyRegistration = 1)
	BEGIN
	
		IF(@ResetJobManagement = 1)
		BEGIN
			-- TODO: lengthy delete due to a non-maintained segmentid in LongAsyncTaskHistory
			DELETE FROM LongAsyncTaskHistory
			WHERE TaskID IN (SELECT TaskId FROM LongAsyncTasks WHERE SegmentId = @SegmentID)
	
			DELETE FROM LongAsyncTasks
			WHERE SegmentId = @SegmentID
		END
		
		DELETE FROM StudyMigrationTraces
		WHERE SegmentId = @SegmentID
		
		DELETE FROM BOTElements
		WHERE SegmentId = @SegmentID		
	
		PRINT 'StudyDictionaryVersionHistory'

		delete from StudyDictionaryVersionHistory
		WHERE StudyID IN (SELECT TrackableObjectID FROM TrackableObjects 
			WHERE SegmentID = @SegmentID)
		
		PRINT 'StudyMigrationBackup'
		
		delete from StudyMigrationBackup
		WHERE StudyDictionaryVersionID IN 
			(Select StudyDictionaryVersionId from StudyDictionaryVersion
			WHERE StudyID IN 
				(SELECT TrackableObjectID FROM TrackableObjects 
				WHERE SegmentID = @SegmentID)
			)
		
		PRINT 'StudyDictionaryVersion'
		
		delete from StudyDictionaryVersion
		WHERE StudyID IN (SELECT TrackableObjectID FROM TrackableObjects 
			WHERE SegmentID = @SegmentID)
			
		PRINT 'ProjectDictionaryRegistration'

		DELETE FROM ProjectDictionaryRegistrations
		WHERE SegmentID = @SegmentID

		-- TODO : eval whether it's an issue
		DELETE FROM ProjectRegistrationTransms
		WHERE SegmentID = @SegmentID		
			
	END
	
	--IF (@ResetStudyRegistration = 1)
	--BEGIN
	--	PRINT 'UPDATE COUNT IN TrackableObjects'

		UPDATE TrackableObjects
		SET TaskCounter = 0
		WHERE SegmentID = @SegmentID
		
	--END


	PRINT 'CodingSuggestions'

	delete FROM CodingSuggestions
	WHERE SegmentID = @SegmentID
	
	
	-- SYNONYMS
	
	-- 1. history
	DELETE FROM SynonymHistory
	WHERE SegmentID = @SegmentID
	
	-- have to clear in migration data as well
	-- 2. suggestions
	DELETE FROM SynonymMigrationSuggestions
	WHERE SynonymMigrationEntryID IN (SELECT SynonymMigrationEntryID FROM SynonymMigrationEntries
		WHERE SynonymMigrationMngmtID IN (SELECT SynonymMigrationMngmtID FROM SynonymMigrationMngmt
						WHERE SegmentID = @SegmentID))

	-- 3. entries
	DELETE FROM SynonymMigrationEntries
	WHERE SynonymMigrationMngmtID IN (SELECT SynonymMigrationMngmtID FROM SynonymMigrationMngmt
						WHERE SegmentID = @SegmentID)

	IF (@ResetSynonymState = 1)
	BEGIN
	
		PRINT 'Delete synonym decision'
		DELETE SynonymMigrationMngmt
		WHERE SegmentID = @SegmentID

	END
	
	PRINT 'SynonymLoadStaging'
	
	DELETE FROM SynonymLoadStaging 
	WHERE SynonymManagementID IN (SELECT SynonymManagementID FROM SegmentedGroupCodingPatterns 
								WHERE SegmentID = @SegmentID)
	
	-- added per autocode fix
	PRINT 'SegmentedGroupCodingPatterns'
		
	DELETE FROM SegmentedGroupCodingPatterns
	WHERE SegmentID = @SegmentID	
	
	PRINT 'CodingTransmissions'
		
	DELETE FROM CodingTransmissions
	WHERE CodingRequestID IN (SELECT CodingRequestID FROM CodingRequests 
		WHERE SegmentID = @SegmentID)

	--PRINT 'AckNackTransmissions'
		
	--DELETE FROM AckNackTransmissions
	--WHERE CodingElementID IN (SELECT CodingElementID FROM CodingElements 
	--	WHERE SegmentID = @SegmentID)
	
	PRINT 'CodingSourceTermReferences'
		
	DELETE FROM CodingSourceTermReferences
	WHERE CodingSourceTermID IN (SELECT CodingElementID FROM CodingElements
		WHERE SegmentID = @SegmentID)


	PRINT 'CodingSourceTermSupplementals'
	
	DELETE FROM CodingSourceTermSupplementals
	WHERE SegmentID = @SegmentID

	PRINT 'CodingSourceTermComponents'
	
	delete FROM CodingSourceTermComponents
	WHERE SegmentID = @SegmentID


	PRINT 'CodingRejections'
	
	delete FROM CodingRejections
	WHERE SegmentID = @SegmentID

	PRINT 'CoderQueryHistory'
	DELETE FROM CoderQueryHistory
	WHERE QueryId IN (SELECT QueryId FROM CoderQueries
	                  WHERE CodingElementId IN (SELECT CodingElementId FROM CodingElements 
											    WHERE SegmentID = @SegmentID))

	PRINT 'CoderQueries'
	DELETE FROM CoderQueries
	WHERE CodingElementId IN (SELECT CodingElementId FROM CodingElements 
		WHERE SegmentID = @SegmentID)

	-- added per autocode fix
	PRINT 'CodingElementGroupComponents'
	
	delete FROM CodingElementGroupComponents
	WHERE CodingElementGroupID IN (SELECT CodingElementGroupID FROM CodingElementGroups 
		WHERE SegmentID = @SegmentID)

	-- added per autocode fix
	PRINT 'CodingElementGroups'
		
	delete FROM CodingElementGroups
	WHERE SegmentID = @SegmentID
	
	-- STUDIES
	IF (@ResetStudies = 1)
	BEGIN
	
		PRINT 'ApplicationTrackableObject'
		
		DELETE FROM ApplicationTrackableObject
		WHERE TrackableObjectID IN (SELECT TrackableObjectID FROM TrackableObjects
			WHERE SegmentID = @SegmentID)
		
		PRINT 'TrackableObjects'	
		--update TrackableObjects set TaskCounter=0
		delete FROM TrackableObjects
		WHERE SegmentID = @SegmentID
	END


	PRINT 'WorkflowTaskHistory'	

	delete FROM WorkflowTaskHistory
	WHERE WorkflowTaskID IN (SELECT CodingElementID
		FROM CodingElements WHERE SegmentID = @SegmentID)

	PRINT 'WorkflowTaskData'
	
	delete FROM WorkflowTaskData
	WHERE WorkflowTaskID IN (SELECT CodingElementID FROM CodingElements
	WHERE SegmentID = @SegmentID)

	PRINT 'WorkflowActivityResult'
	
	delete FROM WorkflowActivityResult
	WHERE  SegmentID = @SegmentID

	-- clean-up the transmission queue items related to the deleted full coding decision/rejections/open query/cancel query/partial coding decision.
	PRINT 'TransmissionQueueItems'
	--;with xCTE as
	--(
	--   SELECT ObjectTypeID
	--   FROM ObjectTypeR
	--   -- hard coded
	--   WHERE ObjectTypeName between 2251 and 2255

	--        --s_ObjectTypeRegistration.Add("Medidata.Coder.WSUtilities.PartialCodingDecisionMessage", 2251);
 --        --   s_ObjectTypeRegistration.Add("Medidata.Coder.WSUtilities.OpenQueryMessage", 2252);
 --        --   s_ObjectTypeRegistration.Add("Medidata.Coder.WSUtilities.CancelQueryMessage", 2253);
 --        --   s_ObjectTypeRegistration.Add("Medidata.Coder.WSUtilities.CodingRejectionMessage", 2254);
 --        --   s_ObjectTypeRegistration.Add("Medidata.Coder.WSUtilities.FullCodingDecisionMessage", 2255);
	--	--('FullCodingDecisionMessage', 'CodingRejectionMessage', 'OpenQueryMessage', 'CancelQueryMessage','PartialCodingDecisionMessage')
	--)
	
	DELETE FROM TransmissionQueueItems
	WHERE TransmissionQueueItemID IN
		(SELECT TQ.TransmissionQueueItemID FROM TransmissionQueueItems TQ
			WHERE TQ.ObjectTypeID between 2251 and 2255
			AND TQ.SegmentID = @SegmentID
		)

	

	PRINT 'CodingAssignment'
	
	delete FROM CodingAssignment
	WHERE SegmentID = @SegmentID

	-- SEcurity
	IF (@ResetStudies = 1)
	BEGIN
	
		-- hard coded
		DECLARE @TrackableObjectTypeID INT = 2168
		
		PRINT 'UserObjectRole'

		DELETE FROM UserObjectRole
		WHERE SegmentID = @SegmentID
			AND GrantOnObjectTypeID = @TrackableObjectTypeID
			AND GrantOnObjectID > 0
		
		PRINT 'UserObjectWorkflowRole'
		
		DELETE FROM UserObjectWorkflowRole
		WHERE SegmentID = @SegmentID
			AND GrantOnObjectTypeID = @TrackableObjectTypeID
			AND GrantOnObjectID > 0

	END
	
	PRINT 'CodingRequestCsvData'

	DELETE FROM CodingRequestCsvData
	WHERE CodingRequestID IN (SELECT CodingRequestID FROM CodingRequests 
		WHERE SegmentID = @SegmentID)
	
	PRINT 'VolatileCodingRequestLineQueue'

	DELETE FROM VolatileCodingRequestLineQueue
	WHERE CodingRequestID IN (SELECT CodingRequestID FROM CodingRequests 
		WHERE SegmentID = @SegmentID)

    PRINT 'CsvCodingJobErrorToken'
	DELETE FROM CsvCodingJobErrorToken
	WHERE CodingJobErrorId IN (SELECT CodingJobErrorId FROM CodingJobErrors
	                           WHERE CodingRequestID IN (SELECT CodingRequestID FROM CodingRequests 
		                                                 WHERE SegmentID = @SegmentID)
		                      )

    PRINT 'CodingJobErrors'
	DELETE FROM CodingJobErrors
	WHERE CodingRequestID IN (SELECT CodingRequestID FROM CodingRequests 
		WHERE SegmentID = @SegmentID)	
	-- KEEP AT END
	-- Lots of FK relations
	
	PRINT 'CodingElements'
	delete FROM CodingElements
	WHERE CodingRequestID IN (SELECT CodingRequestID FROM CodingRequests 
		WHERE SegmentID = @SegmentID)

	PRINT 'CodingRequests'	
	
	delete FROM CodingRequests
	WHERE SegmentID = @SegmentID

	PRINT 'QueryConfirmations'

	delete FROM QueryConfirmations
	WHERE SegmentID = @SegmentID

	
end
go