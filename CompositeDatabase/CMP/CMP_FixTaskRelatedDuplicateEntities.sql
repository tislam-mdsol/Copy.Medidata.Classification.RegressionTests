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
// Corrects n-plicate CodingAssignments.Active & CodingSuggestions
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_FixTaskRelatedDuplicates')
	DROP PROCEDURE spCoder_CMP_FixTaskRelatedDuplicates
GO

CREATE PROCEDURE dbo.spCoder_CMP_FixTaskRelatedDuplicates
AS
BEGIN

	IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CMP_AssignmentsDeactivated')
	BEGIN
		CREATE TABLE CMP_AssignmentsDeactivated
		(
			AssignmentID INT,
			Created DATETIME CONSTRAINT DF_CMP_AssignmentsDeactivated_Created DEFAULT (GETUTCDATE())
		)
	END

	IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CMP_SuggestionsDeleted')
	BEGIN
		CREATE TABLE CMP_SuggestionsDeleted
		(
			CodingElementID BIGINT,
			SegmentID INT,
			MedicalDictionaryTermID BIGINT,
			DictionaryVersionID INT,
			SuggestionReason VARCHAR(50),
			Created DATETIME CONSTRAINT DF_CMP_SuggestionsDeleted_Created DEFAULT (GETUTCDATE())
		)
	END

	-- 1. CodingAssignments - extra active (only allow the last Id to have it)
	;WITH xCA
	AS
	(
		SELECT MAX(CodingAssignmentID) AS MaxId, CodingElementID
		FROM CodingAssignment
		WHERE Active = 1
		GROUP BY CodingElementID
		HAVING COUNT(*) > 1
	)

	UPDATE CA
	SET CA.Active = 0
	OUTPUT inserted.CodingAssignmentID INTO CMP_AssignmentsDeactivated(AssignmentID)
	FROM CodingAssignment CA
		JOIN xCA
			ON xCA.CodingElementID = CA.CodingElementID
			AND CA.Active = 1
			AND xCA.MaxId <> CA.CodingAssignmentID			
			

	-- 2. CodingSuggestions - remove n-plicates (only allow earliest id to remain)
	BEGIN TRY
	BEGIN TRANSACTION
	
		;WITH xCS
		AS
		(
			SELECT MedicalDictionaryTermID, CodingElementID, MIN(CodingSuggestionID) AS MinId
			FROM CodingSuggestions CS
			GROUP BY MedicalDictionaryTermID, CodingElementID
			HAVING COUNT(*) > 1
		)
		
		
		INSERT INTO CMP_SuggestionsDeleted ( CodingElementID, SegmentID, MedicalDictionaryTermID, DictionaryVersionID, SuggestionReason)
		SELECT CS.CodingElementID, CS.SegmentID, CS.MedicalDictionaryTermID, CS.DictionaryVersionID, CS.SuggestionReason
		FROM xCS
			JOIN CodingSuggestions CS
				ON xCS.MedicalDictionaryTermID = CS.MedicalDictionaryTermID
				AND xCS.CodingElementID = CS.CodingElementID
				AND xCS.MinId <> CS.CodingSuggestionID	
		
		;WITH xCS
		AS
		(
			SELECT MedicalDictionaryTermID, CodingElementID, MIN(CodingSuggestionID) AS MinId
			FROM CodingSuggestions CS
			GROUP BY MedicalDictionaryTermID, CodingElementID
			HAVING COUNT(*) > 1
		)
			
		DELETE CS
		FROM xCS
			JOIN CodingSuggestions CS
				ON xCS.MedicalDictionaryTermID = CS.MedicalDictionaryTermID
				AND xCS.CodingElementID = CS.CodingElementID
				AND xCS.MinId <> CS.CodingSuggestionID

		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION

		DECLARE @errorString NVARCHAR(4000) = N'CMP ERROR: Transaction Error Message - ' + ERROR_MESSAGE()
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
	END CATCH	

END
