IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentedGroupCodingPatternInsert')
	DROP PROCEDURE spSegmentedGroupCodingPatternInsert
GO

CREATE PROCEDURE dbo.spSegmentedGroupCodingPatternInsert 
(
	@SegmentedGroupCodingPatternID BIGINT OUTPUT,
	@CodingElementGroupID BIGINT,
	@CodingPatternID BIGINT,
	@MatchPercent DECIMAL,

	@SynonymStatus TINYINT,
	@Active BIT,
	@IsExactMatch BIT,

	@SynonymManagementID INT,
    @UserId INT,
	@CacheVersion BIGINT,
	
	@Created DATETIME OUTPUT,  
	@Updated DATETIME OUTPUT,
	@SegmentID INT
)  
AS  
BEGIN

    -- validate that codingPattern matches the context of the synonym list
    DECLARE @matchOffset INT

    SELECT @matchOffset = CHARINDEX(SMM.MedicalDictionaryVersionLocaleKey, CP.CodingPath, 0)
    FROM SynonymMigrationMngmt SMM (NOLOCK)
	    JOIN CodingPatterns CP (NOLOCK)
		    ON SMM.SynonymMigrationMngmtID = @SynonymManagementID
		    AND CP.CodingPatternId         = @CodingPatternID

    IF (ISNULL(@matchOffset, 0) <> 2)
    BEGIN
        DECLARE @errorMessage VARCHAR(500) =
            'Synonym insertion failed - CodingPatternId:'+
            CAST(@CodingPatternID AS VARCHAR)+
            ' does not match the dictionary context of SynonymListId:'+
            CAST(@SynonymManagementID AS VARCHAR)

        -- failed assertion
        RAISERROR(@errorMessage, 16, 1)
        RETURN 1
    END
    --end validation

	DECLARE @UtcDate DATETIME  
	
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate, 
		@Updated = @UtcDate  

	INSERT INTO dbo.SegmentedGroupCodingPatterns (  
		CodingElementGroupID,
		CodingPatternID,
		SynonymStatus,
		MatchPercent,
		
		SynonymManagementID,
		UserId,
		CacheVersion,
		Active,
		IsExactMatch,
		SegmentID,

		Created,  
		Updated  
	 ) 
	 VALUES (  
		@CodingElementGroupID,
		@CodingPatternID,
		@SynonymStatus,
		@MatchPercent,

		@SynonymManagementID,
		@UserId,
		@CacheVersion,
		@Active,
		@IsExactMatch,
		@SegmentID,

		@UtcDate,  
		@UtcDate  
	 )
	 
	 SET @SegmentedGroupCodingPatternID = SCOPE_IDENTITY()
	 
END

GO