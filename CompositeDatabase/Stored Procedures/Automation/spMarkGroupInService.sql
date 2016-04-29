/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// 
// This script is to fake a workflow service activity on a given group
// 
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spMarkGroupInService')
	DROP PROCEDURE spMarkGroupInService
GO

CREATE PROCEDURE dbo.spMarkGroupInService  
(  
	@SegmentOID  NVARCHAR(100),  
	@DictionaryOID  VARCHAR(100),
	@DictionaryLocale CHAR(3),
	@VersionOID VARCHAR(100),
	@SynonymListName NVARCHAR(100),
	@groupVerbatim NVARCHAR(450)
)  
AS  
BEGIN

	--production check
	 IF NOT EXISTS (
			SELECT NULL 
			FROM CoderAppConfiguration
			WHERE Active = 1 AND IsProduction = 0)
	BEGIN
		PRINT N'THIS IS A PRODUCTION ENVIRONMENT - Test Script cannot proceed!'
		RETURN 1
	END

	DECLARE @MedicalDictionaryID INT, @SegmentID INT, @StudyID INT, @VersionID INT, @SynonymMgmtID INT

	SELECT @MedicalDictionaryID = DictionaryRefID
	FROM Dictionaryref
	WHERE  OID = @DictionaryOID

	IF @MedicalDictionaryID IS NULL  
	BEGIN  
		PRINT N'Cannot find dictionary OID'  
		RETURN 1  
	END  

	SELECT @VersionID = DictionaryVersionRefID
	FROM DictionaryVersionRef
	WHERE OID = @VersionOID AND DictionaryRefID = @MedicalDictionaryID

	IF @VersionID IS NULL  
	BEGIN  
		PRINT N'Cannot find Version OID'  
		RETURN 1  
	END 

	SELECT @SegmentID = SegmentId
	FROM Segments
	WHERE OID = @SegmentOID

	IF @SegmentID IS NULL  
	BEGIN  
		PRINT N'Cannot find Segment'  
		RETURN 1  
	END 

	SELECT @SynonymMgmtID = SynonymMigrationMngmtID
	FROM SynonymMigrationMngmt
	WHERE SegmentID = @SegmentID
		AND MedicalDictionaryID = @MedicalDictionaryID
		AND Locale = @DictionaryLocale
		AND ListName = @SynonymListName

	IF @SynonymMgmtID IS NULL  
	BEGIN  
		PRINT N'Cannot find SynonymListName'  
		RETURN 1  
	END

	UPDATE CE
	SET CE.IsStillInService = 1
	FROM CodingElements CE
		JOIN CodingElementGroups CEG
			ON CEG.CodingElementGroupID = CE.CodingElementGroupID
			AND CE.IsStillInService = 0
		JOIN StudyDictionaryVersion SDV
			ON SDV.StudyDictionaryVersionID = CE.StudyDictionaryVersionId
			AND SDV.SynonymManagementID = @SynonymMgmtID
		CROSS APPLY
		(
			SELECT ISNULL(MAX(GroupVerbatimID), -1) AS GroupVerbatimID
			FROM GroupVerbatimEng GV
			WHERE GV.VerbatimText = @groupVerbatim
				AND GV.GroupVerbatimId = CEG.GroupVerbatimID
				AND @DictionaryLocale = 'eng'
		 ) AS GVE 
		CROSS APPLY
		(
			SELECT ISNULL(MAX(GroupVerbatimID), -1) AS GroupVerbatimID
			FROM GroupVerbatimJpn GV
			WHERE GV.VerbatimText = @groupVerbatim
				AND GV.GroupVerbatimId = CEG.GroupVerbatimID
				AND @DictionaryLocale = 'jpn'
		 ) AS GVJ
	WHERE (GVE.GroupVerbatimID > 0 AND @DictionaryLocale = 'eng') OR
		(GVJ.GroupVerbatimID > 0 AND @DictionaryLocale = 'jpn')

END