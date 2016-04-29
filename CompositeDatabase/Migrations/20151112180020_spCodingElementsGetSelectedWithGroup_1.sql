-- TODO - Use UDTs

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementsGetSelectedWithGroup')
	BEGIN
		DROP Procedure spCodingElementsGetSelectedWithGroup
	END
GO	


--spCodingElementsGetSelectedWithGroup '5323;0;20;2', ';', 1
--spCodingElementsGetSelectedWithGroup '108053;-1;12;14', ';', 12
--spCodingElementsGetSelectedWithGroup1 '96695;0;2;14', ';', 12

CREATE procedure [dbo].spCodingElementsGetSelectedWithGroup
(
	@SelectedIdsAndData VARCHAR(MAX),
	@Delimeter CHAR(1),
	@SegmentId INT
)
AS
BEGIN

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @studyDictionaryIds TABLE (StudyDictionaryVersionId INT PRIMARY KEY, SynonymListID INT)
	
		
	INSERT INTO @studyDictionaryIds(StudyDictionaryVersionId, SynonymListID)
	SELECT StudyDictionaryVersionId, SynonymManagementID
	FROM StudyDictionaryVersion
	WHERE SegmentID = @SegmentId
	
	DECLARE @TempItems TABLE (ParsingOrder INT IDENTITY(1, 1) PRIMARY KEY, Item BIGINT)
	INSERT INTO @TempItems(Item)
	SELECT * FROM dbo.fnParseDelimitedString(@SelectedIdsAndData, @Delimeter)

	;WITH xCTE (CodingElementGroupID, SegmentedGroupCodingPatternID, SynonymListId, WorkflowStateID, QueryStatus )
	AS
	(
		SELECT TI.Item,
			CASE WHEN X1.SegmentedGroupCodingPatternID = 0 THEN -1
				ELSE X1.SegmentedGroupCodingPatternID
			END,
			X2.SynonymListId,
			X3.WorkflowStateID,
			X4.QueryStatus
		FROM @TempItems TI
			CROSS APPLY
				(SELECT SegmentedGroupCodingPatternID = Item
				FROM @TempItems
				WHERE TI.ParsingOrder = ParsingOrder - 1)
				AS X1
			CROSS APPLY
				(SELECT SynonymListId = Item
				FROM @TempItems
				WHERE TI.ParsingOrder = ParsingOrder - 2)
				AS X2
			CROSS APPLY
				(SELECT WorkflowStateID = Item
				FROM @TempItems
				WHERE TI.ParsingOrder = ParsingOrder - 3)
				AS X3
			CROSS APPLY
				(SELECT QueryStatus = Item
				FROM @TempItems
				WHERE TI.ParsingOrder = ParsingOrder - 4)
				AS X4						
		WHERE TI.ParsingOrder % 5 = 1
	)
	

	SELECT CE.* 
	FROM CodingElements CE
		JOIN xCTE CED
			ON CE.CodingElementGroupID = CED.CodingElementGroupID
			AND CE.SegmentId = @SegmentId
			AND CE.WorkflowStateID = CED.WorkflowStateID
			AND CE.AssignedSegmentedGroupCodingPatternId = CED.SegmentedGroupCodingPatternID
			AND CE.QueryStatus = CED.QueryStatus
	WHERE
		CE.StudyDictionaryVersionId IN 
		(
			SELECT StudyDictionaryVersionId
			FROM @studyDictionaryIds SD
			WHERE CED.SynonymListId = SD.SynonymListID
		)

END
  
  