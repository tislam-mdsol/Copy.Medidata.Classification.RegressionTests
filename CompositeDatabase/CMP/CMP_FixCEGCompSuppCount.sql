;WITH P AS
(
	SELECT *
	FROM CodingElementGroups ceg
		CROSS APPLY
		(
			SELECT ISNULL(MAX(CC), 0) AS CC
			FROM 
			(
				SELECT COUNT(1) AS CC
				FROM CodingElementGroupComponents cegc
				WHERE cegc.CodingElementGroupID = ceg.CodingElementGroupID
			) AS X
		) AS X
),
pBad AS
(
	SELECT *
	FROM P
	WHERE CC <> CompSuppCount
)

UPDATE ceg
SET ceg.CompSuppCount = pBad.CC
FROM pBad
	JOIN CodingElementGroups ceg
		ON ceg.CodingElementGroupID = pBad.CodingElementGroupID
