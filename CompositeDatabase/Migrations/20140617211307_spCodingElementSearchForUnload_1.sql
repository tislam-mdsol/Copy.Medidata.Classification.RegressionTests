/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Steve Myers smyers@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

--spCodingElementSearchForUnload 2, 'eng', 35, '', 'Rejected', 0, 20, 12

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementSearchForUnload')
	DROP PROCEDURE spCodingElementSearchForUnload
GO
CREATE PROCEDURE dbo.spCodingElementSearchForUnload
(
	@MedicalDictionaryID int,
	@UserLocale char(3), -- for use in dbo.fnlds()
	@DictLocale char(3),
	@StudyID bigint, -- TrackableObjects.ID
	@CodedState nvarchar(50), -- { Completed, CodedButNotCompleted, NotCoded, Rejected }
	@PageIndex int,
	@PageSize int, --value set in object layer
	@SegmentID int,
	@LastStreamingID INT,
	@SortColumnName VARCHAR(40),
	@QueryStatus TINYINT
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF ((ISNULL(@PageIndex, -1) <0 AND ISNULL (@LastStreamingID, -1) < 0 ) OR ISNULL(@PageSize,0) <= 0) 
	BEGIN
		select *, 0 as TotalRowCount from CodingElements where 1 = 0
		return
	END

	DECLARE @errorString NVARCHAR(400) 

	IF(@SortColumnName <> 'CodingElementId')
	BEGIN
		SET @errorString = N'Error. Sorting columns other than CodingElementId is not supported.'
		RAISERROR(@errorString, 16, 1)
		RETURN	 
	END

	DECLARE @startRowNumber int

	IF (@PageIndex >= 0)
		SET @startRowNumber = (@PageIndex * @PageSize) + 1
	ELSE
		SET @startRowNumber = 1
	
	
	;WITH searchQueryCTE (
		CodingElementId, 
		BatchOID, 
		StudyID, 
		VerbatimTerm,
		DictionaryVersionId, CodingPathVersionId,
		DictionaryLevelId, DictionaryLocale,
		WorkflowStateID,
		CodingPath, Code, Term,
		RowNumber
	) AS (
		SELECT E.CodingElementId, 
			 CRQ.BatchOID,
			 SDV.StudyID,
			 E.VerbatimTerm,
			 SDV.DictionaryVersionId,
			 AllAssignments.CodingPathVersionId,
			 E.DictionaryLevelId,
			 SDV.DictionaryLocale,
	 		 E.WorkflowStateID,
			 E.AssignedCodingPath,
			 E.AssignedTermCode,
			 E.AssignedTermText,
			 ROW_NUMBER() OVER(ORDER BY
				E.CodingElementId
			)
		FROM CodingElements E
			JOIN StudyDictionaryVersion SDV
				ON E.StudyDictionaryVersionId = SDV.StudyDictionaryVersionID
				AND SDV.StudyID = @StudyID
				AND SDV.MedicalDictionaryID = @MedicalDictionaryID
				AND E.SegmentId = @SegmentID
				AND SDV.DictionaryLocale = @DictLocale
			JOIN CodingRequests CRQ 
				ON CRQ.CodingRequestId = E.CodingRequestId
			-- Rejections
			LEFT JOIN CodingRejections CRJ 
				ON CRJ.CodingElementID = E.CodingElementId 
		    CROSS APPLY
		    (
		        SELECT ISNULL(MAX(SMM.DictionaryVersionId), -1) AS CodingPathVersionId
		        FROM SegmentedGroupCodingPatterns SGCP
					JOIN SynonymMigrationMngmt SMM
						ON SGCP.SynonymManagementID = SMM.SynonymMigrationMngmtID
						AND SGCP.SegmentedGroupCodingPatternID = E.AssignedSegmentedGroupCodingPatternId
		        WHERE E.AssignedSegmentedGroupCodingPatternId > 0
		    )AS AllAssignments
		WHERE
			( @CodedState = 'OpenQuery' 
			    And
			  ((CRJ.CodingRejectionID IS NOT NULL AND E.IsClosed = 1 AND E.IsInvalidTask= 1)
				OR
				E.QueryStatus = @QueryStatus )
			) 
			OR   
			@CodedState = -- determine the category based on workflow state
			CASE
				WHEN E.IsClosed = 1 AND E.IsInvalidTask =0
					AND CRJ.CodingRejectionID IS NULL THEN 'Completed'
				WHEN E.IsClosed = 0
					AND E.AssignedSegmentedGroupCodingPatternId > 0 THEN 'CodedButNotCompleted'
				WHEN E.IsClosed = 0
					AND E.AssignedSegmentedGroupCodingPatternId < 1 THEN 'NotCoded'
				ELSE NULL
			END
	)
	
	SELECT TOP(@PageSize)
		CodingElementId,
		T.ExternalObjectOID AS StudyOID, 
		VerbatimTerm,
		DictionaryVersionId,CodingPathVersionId,
		dbo.fnLocalString(DR.OID, @UserLocale) + ' ' + dbo.fnLocalString(DVR.OID, @UserLocale) + '(' + dbo.fnLocalString(XI.DictionaryLocale, @UserLocale) + ')' as Dictionary,
		dbo.fnLocalString(DLR.OID, @UserLocale) AS DictionaryLevelOID,
		WorkflowStateID AS CurrentWorkflowStateID,
		BatchOID,
		Code, Term,
		CodingPath,
		DictionaryLocale,
		DVR.Ordinal,
	    TotalRowCount
	FROM
	(
		SELECT 
			CodingElementId, StudyID, VerbatimTerm,
			DictionaryVersionId,CodingPathVersionId,DictionaryLevelId, 
			WorkflowStateID, BatchOID,
			Code, Term,
			CodingPath,
			DictionaryLocale,
			(SELECT COUNT(*) FROM searchQueryCTE) as TotalRowCount
		FROM searchQueryCTE
		WHERE 
		RowNumber >= @startRowNumber
		AND 
		CodingElementId > @LastStreamingID
	) AS XI
		join TrackableObjects T on T.TrackableObjectID = XI.StudyID
		join DictionaryLevelRef DLR on DLR.DictionaryLevelRefID = XI.DictionaryLevelId
		join DictionaryVersionRef DVR 
			ON DVR.DictionaryVersionRefID = XI.DictionaryVersionId
			AND DVR.DictionaryRefID = @MedicalDictionaryID
		join DictionaryRef DR on DR.DictionaryRefID = DVR.DictionaryRefID
		JOIN CoderLocaleAddlInfo CLAI
			ON CLAI.Locale = DictionaryLocale
		
END


GO  
