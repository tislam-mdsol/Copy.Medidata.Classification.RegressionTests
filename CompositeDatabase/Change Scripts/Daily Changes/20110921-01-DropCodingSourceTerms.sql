IF EXISTS 	
	(SELECT NULL FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CodingSourceTerms')
BEGIN

	-- 1. SourceTermRefs
	;WITH x
	AS
	(
		SELECT CodingElementId, CodingSourceTermId
		FROM CodingSourceTerms
		WHERE CodingElementId <> CodingSourceTermId
	)

	UPDATE CSTR
	SET CSTR.CodingSourceTermId = x.CodingElementId
	FROM CodingSourceTermReferences CSTR
		JOIN x
			ON CSTR.CodingSourceTermId = x.CodingSourceTermId
			
			
	-- 2. SourceTermComps
	;WITH x
	AS
	(
		SELECT CodingElementId, CodingSourceTermId
		FROM CodingSourceTerms
		WHERE CodingElementId <> CodingSourceTermId
	)

	UPDATE CSTR
	SET CSTR.CodingSourceTermId = x.CodingElementId
	FROM CodingSourceTermComponents CSTR
		JOIN x
			ON CSTR.CodingSourceTermId = x.CodingSourceTermId
			

	-- 3. SourceTermSupps
	;WITH x
	AS
	(
		SELECT CodingElementId, CodingSourceTermId
		FROM CodingSourceTerms
		WHERE CodingElementId <> CodingSourceTermId
	)

	UPDATE CSTR
	SET CSTR.CodingSourceTermId = x.CodingElementId
	FROM CodingSourceTermSupplementals CSTR
		JOIN x
			ON CSTR.CodingSourceTermId = x.CodingSourceTermId

	-- also drop the table
	DROP TABLE CodingSourceTerms
END