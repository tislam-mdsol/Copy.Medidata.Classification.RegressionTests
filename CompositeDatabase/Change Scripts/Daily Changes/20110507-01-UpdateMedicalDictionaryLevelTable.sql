--update WhoDrug images
IF EXISTS (SELECT * FROM MedicalDictionaryLevel WHERE OID = 'PRODUCT')
BEGIN
	update MedicalDictionaryLevel set ImageUrl='PT.gif' where OID='PRODUCT'	
END

IF EXISTS (SELECT * FROM MedicalDictionaryLevel WHERE OID = 'PRODUCTSYNONYM')
BEGIN
	update MedicalDictionaryLevel set ImageUrl='TN.gif' where OID='PRODUCTSYNONYM'
END

 