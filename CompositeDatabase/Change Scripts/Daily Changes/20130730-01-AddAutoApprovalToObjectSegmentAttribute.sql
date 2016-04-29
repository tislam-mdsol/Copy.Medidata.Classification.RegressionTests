---This script is to add a new configuration AutoApproval for Dictionary 
---For Sepecific Object segment attributes relationships, 
-- please cross reference MedicalDictSegmentAssociation(Object type is DictionaryRef); MedicalDictVerLocaleSegmentAssociation(Object type is DictionaryVersionLocaleRef )
BEGIN TRY
	DECLARE @ObjectSegmentId INT
	DECLARE ObjectSegment_cursor CURSOR FOR
	--IsAutoApproval only apply to MedicalDictSegmentAssociation
	SELECT  ObjectSegmentId FROM ObjectSegments 
	WHERE ObjectTypeId IN (SELECT ObjectTypeId FROM ObjectTypeR WHERE ObjectTypeName='DictionaryRef')
		AND Deleted = 0

	OPEN ObjectSegment_cursor 
	FETCH NEXT FROM ObjectSegment_cursor into @ObjectSegmentId

	WHILE @@FETCH_STATUS =0
	BEGIN
	    DECLARE @ObjectSegmentAttributeID bigint, @Created datetime, @Updated datetime 
		IF EXISTS (SELECT NULL FROM ObjectSegmentAttributes WHERE ObjectSegmentID = @ObjectSegmentId) 
		AND NOT EXISTS (SELECT NULL FROM ObjectSegmentAttributes WHERE ObjectSegmentID = @ObjectSegmentId AND Tag ='IsAutoApproval')
		BEGIN
			EXEC spObjectSegmentAttributeInsert @ObjectSegmentId,'IsAutoApproval', 'False',@ObjectSegmentAttributeID output, @Created output, @Updated output
		END
		FETCH NEXT FROM ObjectSegment_cursor into @ObjectSegmentId 
	END

	CLOSE ObjectSegment_cursor
	DEALLOCATE ObjectSegment_cursor 
END TRY
BEGIN CATCH
    IF CURSOR_STATUS('global','ObjectSegment_cursor')>=-1
	BEGIN
		CLOSE ObjectSegment_cursor
		DEALLOCATE ObjectSegment_cursor
	END
	DECLARE @errorString NVARCHAR(MAX)
	SET @errorString = N'ERROR Adding AutoApproval Attribute: Transaction Error Message - ' + ERROR_MESSAGE()
	PRINT @errorString
	RAISERROR(@errorString, 16, 1)
END CATCH