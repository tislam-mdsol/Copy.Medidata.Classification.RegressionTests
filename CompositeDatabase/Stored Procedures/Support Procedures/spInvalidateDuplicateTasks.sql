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
// Invalidates tasks that have been identified as duplicates by the duplicate detection script
// ------------------------------------------------------------------------------------------------------*/

-- EXEC spInvalidateDuplicateTasks 'MedidataReserved1'

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spInvalidateDuplicateTasks')
	DROP PROCEDURE spInvalidateDuplicateTasks
GO
CREATE PROCEDURE dbo.spInvalidateDuplicateTasks
(
	-- Requirement 1 - Scoped in Segment
	@SegmentName NVARCHAR(255),

	-- Requirement 2 - Optionally scoped in time interval
	@StartDatetime DATETIME = NULL, -- unbound
	@EndDateTime DATETIME = NULL, -- unbound
	
	-- Requirement 3 - Optionally scoped in Prod Only or all
	@ProdOnlyStudies BIT = 1,
	
	-- Requirement 4 - Optionally scoped in Uncoded Workflow States
	@UnCodedStatesOnly BIT = 1,

	-- Requirement 5 - Optionally scoped in Never Reclassified category
	-- NOTE : unknown feature longevity (more so than other features)
	@NeverReclassified BIT = 1
)
AS
BEGIN
	
	SET NOCOUNT ON

	-- verify params	
	DECLARE @SegmentId INT

	SELECT @SegmentId = SegmentId
	FROM Segments
	WHERE SegmentName = @SegmentName

	IF (@SegmentId IS NULL)
	BEGIN
		RAISERROR(N'ERROR: No such Segment!', 16, 1)
		RETURN 0
	END

	-- See WorkflowSystemActionR.Where(ActionName == 'ReClassify')
	DECLARE @ReclassifyAction INT = 16

	DECLARE @sdvTable TABLE(Id INT)

	INSERT INTO @sdvTable (Id)
	SELECT StudyDictionaryVersionID
	FROM StudyDictionaryVersion SDV
		JOIN TrackableObjects T
			ON T.TrackableObjectID = SDV.StudyID
	WHERE SDV.SegmentID = @SegmentId
		AND (T.IsTestStudy = 0 OR @ProdOnlyStudies = 0)

	-- Requirement 6 - Correlate tasks with source data - prerequisite to duplicate identification
	EXEC spPerformSourceCorrelation @SegmentName

	DECLARE @startedTime DATETIME = GETUTCDATE()

	IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'InvalidatedTasks')
	BEGIN
		CREATE TABLE InvalidatedTasks(
			CodingElementId INT NOT NULL,
			Created DATETIME NOT NULL CONSTRAINT DF_InvalidatedTasks_Created DEFAULT (GETUTCDATE())
		)
	END

	-- Requirement 7 - Invalidate all the [safe] duplicates
	UPDATE CE
	SET CE.IsInvalidTask = 1,
		CE.IsClosed = 1,
		CE.Updated = GETUTCDATE(),
		-- NOTE: added for safety in case Workflow is working through these
		CE.CacheVersion = CE.CacheVersion + 10
	OUTPUT inserted.CodingElementId INTO InvalidatedTasks(CodingElementId)
	FROM CodingElementSourceProperties CESP
		JOIN CodingRequests CR
			ON CESP.CodingRequestId = CR.CodingRequestId
			AND CR.SegmentId = @SegmentId
			AND CESP.IsChainTruncated = 0
			-- duplicate with a later datapoint representation already present
			AND CESP.NextCodingElementId > 0
		JOIN CodingElements CE
			ON CE.CodingElementId = CESP.CodingElementId
			AND CE.IsInvalidTask = 0
			-- time interval constraint
			AND CE.Created BETWEEN ISNULL(@StartDatetime, CE.Created) AND ISNULL(@EndDateTime, CE.Created)
			-- coded constraint
			AND (CE.AssignedSegmentedGroupCodingPatternId = -1 OR @UnCodedStatesOnly = 0)
			-- prod constraint
			AND CE.StudyDictionaryVersionID IN (SELECT Id FROM @sdvTable)

			-- Never Reclassified category
			-- NOTE : unknown feature longevity (more so than other features)
			AND (@NeverReclassified = 0 OR
				NOT EXISTS (SELECT NULL FROM WorkflowTaskHistory WTH
					WHERE WTH.WorkflowTaskID = CE.CodingElementId
						AND WTH.WorkflowSystemActionID = @ReclassifyAction
					)
				)

	-- Define the select report criteria here
	EXEC spInvalidatedDuplicateTasksReport @startedTime

END
GO