SET NOCOUNT ON 
GO

DELETE FROM [DictionaryVersionDiffDepth]

-- DO NOT WRITE ABOVE THIS LINE

INSERT INTO DictionaryVersionDiffDepth (DictionaryType, DictionaryOID, MaxPastOrdinalRange) 
	VALUES('WhoDRUGC', 'WHODrug_DDE_C', 12)
INSERT INTO DictionaryVersionDiffDepth (DictionaryType, DictionaryOID, MaxPastOrdinalRange) 
	VALUES('WhoDRUGC', 'WHODrug_HD_DDE_C', 12)
