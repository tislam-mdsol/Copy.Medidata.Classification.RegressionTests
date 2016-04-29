	UPDATE L SET L.DefaultLevel = 0 
	FROM MedicalDictionaryLevel L
		Join MedicalDictionary M
		on L.MedicalDictionaryID=M.MedicalDictionaryId
		WHERE L.OID = 'PT' 
			AND M.MedicalDictionaryType='MedDRA'

	UPDATE L SET L.DefaultLevel = 1 
	FROM MedicalDictionaryLevel L
		Join MedicalDictionary M
		on L.MedicalDictionaryID=M.MedicalDictionaryId
		WHERE L.OID = 'LLT' 
			AND M.MedicalDictionaryType='MedDRA'	

	UPDATE L SET L.DefaultLevel = 1 
	FROM MedicalDictionaryLevel L
		Join MedicalDictionary M
		on L.MedicalDictionaryID=M.MedicalDictionaryId
		WHERE L.OID = 'PRODUCTSYNONYM' 
			AND M.MedicalDictionaryType='WhoDRUGB2'
		
	UPDATE L SET L.DefaultLevel = 0 
	FROM MedicalDictionaryLevel L
		Join MedicalDictionary M
		on L.MedicalDictionaryID=M.MedicalDictionaryId
		WHERE L.OID = 'PRODUCT' 
			AND M.MedicalDictionaryType='WhoDRUGB2'
