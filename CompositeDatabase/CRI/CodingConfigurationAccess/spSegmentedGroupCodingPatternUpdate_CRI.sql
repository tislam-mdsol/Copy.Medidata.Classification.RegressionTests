IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSegmentedGroupCodingPatternUpdate_CRI')
	DROP PROCEDURE spSegmentedGroupCodingPatternUpdate_CRI
GO

CREATE PROCEDURE dbo.spSegmentedGroupCodingPatternUpdate_CRI 
(
	@SegmentedGroupCodingPatternID BIGINT,
	
	 -- state control
	 @CacheVersion BIGINT,
	 @NewCacheVersion BIGINT,
	 @WasUpdated BIT OUTPUT,
 	
	@CodingElementGroupID BIGINT,
	@CodingPatternID BIGINT,
	@MatchPercent DECIMAL,

	@SynonymStatus TINYINT,
	@Active BIT,
	@IsExactMatch BIT,

	@SynonymManagementID INT,
    @UserId INT,
    	 
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

	SET @Updated = GetUtcDate()  

	UPDATE SegmentedGroupCodingPatterns
	SET
		CacheVersion         = @NewCacheVersion,
		CodingElementGroupID = @CodingElementGroupID,
		CodingPatternID      = @CodingPatternID,
		SynonymStatus        = @SynonymStatus,
		MatchPercent         = @MatchPercent,
		Active               = @Active,
		IsExactMatch         = @IsExactMatch,
		SynonymManagementID  = @SynonymManagementID,
		UserId               = @UserId,
		Updated              = @Updated 
	 WHERE SegmentedGroupCodingPatternID = @SegmentedGroupCodingPatternID
		AND CacheVersion = @CacheVersion
		
	 -- check if we updated
	 IF (@@ROWCOUNT = 0)
		SET @WasUpdated = 0
	 ELSE
		SET @WasUpdated = 1	 
	 
END

GO