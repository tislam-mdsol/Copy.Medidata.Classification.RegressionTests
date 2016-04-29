/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/  

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymMigrationManagementLoadAll')
	DROP PROCEDURE dbo.spSynonymMigrationManagementLoadAll
GO
--Create PROCEDURE [dbo].[spSynonymMigrationManagementLoadAll]
--(
--	@SegmentID INT
--)
--AS

--	-- need to be able to read dirty
--	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
--	BEGIN TRANSACTION

--	DECLARE 
--		@SuggestionGenerationInProgress INT, 
--		@SynonymLoadingInProcess INT,
--		@MigrationComplete INT 

--	SELECT @SuggestionGenerationInProgress = SynonymMigrationStatus FROM SynonymMigrationStatusR WHERE OID = 'SYNMIGR_GENERATINGSUGGESTIONS'	
--	SELECT @SynonymLoadingInProcess = SynonymMigrationStatus FROM SynonymMigrationStatusR WHERE OID = 'SYNUPL_LOADINGINPROGRESS'
--	SELECT @MigrationComplete = SynonymMigrationStatus FROM SynonymMigrationStatusR WHERE OID = 'SYNMIGR_COMPLETE'


--	;WITH synCTE (SynonymMigrationMngmtID, NumDerivedMigrations)
--	AS (
--		SELECT FromSyn.SynonymMigrationMngmtID, COUNT(*)
--		FROM SynonymMigrationMngmt FromSyn
--			LEFT JOIN SynonymMigrationMngmt ToSyn
--				ON ToSyn.fromVersionOrdinal = FromSyn.toVersionOrdinal
--				AND FromSyn.SynonymMigrationStatusRID = @MigrationComplete
--				AND FromSyn.medicalDictionaryID = ToSyn.medicalDictionaryID
--				AND FromSyn.locale = ToSyn.locale
--				AND FromSyn.segmentId = ToSyn.segmentId
--				AND ToSyn.SynonymMigrationStatusRID IN (@SuggestionGenerationInProgress, @SynonymLoadingInProcess)
--		WHERE FromSyn.SegmentID = @SegmentID
--		GROUP BY FromSyn.SynonymMigrationMngmtID
--	)

--	SELECT S.*, CASE WHEN T.NumDerivedMigrations > 1 THEN 1 ELSE 0 END
--		 AS IsVersionInvolvedInMigration
--	FROM SynonymMigrationMngmt S
--		JOIN synCTE T
--			ON S.SynonymMigrationMngmtID = T.SynonymMigrationMngmtID
			
--	COMMIT

--GO	