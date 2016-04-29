-- 1. Force Primary Path
;WITH segCTE (SegmentId)
AS
(
	SELECT DISTINCT(SegmentId)
	FROM Configuration
	WHERE SegmentID NOT IN 
		(
			SELECT SegmentID 
			FROM Configuration
			WHERE Tag = 'ForcePrimaryPathSelection'
		)
)

-- a. insert if it doesn't exist
INSERT INTO Configuration (Tag, ConfigValue, StudyID, SegmentID, Deleted)
SELECT 'ForcePrimaryPathSelection', 'No', -1, SegmentId, 0
FROM segCTE
-- b. update
UPDATE Configuration
SET ConfigValue = 'No'
WHERE Tag = 'ForcePrimaryPathSelection' 


-- 2. Bypass Reconsider Upon Reclassify Flag
;WITH segCTE (SegmentId)
AS
(
	SELECT DISTINCT(SegmentId)
	FROM Configuration
	WHERE SegmentID NOT IN 
		(
			SELECT SegmentID 
			FROM Configuration
			WHERE Tag = 'BypassReconsiderUponReclassifyFlag'
		)
)

-- a. insert if it doesn't exist
INSERT INTO Configuration (Tag, ConfigValue, StudyID, SegmentID, Deleted)
SELECT 'BypassReconsiderUponReclassifyFlag', 'No', -1, SegmentId, 0
FROM segCTE
-- b. update
UPDATE Configuration
SET ConfigValue = 'No'
WHERE Tag = 'BypassReconsiderUponReclassifyFlag' 
