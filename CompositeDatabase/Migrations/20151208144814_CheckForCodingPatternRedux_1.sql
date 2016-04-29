IF EXISTS (
	SELECT NULL 
	FROM CodingPatterns
	GROUP BY CodingPath
	HAVING COUNT(1) > 2)
BEGIN

	RAISERROR(N'ERROR CodingPattern path complexity is higher than 2 - reduce the n-plicate CodingPaths before proceeding.', 16, 1)

END
