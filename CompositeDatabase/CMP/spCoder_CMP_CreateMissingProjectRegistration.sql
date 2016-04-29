/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2014, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Bonnie Pan bpan@mdsol.com
//
// Fix for missing project registrations due to study names not following Coder Convention.
// This CMP is to wire studies not registered to the correct parent study project
// and create corresponding sdvs. 
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_CreateMissingProjectRegistration')
	DROP PROCEDURE dbo.spCoder_CMP_CreateMissingProjectRegistration
GO

CREATE PROCEDURE dbo.spCoder_CMP_CreateMissingProjectRegistration
(
	@StudyName NVARCHAR(450),
	@SegmentName NVARCHAR(450),
	@DestinationProjectName NVARCHAR(450)
)
AS
BEGIN

	DECLARE @StudyId INT, @CurrentAssociateStudyProjectId INT, @StudyCount INT, @errorString NVARCHAR(MAX),@successString NVARCHAR(MAX)
	DECLARE @SegmentId INT, @NewStudyProjectId INT

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

	SELECT @StudyId = TrackableObjectID, 
		   @CurrentAssociateStudyProjectId = StudyProjectId
	FROM TrackableObjects 
	WHERE ExternalObjectName=@StudyName
	      AND @SegmentId=SegmentId

	IF (@StudyId IS NULL)
	BEGIN
	    SET @errorString = N'ERROR: No such study found!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END
	
	--Make sure the study that is going to update not registered yet
	IF EXISTS( SELECT NULL FROM dbo.StudyDictionaryVersion SDV
			   WHERE StudyID=@StudyId)
    BEGIN
		SELECT DR.OID as DictionaryName, SDV.DictionaryLocale, DVR.OID as DictionaryVersion 
		FROM StudyDictionaryVersion SDV
		JOIN DictionaryRef DR ON SDV.MedicalDictionaryID = DR.DictionaryRefID
		JOIN DictionaryVersionRef DVR ON SDV.DictionaryVersionId = DVR.DictionaryVersionRefID
		WHERE StudyID = @StudyId

	    SET @errorString = N'Info: Study already registered for some dictionary version locale combinations. Please go to Project Registration page to register.'
		PRINT @errorString
		RETURN 1
	END

	SELECT @NewStudyProjectId = StudyProjectId
	FROM dbo.StudyProjects
	WHERE ProjectName = @DestinationProjectName
	    AND SegmentID = @SegmentId
	
	IF (@NewStudyProjectId IS NULL)
	BEGIN
	    SET @errorString = N'ERROR: No such study project found!' + @DestinationProjectName
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	IF (@CurrentAssociateStudyProjectId <> @NewStudyProjectId )
	BEGIN
		-- 1) Update studies to the correct study project 
		UPDATE dbo.TrackableObjects
		SET StudyProjectId = @NewStudyProjectId
		WHERE TrackableObjectID = @StudyId

		-- 2) Check if the old Project is deletable
		SELECT @StudyCount = count(*) 
		FROM TrackableObjects 
		WHERE StudyProjectId = @CurrentAssociateStudyProjectId
	
		-- 3) Project not deletable if there are other studies that need it.
		IF (@StudyCount > 0)
			BEGIN
				SET @errorString = N'Cannot delete project because there are other studies that needs it'
				PRINT @errorString
			END
			ELSE
			BEGIN
				DELETE dbo.StudyProjects
				WHERE StudyProjectId = @CurrentAssociateStudyProjectId
			END
    END

	--4) make sure that the given study project is registered
	IF EXISTS(  SELECT ProjectDictionaryRegistrationID
				FROM ProjectDictionaryRegistrations PR
				WHERE StudyProjectId = @NewStudyProjectId
	 				AND EXISTS (SELECT NULL FROM ProjectRegistrationTransms PT
								WHERE PR.ProjectRegistrationTransmissionID = PT.ProjectRegistrationTransmissionID
									  AND PT.ProjectRegistrationSucceeded = 1)
		    )
	BEGIN
		--5)Create corresponding sdv for the given study
		DECLARE @UtcDate DateTime  
		SET @UtcDate = GetUtcDate() 
		 
		;WITH SuccessProjectRegistrationsForNewStudyProject
		AS
		(
		SELECT ProjectDictionaryRegistrationID,DictionaryID, DictionaryVersionId, DictionaryLocale,SynonymManagementID,
			SegmentId,
			ROW_NUMBER() OVER (PARTITION BY DictionaryID ORDER BY Created DESC) AS rownum
		FROM ProjectDictionaryRegistrations PR
		WHERE StudyProjectId = @NewStudyProjectId
			  AND EXISTS (SELECT NULL FROM ProjectRegistrationTransms PT
				          WHERE PR.ProjectRegistrationTransmissionID = PT.ProjectRegistrationTransmissionID
					      AND PT.ProjectRegistrationSucceeded = 1)
		) 
		INSERT INTO dbo.StudyDictionaryVersion
				( StudyID ,
				  KeepCurrentVersion ,
				  MedicalDictionaryID ,
				  SegmentID ,
				  Created ,
				  Updated ,
				  NumberOfMigrations ,
				  StudyLock ,
				  DictionaryLocale ,
				  SynonymManagementID ,
				  DictionaryVersionId ,
				  InitialDictionaryVersionId ,
				  CacheVersion
				)
		SELECT @StudyId,
			   0,
			   DictionaryID,
			   SegmentId,
			   @UtcDate,
			   @UtcDate,
			   0,
			   1,
			   DictionaryLocale,
			   SynonymManagementID,
			   DictionaryVersionId,
			   DictionaryVersionId,
			   0
		FROM SuccessProjectRegistrationsForNewStudyProject 
		WHERE rownum = 1 
	END
	ELSE
	BEGIN
	    SET @errorString = N'No Project Registrations have been performed. Please go to project registration page to register for Project '+@DestinationProjectName 
		PRINT @errorString
		RETURN 1
	END
	
	 --5) Verify results
	 DECLARE @CreatedCount INT
	 SELECT @CreatedCount = COUNT(*)
	 FROM dbo.StudyDictionaryVersion
	 WHERE StudyID = @StudyId
	 
	 SET @successString = N'Success! '+CONVERT(VARCHAR,@CreatedCount) +' entries created for study '+@StudyName
	 PRINT @successString

END