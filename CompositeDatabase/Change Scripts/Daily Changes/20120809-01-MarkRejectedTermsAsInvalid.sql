
-- Flag all existing CodingRejections as invalid (DE2204)
UPDATE CodingElements
SET IsInvalidTask = 1
WHERE CodingElementId IN (SELECT CodingElementId FROM CodingRejections)
