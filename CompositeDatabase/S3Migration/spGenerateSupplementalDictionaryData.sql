
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGenerateSupplementalDictionaryData')
BEGIN
	DROP PROCEDURE dbo.spGenerateSupplementalDictionaryData
END
GO


CREATE PROCEDURE dbo.spGenerateSupplementalDictionaryData
AS
BEGIN

DECLARE @t TABLE(
	levelId INT PRIMARY KEY, 
	levelKey NVARCHAR(100))

INSERT INTO  @t
EXEC spGetDictionaryAndLevels

DECLARE @dMapping TABLE(OldOID VARCHAR(50), NewOID VARCHAR(50), Provider_ VARCHAR(50), Format_ VARCHAR(50), Type_ VARCHAR(50), SupportsPrimaryPath BIT)

INSERT INTO @dMapping (OldOID, NewOID, Provider_, Type_, Format_, SupportsPrimaryPath)
VALUES('MedDRA','MedDRA','MedDRA', '', '', 1),
	('AZDD','AZDD','AZDD', '', '', 0),
	('WhoDrugDDB2','WHODrug-DD-B2','WHODrug', 'DD', 'B2', 0),
	('WhoDrugDDEB2','WHODrug-DDE-B2','WHODrug', 'DDE', 'B2', 0),
	('HD_DDE_B2','WHODrug-DDE_HD-B2','WHODrug', 'DDE_HD', 'B2', 0),
	('WhoDrugDDC','WHODrug-DD-C','WHODrug', 'DD', 'C', 0),
	('WHODrug_DDE_C','WHODrug-DDE-C','WHODrug', 'DDE', 'C', 0),
	('JDrug','JDrug','JDrug', '', '', 0),
	('WhoDrugHDDDEC','WHODrug-DDE_HD-C','WHODrug', 'DDE_HD', 'C', 0)


DECLARE @componentMapping TABLE(OldOID VARCHAR(50), NewOID VARCHAR(50))

INSERT INTO @componentMapping (OldOID, NewOID)
VALUES('DRUGRECORDNUMBER','drug_record_number'),
	('SEQUENCENUMBER1','sequence_number_1'),
	('SEQUENCENUMBER2','sequence_number_2'),
	('CHECKDIGIT','check_digit'),
	('SOURCEYEAR','source_year'),
	('SOURCE','source'),
	('SOURCECOUNTRY','source_country'),
	('DESIGNATION','designation'),
	('COMPANY','company'),
	('COMPANYCOUNTRY','company_country'),
	('NUMBEROFINGREDIENTS','number_of_ingredients'),
	('INGREDIENTS','ingredients'),
	('SALTESTERCODE','sal_tester_code'),
	('YEARQUARTER','year_quarter'),
	('CASNUMBER','cas_number'),
	('LANGUAGECODE','language_code'),
	('SUBSTANCENAME','substance_name'),
	('COUNTRY','country'),
	('CREATEDATE','create_date'),
	('DATECHANGED','date_changed'),
	('GENERIC','generic'),
	('INGREDIENTCREATEDATE','ingredient_create_date'),
	('MARKETINGAUTHORIZATIONDATE','marketing_authorization_date'),
	('MARKETINGAUTHORIZATIONHOLDER','marketing_authorization_holder'),
	('MARKETINGAUTHORIZATIONHOLDERCOUNTRY','marketing_authorization_holder_country'),
	('MARKETINGAUTHORIZATIONNUMBER','marketing_authorization_number'),
	('MARKETINGAUTHORIZATIONHOLDERNUMBER','marketing_authorization_holder_number'),
	('MARKETINGAUTHORIZATIONWITHDRAWALDATE','marketing_authorization_withdrawal_date'),
	('NAMESPECIFIER','name_specifier'),
	('PHARMACEUTICALFORM','pharmaceutical_form'),
	('PHARMACEUTICALFORMCREATEDATE','pharmaceutical_form_create_date'),
	('PRODUCTGROUP','product_group'),
	('PRODUCTGROUPDATERECORDED','product_group_date_recorded'),
	('PRODUCTTYPE','product_type'),
	('QUANTITY','quantity'),
	('QUANTITY2','quantity_2'),
	('ROUTEOFADMINISTRATION','route_of_administration'),
	('SEQUENCENUMBER3','sequence_number_3'),
	('SEQUENCENUMBER4','sequence_number_4'),
	('SUBSTANCE','substance'),
	('UNIT','unit'),
	('Classification','classification'),
	('DosageForm','dosage_form'),
	('DrugCodeClass1','drug_code_class_1'),
	('DrugCodeClass2','drug_code_class_2'),
	('DrugNameKana','drug_name_kana'),
	('EnglishName','english_name'),
	('INNFlag','inn_flag'),
	('JANFlag','jan_flag'),
	('MaintainDateEng','maintain_date_eng'),
	('MaintainDateJpn','maintain_date_jpn'),
	('MaintainFlagEng','maintain_flag_eng'),
	('MaintainFlagJpn','maintain_flag_jpn'),
	('Manufacturer','manufacturer'),
	('PreferredNameKana','preferred_name_kana'),
	('Reserve','reserve'),
	('StandardNameCode','standard_name_code'),
	('UsageClassification','usage_classification')


; WITH DictionaryLevels AS (

SELECT d.*, REPLACE(Z.list,'&#x0D;','') AS Levels, REPLACE(C.list,'&#x0D;','') AS Components 
FROM MedicalDictionary m
	JOIN @dMapping d
		ON m.OID = d.OldOID
	CROSS APPLY
	(
		SELECT Y.X AS [text()]
		FROM MedicalDictionaryLevel L
			JOIN @t t
				ON L.DictionaryLevelId = t.levelId
				AND m.MedicalDictionaryId = l.MedicalDictionaryID
			CROSS APPLY
			(
				SELECT 
		'
		{
			"name"           : "'+t.levelKey+'",
			"search_name"    : "'+L.OID+'",  
			"source_ordinal" : "'+CAST(L.SourceOrdinal AS VARCHAR)+'",
			"is_codable"     : "'+CASE WHEN CodingLevel = 1 THEN 'True' ELSE 'False' END +'", 
			"is_default"     : "'+CASE WHEN DefaultLevel = 1 THEN 'True' ELSE 'False' END+'"
		},' AS X
			) AS Y
		ORDER BY L.MedicalDictionaryID ASC, L.Ordinal ASC 
		FOR XML PATH('')
	) AS Z (list)
	CROSS APPLY
	(
		SELECT 
		'
		{
			"name"            : "' + C.OID + '",
			"search_name"     : "'+ ISNULL(cm.NewOID, 'TODO: S3 KEY NOT SPECIFIED') +'",
			"valid_on_levels" : [' + SUBSTRING(LC.list, 0, LEN(LC.list)) + ']
		},'
		FROM MedicalDictComponentTypes C
			LEFT JOIN @componentMapping cm
				ON C.OID = cm.OldOID
			CROSS APPLY
			(
				SELECT '"'+t.levelKey+'",'
				FROM MedicalDictLevelComponents LC
					JOIN MedicalDictionaryLevel L
						ON LC.DictionaryLevelId = L.DictionaryLevelId
					JOIN @t t
						ON T.levelId = L.DictionaryLevelId
				WHERE LC.ComponentTypeID = C.ComponentTypeID
				ORDER BY L.Ordinal ASC
				FOR XML PATH('')
			) AS LC (list)
		WHERE C.MedicalDictionaryID = m.MedicalDictionaryId
		ORDER BY C.MedicalDictionaryID ASC, C.OID ASC 
		FOR XML PATH('')
	) AS C (list)
),
Dictionaries AS (
	SELECT X.Y
	FROM DictionaryLevels DL
		CROSS APPLY 
		(	
			SELECT Y =
	'
	{
		"provider"              : "' + DL.Provider_ + '",
		"type"                  : "' + DL.Type_ + '",
		"format"                : "' + DL.Format_ + '",
		"dictionary"            : "' + DL.NewOID + '",
		"supports_primary_path" : "' + CASE WHEN DL.SupportsPrimaryPath = 1 THEN 'True' ELSE 'False' END +'",
		"levels"                : [' + SUBSTRING(DL.Levels, 0, LEN(DL.Levels)) +
		'],'
		+ CASE WHEN ISNULL(DL.Components, '') <> '' THEN 
		'
		"components"            : [' + SUBSTRING(DL.Components, 0, LEN(DL.Components)) +
		']' -- conditional!!! TODO
		ELSE '' END +
	'
	},'
	) AS X
),
Final AS (
SELECT TOP 1
	REPLACE(f.list,'&#x0D;','') AS Final
FROM Dictionaries m
	CROSS APPLY
	(
		SELECT d.Y AS [text()]
		FROM Dictionaries d
		FOR XML PATH('')
	) AS f (list)
)

SELECT 
'{
	"dictionary_mapping": ['+SUBSTRING(Final, 0, LEN(Final))+']
}'

FROM Final
	
	
END 