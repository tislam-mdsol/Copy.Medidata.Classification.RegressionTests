-- Retire CodingElements
UPDATE CE
SET CE.IsInvalidTask = 1,
	CE.Updated = GETUTCDATE(),
	CE.CacheVersion = CE.CacheVersion + 2
FROM studydictionaryversion sdv
	JOIN codingelements ce
		ON ce.studydictionaryversionid = sdv.studydictionaryversionid
WHERE registrationname = ''

-- Delete SDVs
DELETE studydictionaryversion
WHERE registrationname = ''

-- Delete Registrations
DELETE projectdictionaryregistrations
WHERE registrationname = ''