IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementGetNextTaskToCodeWithFilterSort')
	BEGIN
		DROP Procedure dbo.spCodingElementGetNextTaskToCodeWithFilterSort
	END
GO	

/* 1/15/2013 - CONNOR ROSS cross@mdsol.com
//
// TECH-DEBT: Study Lock number is not being passed in for study migration enum
// TECH-DEBT: UDT is not being used for @studyDictionaryIds
//
// NOTE: If you update this file you must review:
//			1. spCodingElementGetFilterValuesGroup.sql
//			2. spCodingElementGetNextTaskToCodeWithFilterSort.sql
//			3. spCodingElementLoadTaskFilters.sql
//			4. spCodingElementSearchForVCRWithFilterGroup.sql
//			5. spCodingElementSearchByFilterSecuredAndPagedWithFilterAndGroup.sql
*/

CREATE procedure [dbo].spCodingElementGetNextTaskToCodeWithFilterSort
(
	@userID bigint,					 
	@TrackableObjectId bigint = 0,	 -- 0=All TrackableObjects, >0=with specific TrackableObjectId, -->> -1=Old TrackableObjects, 
	@SourceSystemId bigint = 0,
	@TimeElapsed int = 0,			 -- 0=All Dates
	@QueryStatus int = -1,			-- -1=All Statuses
	@SynonymListId INT = 0,			-- 0=All Lists, >0=specific list
	@Priority INT = -1,				 -- -1=All Priorities, >-1=specific priority
	@SearchForText nvarchar(200),	 -- search for text based on search for option selected
	@CodingElementID bigint,		 
	@SortExpression VARCHAR(100), 
	@SortOrder BIT,					 -- 1=ASC 2=DESC
	
	@SecuredStudyList VARCHAR(MAX),
	
	-- View Options
	@InService INT = 0,					-- 0: Not in service, 1: In Service, -1: Either
	@WorkflowStates NVARChAR(MAX),		-- comma seperated list of worflow state ids, '-1': All workflow states
	@InStudyMigration BIT,					-- 1: In Study Migration, 0: All others study status
	
	@SegmentId bigint				 -- added by Framework
)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @taskNumber INT, @totalTaskCount INT
	
	DECLARE @tmpData TABLE(ID INT IDENTITY(1,1), 
		CodingElementId INT,
		CodingRequestId INT,
		SourceSystemId SMALLINT,
		SegmentId SMALLINT,
		CodingSourceAlgorithmID INT,
		DictionaryLevelId INT,
		VerbatimTerm NVARCHAR(1000),
		IsClosed BIT,
		IsCompleted BIT,
		IsAutoCodeRequired BIT,
		AutoCodeDate DATETIME,
		CompletionDate DATETIME,
		Created DATETIME,
		Updated DATETIME,
		SearchType INT,
		CodingElementGroupID INT,
		SourceIdentifier NVARCHAR(200),
		IsStillInService BIT,
		WorkflowStateID	SMALLINT,
		AssignedSegmentedGroupCodingPatternId INT,
		Priority	TINYINT,
		AssignedTermText	nvarchar(900),
		AssignedTermCode	nvarchar(100),
		AssignedCodingPath	varchar(300),
		SourceField	nvarchar(450),
		SourceForm	nvarchar(450),
		SourceSubject	nvarchar(100),
		IsInvalidTask BIT,
		AssignedTermKey nvarchar(100),
		StudyDictionaryVersionId INT,
		QueryStatus SMALLINT)

	INSERT INTO @tmpData
	EXECUTE spCodingElementSearchForVCRWithFilterGroup
		@userID,
		@TrackableObjectId,	-- 0=All TrackableObjects, >0=with specific TrackableObjectId, -->> -1=Old TrackableObjects, 
		@SourceSystemId, 
		@SynonymListId,
		@Priority, 
		@TimeElapsed, 
		@QueryStatus,
		@SearchForText,	-- search for text based on search for option selected
		@CodingElementID, --@currentCodingElementID INT,
		@taskNumber OUTPUT,
		@totalTaskCount OUTPUT,
		@SortExpression,
		@SortOrder,
		@SecuredStudyList,
		@InService,					-- return only in service or only not in service
		@WorkflowStates,		-- comma seperated list of worflow state ids
		@InStudyMigration,
		@SegmentId
	
	
	SELECT *
	FROM CodingElements
	WHERE CodingElementID = 
		(
		SELECT CodingElementID
		FROM @tmpData
		WHERE ID = (SELECT ISNULL(T_Internal.ID, 0) + 1
				FROM
				(
					SELECT ID
					FROM @tmpData
					WHERE @CodingElementID = CodingElementID
				) AS T_Internal
			)	
		)


END 