IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCriEdcDataInsert')
	DROP PROCEDURE dbo.spCriEdcDataInsert
GO
  
CREATE PROCEDURE dbo.spCriEdcDataInsert	
(
	@CodingRequestId				[BIGINT],
		
	@StudyUUID						[VARCHAR](50),
	@BatchOID						[NVARCHAR](450),
	@Locale							[CHAR](3),

	@Subject						[NVARCHAR](100),
	@Field							[NVARCHAR](450),
	@Form							[NVARCHAR](450),
	@VerbatimTerm					[NVARCHAR](450),
	@Event							[NVARCHAR](256),
	@Line							[NVARCHAR](256),
	@Site							[NVARCHAR](256),
	@Priority						[TINYINT],

	@SupplementFieldKey0			[NVARCHAR](450),
	@SupplementFieldKey1			[NVARCHAR](450),
	@SupplementFieldKey2			[NVARCHAR](450),
	@SupplementFieldKey3			[NVARCHAR](450),
	@SupplementFieldKey4			[NVARCHAR](450),
                    
	@SupplementFieldVal0			[NVARCHAR](1000),
	@SupplementFieldVal1			[NVARCHAR](1000),
	@SupplementFieldVal2			[NVARCHAR](1000),
	@SupplementFieldVal3			[NVARCHAR](1000),
	@SupplementFieldVal4			[NVARCHAR](1000),

	@RegistrationName				[NVARCHAR](100),
	@MedicalDictionaryLevelKey		[NVARCHAR](100),

	@Created						DATETIME OUTPUT,
	@EDCDataID						INT OUTPUT
)
AS  
BEGIN 
 
	DECLARE @UtcDate DateTime  
	SET @UtcDate = GetUtcDate()  
	SELECT @Created = @UtcDate
	
  
	INSERT INTO EDCData (  
		CodingRequestId,
		
		StudyUUID,
		BatchOID,
		Locale,

		Subject,
		Field,
		Form,
		VerbatimTerm,
		Event,
		Line,
		Site,
		Priority,

		SupplementFieldKey0,
		SupplementFieldKey1,
		SupplementFieldKey2,
		SupplementFieldKey3,
		SupplementFieldKey4,
                    
		SupplementFieldVal0,
		SupplementFieldVal1,
		SupplementFieldVal2,
		SupplementFieldVal3,
		SupplementFieldVal4,

		RegistrationName,
		MedicalDictionaryLevelKey,

		AssignedCodingPath,
		QueryComment,
		UserUUID,

		TimeStamp,
		Created,
		Updated
	) VALUES (  
		@CodingRequestId,
		
		@StudyUUID,
		@BatchOID,
		@Locale,

		@Subject,
		@Field,
		@Form,
		@VerbatimTerm,
		@Event,
		@Line,
		@Site,
		@Priority,

		@SupplementFieldKey0,
		@SupplementFieldKey1,
		@SupplementFieldKey2,
		@SupplementFieldKey3,
		@SupplementFieldKey4,
                    
		@SupplementFieldVal0,
		@SupplementFieldVal1,
		@SupplementFieldVal2,
		@SupplementFieldVal3,
		@SupplementFieldVal4,

		@RegistrationName,
		@MedicalDictionaryLevelKey,

		'',
		'',
		'',

		@UtcDate,
		@UtcDate,
		@UtcDate
	)  
	
	SET @EDCDataID = SCOPE_IDENTITY()  	
 
END  
  
GO
