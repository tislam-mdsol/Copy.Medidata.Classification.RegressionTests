/** 
** Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Altin Vardhami avardhami@mdsol.com
**
**/

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spImpactAnalysisForSynonymMigration')
	DROP PROCEDURE dbo.spImpactAnalysisForSynonymMigration
GO

CREATE PROCEDURE dbo.spImpactAnalysisForSynonymMigration (  
	@medicalDictionaryOID VARCHAR(50), -- mandatory parameter
	@fromVersionOID VARCHAR(50) = NULL, -- will default to first version
	@toVersionOID VARCHAR(50) = NULL, -- will default to last version
	@locale CHAR(3) = 'eng',
	@levelOID VARCHAR(50) = NULL -- will default to last coding level
)  
AS  
BEGIN  

	DECLARE
		@fromVersionOrdinal INT,
		@toVersionOrdinal INT,
		@medicalDictionaryID INT,
		@localeID TINYINT

	DECLARE @supportPrimaryPath BIT, 
		@codingLevelId INT
	
	SELECT @supportPrimaryPath = SupportsPrimaryPath,
		@medicalDictionaryID = MedicalDictionaryID
	FROM MedicalDictionary
	WHERE OID = @medicalDictionaryOID

	IF (@medicalDictionaryID IS NULL)
	BEGIN
		RAISERROR( N'Could not find Dictionary', 1,16)
		RETURN
	END

	SELECT @toVersionOrdinal = MAX(Ordinal)
	FROM MedicalDictionaryVersion
	WHERE MedicalDictionaryID = @medicalDictionaryID
		AND OID = ISNULL(@toVersionOID, OID)

	IF (@toVersionOrdinal IS NULL)
	BEGIN
		RAISERROR( N'Could not find ToVersion', 1,16)
		RETURN
	END

	SELECT @fromVersionOrdinal = MIN(Ordinal)
	FROM MedicalDictionaryVersion
	WHERE MedicalDictionaryID = @medicalDictionaryID
		AND OID = ISNULL(@fromVersionOID, OID)

	IF (@fromVersionOrdinal IS NULL)
	BEGIN
		RAISERROR( N'Could not find FromVersion', 1,16)
		RETURN
	END

	SELECT @localeID = ID
	FROM CoderLocaleAddlInfo
	WHERE locale = @locale

	IF (@localeID IS NULL)
	BEGIN
		RAISERROR( N'Could not find Locale', 1,16)
		RETURN
	END

	SELECT @codingLevelId = MAX(DictionaryLevelId)
	FROM MedicalDictionaryLevel
	WHERE MedicalDictionaryId = @medicalDictionaryID
		AND CodingLevel = 1
		AND OID = ISNULL(@levelOID, OID)
	
	IF (@codingLevelId IS NULL)
	BEGIN
		RAISERROR( N'Could not find Coding Level', 1,16)
		RETURN
	END

	;WITH xCTE AS
	(
		SELECT
			NPP.AnyOldPath,
			dbo.fnGetSynonymNodePathChangeType(NPP.AnyOldPath, 
				T_Old.PrimaryPath, T_Next.TermId, T_Next.NodePath, T_Next.PrimaryPath, @medicalDictionaryID, @toVersionOrdinal, @fromVersionOrdinal, @supportPrimaryPath) AS CType
		FROM ImpactAnalysisVersionDifference IAVD
			JOIN MedicalDictionaryTerm T_Old
				ON T_Old.TermId = IAVD.OldTermID
				AND T_Old.MedicalDictionaryID = IAVD.MedicalDictionaryID
				AND @fromVersionOrdinal BETWEEN T_Old.FromVersionOrdinal AND T_Old.ToVersionOrdinal
				AND T_Old.DictionaryLevelId = @codingLevelId
			CROSS APPLY
			(
				SELECT TOP 1 AnyOldPath = SinglePath
				FROM dbo.fnGetAllPaths(T_Old.TermId, T_Old.Nodepath, T_Old.PrimaryPath, @fromVersionOrdinal)
				WHERE IsPrimaryPath = 0
			) AS NPP -- Non primary path
			JOIN MedicalDictionaryTerm T_Next
				ON T_Next.TermId = IAVD.FinalTermID
				AND T_Next.MedicalDictionaryID = T_Next.MedicalDictionaryID
				AND @toVersionOrdinal BETWEEN T_Next.FromVersionOrdinal AND T_Next.ToVersionOrdinal
				AND T_Next.DictionaryLevelId = @codingLevelId
		WHERE @fromVersionOrdinal = IAVD.FromVersionOrdinal
			AND @toVersionOrdinal = IAVD.ToVersionOrdinal
			AND IAVD.MedicalDictionaryID = @medicalDictionaryID
			AND IAVD.Locale = @localeID
			AND IAVD.ImpactAnalysisChangeTypeId = 4

			AND NPP.AnyOldPath IS NOT NULL
	)

	SELECT 'NonPrimaryPath', CType, COUNT(*) AS TotalCount
	FROM xCTE
	GROUP BY CType

	IF (@supportPrimaryPath = 1)
	BEGIN

		;WITH xCTE AS
		(
			SELECT
				dbo.fnGetSynonymNodePathChangeType(T_Old.PrimaryPath, 
					T_Old.PrimaryPath, T_Next.TermId, T_Next.NodePath, T_Next.PrimaryPath, @medicalDictionaryID, @toVersionOrdinal, @fromVersionOrdinal, @supportPrimaryPath) AS CType
			FROM ImpactAnalysisVersionDifference IAVD
				JOIN MedicalDictionaryTerm T_Old
					ON T_Old.TermId = IAVD.OldTermID
					AND T_Old.MedicalDictionaryID = IAVD.MedicalDictionaryID
					AND @fromVersionOrdinal BETWEEN T_Old.FromVersionOrdinal AND T_Old.ToVersionOrdinal
					AND T_Old.DictionaryLevelId = @codingLevelId
				JOIN MedicalDictionaryTerm T_Next
					ON T_Next.TermId = IAVD.FinalTermID
					AND T_Next.MedicalDictionaryID = T_Next.MedicalDictionaryID
					AND @toVersionOrdinal BETWEEN T_Next.FromVersionOrdinal AND T_Next.ToVersionOrdinal
					AND T_Next.DictionaryLevelId = @codingLevelId
			WHERE @fromVersionOrdinal = IAVD.FromVersionOrdinal
				AND @toVersionOrdinal = IAVD.ToVersionOrdinal
				AND IAVD.MedicalDictionaryID = @medicalDictionaryID
				AND IAVD.Locale = @localeID
				AND IAVD.ImpactAnalysisChangeTypeId = 4
		)

		SELECT 'PrimaryPath', CType, COUNT(*) AS TotalCount
		FROM xCTE
		GROUP BY CType

	END

	SELECT 'NonNodepathChanges', ImpactAnalysisChangeTypeId, COUNT(*)
	FROM ImpactAnalysisVersionDifference IAVD
	WHERE @fromVersionOrdinal = IAVD.FromVersionOrdinal
		AND @toVersionOrdinal = IAVD.ToVersionOrdinal
		AND IAVD.MedicalDictionaryID = @medicalDictionaryID
		AND IAVD.Locale = @localeID
		AND IAVD.ImpactAnalysisChangeTypeId <> 4
		AND EXISTS (SELECT NULL FROM MedicalDictionaryTerm
			WHERE TermID = IAVD.OldTermID
				AND DictionaryLevelId = @codingLevelId)
	GROUP BY ImpactAnalysisChangeTypeId

END  
GO  