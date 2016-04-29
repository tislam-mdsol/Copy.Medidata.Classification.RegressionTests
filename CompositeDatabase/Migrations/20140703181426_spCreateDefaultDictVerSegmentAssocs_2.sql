/** $Workfile: spCreateDefaultDictVerSegmentAssocs.sql $
**
** Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Altin Vardhami [avardhami@mdsol.com]
**/

---------------------------------------------------------------------------  


/*
** Creates Defaults Associations for a given [segmentid, dictionaryid]
** or [segmentid, dictionaryid, dictionaryversionordinal, locale]
*/

SET NOCOUNT ON
go

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCreateDefaultDictVerSegmentAssocs')
	DROP  Procedure  dbo.spCreateDefaultDictVerSegmentAssocs
GO

CREATE Procedure dbo.spCreateDefaultDictVerSegmentAssocs
(
	@SegmentID INT,
	@DictionaryID INT,
	@VersionOrdinal INT,
	@Dictionary0Version1 BIT,
	@DefaultAlgorithmID INT,
	@Locale CHAR(3),
	@ObjectSegmentID INT OUTPUT,
	@dictionaryObTpId INT,
	@versionObTypeId INT
) AS
BEGIN

	SET XACT_ABORT ON

	DECLARE @errorString VARCHAR(100)

	-- check if we have the segment
	IF NOT EXISTS (SELECT NULL FROM Segments
					WHERE SegmentID = @SegmentID)
	BEGIN
		SET @errorString = N'SegmentID: ['+ CAST(@SegmentID AS VARCHAR) + '] not found'
		RAISERROR(@errorString, 16, 1)
		RETURN
	END

	-- verify that the dictionary exists
	IF (NOT EXISTS (SELECT NULL FROM DictionaryRef
					WHERE DictionaryRefID = @DictionaryID))
	BEGIN
		SET @errorString =  N'DictionaryID: ['+ CAST(@DictionaryID AS VARCHAR) + '] not found'
		RAISERROR(@errorString, 16, 1)
		RETURN
	END

	begin try

		-- Register the Dictionary With Algorithms
		EXECUTE spCreateAlgorithmsForDictionary	@DictionaryID, @Locale

		-- Register the DictionaryAlgorithms with the Segment
		EXECUTE spCreateDictionaryAlgorithmsForSegment @DictionaryID, @SegmentID, @Locale
		
		-- Templates
		DECLARE @templateName NVARCHAR(100), @templateDesc NVARCHAR(500),
			@reverseTemplateName NVARCHAR(100),	@reverseTemplateDescription NVARCHAR(500)

		
		SELECT @templateName = 'Low to High',
			@templateDesc = 'Default template',
			@reverseTemplateName = 'High to Low',
			@reverseTemplateDescription = 'Reverse Default Template'
		
		
		EXECUTE spCreateDefaultTemplate @SegmentID, @DictionaryID, @templateName, @templateDesc, @reverseTemplateName, @reverseTemplateDescription, @Locale
	
	END TRY
	BEGIN CATCH

		Declare	@ErrorSeverity int, 
				@ErrorState int,
				@ErrorLine int,
				@ErrorMessage nvarchar(4000),
				@ErrorProc nvarchar(4000)

		select	@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE(),
				@ErrorLine = ERROR_LINE(),
				@ErrorMessage = ERROR_MESSAGE(),
				@ErrorProc = ERROR_PROCEDURE()
		select @ErrorMessage = coalesce(@ErrorProc, 'spCreateDefaultDictVerSegmentAssocs.sql') + ' (' + cast(@ErrorLine as nvarchar) + '): ' + @ErrorMessage
		raiserror (@ErrorMessage,  @ErrorSeverity, @ErrorState)
	
	END CATCH
	
	-- find out the default Algorithm
	SELECT @DefaultAlgorithmID = MDUA.MedicalDictionaryAlgorithmID
	FROM CodingSourceAlgorithm CSA
		JOIN MedicalDictionaryUseAlgorithm MDUA
			ON CSA.MedicalDictionaryUseAlgorithmID = MDUA.MedicalDictionaryUseAlgorithmID
			AND MDUA.MedicalDictionaryId = @DictionaryID
			AND CSA.SegmentId = @SegmentID
			AND CSA.IsDefault = 1

	IF (@DefaultAlgorithmID IS NULL)	
	BEGIN
		RAISERROR('DefaultAlgorithmID not found', 16, 1)
		RETURN
	END	

	
	-- The defaults for the dictionary

	DECLARE 
		@DefaultAlgorithmIDString varchar(30), 
		@DefaultSuggestThresholdString varchar(30), 
		@DefaultSelectThresholdString varchar(30),
		@MaxNumberofSearchResultsString varchar(30),
		@IsAutoAddSynonymString varchar(30), 
		@IsInheritedString varchar(30), 
		@ActiveString varchar(30),
		@IsAutoApprovalString VARCHAR(30)
		
	DECLARE 
		@DefaultSuggestThreshold INT, 
		@DefaultSelectThreshold INT,
		@MaxNumberofSearchResults INT,
		@IsAutoAddSynonym varchar(5), 
		@IsInherited varchar(5), 
		@Active varchar(5),
		@IsAutoApproval VARCHAR(5)


	SET @DefaultAlgorithmIDString = 'DefaultAlgorithmId'
	SET @DefaultSuggestThresholdString = 'DefaultSuggestThreshold'
	SET	@DefaultSelectThresholdString = 'DefaultSelectThreshold'
	SET @MaxNumberofSearchResultsString = 'MaxNumberofSearchResults'
	SET	@IsAutoAddSynonymString = 'IsAutoAddSynonym'
	SET	@IsInheritedString = 'IsInherited'
	SET	@ActiveString = 'Active'
	SET	@IsAutoApprovalString = 'IsAutoApproval'


	SET @DefaultSuggestThreshold = 70
	SET @DefaultSelectThreshold = 100
	SET @MaxNumberofSearchResults = 25
	SET @IsAutoAddSynonym = 'False'
	SET @IsInherited = 'True'
	SET @Active = 'True'
	SET @IsAutoApproval = 'False'


	-- The defaults for the dictionaryversion
	DECLARE @IsProdString varchar(30) = 'IsProd', 
		@IsProd varchar(5) = 'False'

	DECLARE @AttributesForObject TABLE 
	(
		AttributeDesc varchar(30),
		AttributeValue varchar(30),
		AlreadyExists BIT
	) 


	-- give accesses/defaults to the dictionary

	DECLARE @ObjectTypeID INT, @ObjectID INT

	IF (@Dictionary0Version1 = 0)
	BEGIN
	
		SET @ObjectID = @DictionaryID

		-- verify that the dictionary exists
		IF (NOT EXISTS (SELECT NULL FROM MedicalDictionaryAlgorithm
						WHERE MedicalDictionaryAlgorithmID = @DefaultAlgorithmID))
		BEGIN
			SET @errorString =  N'MedicalDictionaryAlgorithmID: ['+ CAST(@DefaultAlgorithmID AS VARCHAR) + '] not found'
			RAISERROR(@errorString, 16, 1)
			RETURN
		END		

		-- populate the table
		INSERT INTO @AttributesForObject (AttributeDesc, AttributeValue, AlreadyExists)
			VALUES (@DefaultAlgorithmIDString, @DefaultAlgorithmID, 0)
		INSERT INTO @AttributesForObject (AttributeDesc, AttributeValue, AlreadyExists)
			VALUES (@DefaultSuggestThresholdString, @DefaultSuggestThreshold, 0)
		INSERT INTO @AttributesForObject (AttributeDesc, AttributeValue, AlreadyExists)
			VALUES (@DefaultSelectThresholdString, @DefaultSelectThreshold, 0)
		INSERT INTO @AttributesForObject (AttributeDesc, AttributeValue, AlreadyExists)
			VALUES (@MaxNumberofSearchResultsString, @MaxNumberofSearchResults, 0)
		INSERT INTO @AttributesForObject (AttributeDesc, AttributeValue, AlreadyExists)
			VALUES (@IsAutoAddSynonymString, @IsAutoAddSynonym, 0)
		INSERT INTO @AttributesForObject (AttributeDesc, AttributeValue, AlreadyExists)
			VALUES (@IsInheritedString, @IsInherited, 0)
		INSERT INTO @AttributesForObject (AttributeDesc, AttributeValue, AlreadyExists)
			VALUES (@ActiveString, @Active, 0)
		INSERT INTO @AttributesForObject (AttributeDesc, AttributeValue, AlreadyExists)
			VALUES (@IsAutoApprovalString, @IsAutoApproval, 0)

		SELECT @ObjectTypeID = @dictionaryObTpId
		
	END
	ELSE
	BEGIN
		
		BEGIN TRY
			-- verify that the dictionaryversion exists AND is activated in the specific locale
			-- also check that rights to the dictionary have been given (if not grant them automatically)
			EXEC spCreateDefaultDictVerSegmentAssocs @SegmentID, @DictionaryID, @VersionOrdinal, 0, @DefaultAlgorithmID, @Locale, NULL, @dictionaryObTpId, @versionObTypeId
		END TRY
		BEGIN CATCH

			select	@ErrorSeverity = ERROR_SEVERITY(),
					@ErrorState = ERROR_STATE(),
					@ErrorLine = ERROR_LINE(),
					@ErrorMessage = ERROR_MESSAGE(),
					@ErrorProc = ERROR_PROCEDURE()
			select @ErrorMessage = coalesce(@ErrorProc, 'spCreateDefaultDictVerSegmentAssocs.sql') + ' (' + cast(@ErrorLine as nvarchar) + '): ' + @ErrorMessage
			raiserror (@ErrorMessage,  @ErrorSeverity, @ErrorState)
			
		END CATCH

		
		SELECT @ObjectID = DictionaryVersionLocaleRefID
					FROM DictionaryVersionLocaleRef
					WHERE VersionStatus = 8
						AND Locale = @Locale
						AND NewVersionOrdinal = @VersionOrdinal
						AND DictionaryRefID = @DictionaryID

		IF (@ObjectID IS NULL)
		BEGIN
			SET @errorString =  N'DictionaryOrdinal:[' + CAST(@VersionOrdinal AS VARCHAR) + '] has not been activated yet.'
			RAISERROR(@errorString, 16, 1)
			RETURN
		END
		
		-- populate the table
		INSERT INTO @AttributesForObject (AttributeDesc, AttributeValue, AlreadyExists)
			VALUES (@IsProdString, @IsProd, 0)
		INSERT INTO @AttributesForObject (AttributeDesc, AttributeValue, AlreadyExists)
			VALUES (@IsInheritedString, @IsInherited, 0)
		INSERT INTO @AttributesForObject (AttributeDesc, AttributeValue, AlreadyExists)
			VALUES (@ActiveString, @Active, 0)

		SELECT @ObjectTypeID = @versionObTypeId

	END

	-- the following part is the same for both dictionaries and versions

	SELECT @ObjectSegmentID = ObjectSegmentID 
	FROM ObjectSegments
	WHERE SegmentID = @SegmentID 
		AND ObjectTypeID = @ObjectTypeID
		AND ObjectID = @ObjectID
		AND Deleted = 0

	-- if no object/segment association - create it
	IF (@ObjectSegmentID IS NULL)
	BEGIN

		INSERT INTO ObjectSegments
		(ObjectID, ObjectTypeID, SegmentID,  ReadOnly, DefaultSegment, Deleted)
		VALUES(@ObjectID, @ObjectTypeID, @SegmentID, 0, 0, 0)
		
		SET @ObjectSegmentID = SCOPE_IDENTITY()

	END

	-- update the already exists flag
	UPDATE @AttributesForObject
	SET AlreadyExists = 1
	WHERE AttributeDesc IN (SELECT Tag FROM ObjectSegmentAttributes
					WHERE ObjectSegmentID = @ObjectSegmentID)

	-- insert the new defaults
	INSERT INTO ObjectSegmentAttributes
	(ObjectSegmentID, Tag, Value)
	SELECT @ObjectSegmentID, AttributeDesc, AttributeValue
	FROM @AttributesForObject
	WHERE AlreadyExists = 0
	
END
SET NOCOUNT OFF
GO