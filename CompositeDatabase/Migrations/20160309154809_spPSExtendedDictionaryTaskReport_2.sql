IF  EXISTS (SELECT null FROM sys.objects WHERE TYPE= 'P' and NAME = 'spPSExtendedDictionaryTaskReport')
	DROP PROCEDURE dbo.spPSExtendedDictionaryTaskReport
GO

CREATE PROCEDURE [dbo].spPSExtendedDictionaryTaskReport
(
	@StudyName NVARCHAR(2000),
	@DictionaryOID NVARCHAR(255),
	@Locale CHAR(3)
)
AS
BEGIN
	
DECLARE @TrackableObjectId INT,
		@SegmentId INT,
		@SDVID INT,
		@errorString NVARCHAR(500)

	--!!! HARDCODING WARNING (support proc)
	DECLARE @WorkflowLookup TABLE(WorkflowStateId INT, Name NVARCHAR(255))
	INSERT INTO @WorkflowLookup (WorkflowStateId, Name)
	VALUES (1, 'Start'), (2, 'Waiting Manual Code'), (3, 'Waiting Approval'), 
		(4, 'Waiting Transmission'), (5, 'Completed'), (6, 'Reconsider')

	SELECT @SegmentId = S.SegmentId,
		   @TrackableObjectId = T.TrackableObjectId
	FROM TrackableObjects T
	JOIN Segments S ON S.SegmentId = T.SegmentId
	WHERE T.ExternalObjectName = @StudyName

	IF (@TrackableObjectId IS NULL)
	BEGIN
		SET @errorString = 'Study (' + @StudyName + ') not found'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END


	SELECT @SDVID = SDV.StudyDictionaryVersionID
	FROM DictionaryRef D
	JOIN StudyDictionaryVersion SDV ON SDV.StudyID = @TrackableObjectId 
		AND SDV.MedicalDictionaryID = D.DictionaryRefId
		AND SDV.DictionaryLocale = @Locale
	WHERE D.OID = @DictionaryOID

	SELECT CE.CodingElementId,
	       CE.VerbatimTerm 'Verbatim',
		   @StudyName 'Study',
		   CE.SourceField 'Field',
		   CE.SourceLine 'Line',
		   CE.SourceForm 'Form',
		   CE.SourceEvent 'Event',
		   CE.SourceSubject 'Subject',
		   CE.SourceSite 'Site',
		   ISNULL(Comp.list,'') 'CompsAndSupps',
		   CE.[Priority],
		   W.Name 'Status',
		   CE.AssignedTermText 'Assigned Term',
		   @DictionaryOID 'Dictionary',
		   CE.Created 'Entered System'
	FROM CodingElements CE
		JOIN @WorkflowLookup W ON CE.WorkflowStateID = W.WorkflowStateId
		CROSS APPLY
		(
			SELECT 
				'|' +
				CASE WHEN CEGC.IsSupplement = 1 THEN
					'Supplement'
				ELSE
					'Component'
				END
				+ '|' +
				CASE WHEN CEGC.IsSupplement = 1 THEN
					CAST(SUPP.KeyField AS VARCHAR)
				ELSE
					CAST(COMP.OID AS VARCHAR)
				END
				+ '|' +
				CASE WHEN @Locale = 'ENG' THEN
					CAST(GV_ENG.VerbatimText AS VARCHAR)
				ELSE
					CAST(GV_JPN.VerbatimText AS VARCHAR)
				END
			FROM CodingElementGroupComponents CEGC
			LEFT JOIN DictionaryComponentTypeRef COMP ON COMP.DictionaryComponentTypeRefID = CEGC.ComponentTypeID
			LEFT JOIN SupplementFieldKeys SUPP ON SUPP.SupplementFieldKeyId = CEGC.ComponentTypeID
			LEFT JOIN GroupVerbatimEng GV_ENG ON CEGC.NameTextID = GV_ENG.GroupVerbatimID
			LEFT JOIN GroupVerbatimJpn GV_JPN ON CEGC.NameTextID = GV_JPN.GroupVerbatimID
			WHERE CodingElementGroupID = CE.CodingElementGroupID
			FOR XML PATH('')
		) Comp (list)
	WHERE CE.StudyDictionaryVersionId = @SDVID
	AND CE.IsInvalidTask = 0
	AND CE.IsClosed = 0
END
GO  