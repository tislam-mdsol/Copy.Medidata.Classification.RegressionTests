DECLARE @ancientDictionaries TABLE(Id INT PRIMARY KEY, Dictionary VARCHAR(50))

INSERT INTO @ancientDictionaries (Id, Dictionary)
VALUES
	(	1	, 'MedDRA_Orig'),
	(	2	, 'WhoDrugB2_old'),
	(	3	, 'WhoDrugDDB2_Old'),
	(	4	, 'AZDD_old'),
	(	5	, 'MedDRAMedHistory_Orig'),
	(	7	, 'WhoDrugDDC_Old'),
	(	9	, 'HD_DDE_B2_Old'),
	(	11	, ' WHODrug_DDE_C _Old'),
	(	12	, 'JDrug_Orig')

DELETE DSC
FROM DictionarySegmentConfigurations DSC
	JOIN @ancientDictionaries AD
		ON DSC.DictionaryId_Backup = AD.Id

DELETE DLI
FROM DictionaryLicenceInformations DLI
	JOIN @ancientDictionaries AD
		ON DLI.DictionaryId_Backup = AD.Id

DELETE DVS
FROM DictionaryVersionSubscriptions DVS
	LEFT JOIN DictionaryLicenceInformations DLI
		ON DVS.DictionaryLicenceInformationID = DLI.DictionaryLicenceInformationID
WHERE DLI.DictionaryLicenceInformationID IS NULL
