/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spStudyRegistrationTransmissionCreateByRegIds')
	DROP PROCEDURE spStudyRegistrationTransmissionCreateByRegIds
GO

CREATE PROCEDURE dbo.spStudyRegistrationTransmissionCreateByRegIds 
(
	@StudyRegIds VARCHAR(MAX),
	@Delimeter CHAR(1)
)  
AS  
BEGIN  

	DECLARE @studyRegIdTable TABLE(StudyRegId INT PRIMARY KEY)
	
	INSERT INTO @studyRegIdTable(StudyRegId)
	SELECT Item FROM dbo.fnParseDelimitedString(@StudyRegIds, @Delimeter)

	-- 1. verify data

	DECLARE @userID INT, @segmentID INT, @trackableObjectId INT
	
	SELECT TOP 1
		@userID = UserID,
		@segmentID = SegmentId,
		@trackableObjectId = TrackableObjectId
	FROM StudyDictionaryRegistrations SDR
		JOIN @studyRegIdTable SRIT
			ON SDR.StudyDictionaryRegistrationID = SRIT.StudyRegId

	-- do nothing if no data
	IF (@userID IS NULL OR @userID < 1)
	BEGIN
		SELECT * FROM StudyRegistrationTransmissions
		WHERE StudyRegistrationTransmissionID = -1
		RETURN
	END

	-- 2. create a new studyregistrationtransmission
	DECLARE @StudyRegistrationTransmissionID INT
	
	INSERT INTO StudyRegistrationTransmissions (  
		UserID,
		TrackableObjectID,
		TransmissionResponses,
		StudyRegistrationSucceeded,
		SegmentID
	) VALUES (  
		@userID,
		@trackableObjectID,
		'',
		0,
		@segmentID
	)  
	
	SET @StudyRegistrationTransmissionID = SCOPE_IDENTITY()  	

	-- 3. update the StudyDictionaryRegistrations
	UPDATE SDR
	SET SDR.StudyRegistrationTransmissionID = @StudyRegistrationTransmissionID
	FROM StudyDictionaryRegistrations SDR
		JOIN @studyRegIdTable SRIT
			ON SDR.StudyDictionaryRegistrationID = SRIT.StudyRegId
	
	
	SELECT * FROM StudyRegistrationTransmissions
	WHERE StudyRegistrationTransmissionID = @StudyRegistrationTransmissionID
	

END

GO
  