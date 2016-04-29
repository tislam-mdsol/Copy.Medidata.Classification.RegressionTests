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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spProjectRegistrationTransmissionCreateByRegIds')
	DROP PROCEDURE dbo.spProjectRegistrationTransmissionCreateByRegIds
GO

CREATE PROCEDURE dbo.spProjectRegistrationTransmissionCreateByRegIds 
(
	@ProjectRegIds VARCHAR(MAX),
	@Delimeter CHAR(1)
)  
AS  
BEGIN  

	DECLARE @projectRegIdTable TABLE(ProjectRegId INT PRIMARY KEY)
	
	INSERT INTO @projectRegIdTable(ProjectRegId)
	SELECT Item FROM dbo.fnParseDelimitedString(@ProjectRegIds, @Delimeter)

	-- 1. verify data

	DECLARE @userID INT, @segmentID INT, @projectId INT
	
	SELECT TOP 1
		@userID = UserID,
		@segmentID = SegmentId,
		@projectId = StudyProjectId
	FROM ProjectDictionaryRegistrations PDR
		JOIN @projectRegIdTable PRIT
			ON PDR.ProjectDictionaryRegistrationID = PRIT.ProjectRegId

	-- do nothing if no data
	IF (@userID IS NULL OR @userID < 1)
	BEGIN
		SELECT * FROM ProjectRegistrationTransms
		WHERE ProjectRegistrationTransmissionID = -1
		RETURN
	END

	-- 2. create a new Projectregistrationtransmission
	DECLARE @ProjectRegistrationTransmissionID INT
	
	INSERT INTO ProjectRegistrationTransms (  
		UserID,
		StudyProjectId,
		TransmissionResponses,
		ApplicationIdsUpdatedInTransmission,
		ProjectRegistrationSucceeded,
		SegmentID
	) VALUES (  
		@userID,
		@projectId,
		'',
		'',
		0,
		@segmentID
	)  
	
	SET @ProjectRegistrationTransmissionID = SCOPE_IDENTITY()  	

	-- 3. update the ProjectDictionaryRegistrations
	UPDATE PDR
	SET PDR.ProjectRegistrationTransmissionID = @ProjectRegistrationTransmissionID
	FROM ProjectDictionaryRegistrations PDR
		JOIN @projectRegIdTable PRIT
			ON PDR.ProjectDictionaryRegistrationID = PRIT.ProjectRegId
	
	
	SELECT * FROM ProjectRegistrationTransms
	WHERE ProjectRegistrationTransmissionID = @ProjectRegistrationTransmissionID
	

END

GO
