IF object_id('spGetDictionaryAndLevels') IS NOT NULL
	DROP PROCEDURE dbo.spGetDictionaryAndLevels
GO

CREATE PROCEDURE [dbo].spGetDictionaryAndLevels
AS
BEGIN

	DECLARE @t TABLE(
	levelId INT PRIMARY KEY, 
	levelKey NVARCHAR(100))


-- generated from
--DECLARE @dMapping TABLE(OldOID VARCHAR(50), NewOID VARCHAR(50))

--INSERT INTO @dMapping (OldOID, NewOID)
--VALUES('MedDRA','MedDRA'),
--	('AZDD','AZDD'),
--	('WhoDrugDDB2','WHODrug-DD-B2'),
--	('WhoDrugDDEB2','WHODrug-DDE-B2'),
--	('HD_DDE_B2','WHODrug-DDE_HD-B2'),
--	('WhoDrugDDC','WHODrug-DD-C'),
--	('WHODrug_DDE_C','WHODrug-DDE-C'),
--	('JDrug','JDrug'),
--	('WhoDrugHDDDEC','WHODrug-DDE_HD-C')

--SELECT '(',
--	l.DictionaryLevelId, ',',
--	''''+m.NewOID+'-'+l.OID+'''', '),'

--FROM MedicalDictionaryLevel l
--	JOIN MedicalDictionary d
--		ON l.MedicalDictionaryID = d.MedicalDictionaryId
--	JOIN @dMapping m
--		ON d.OID = m.OldOID
--ORDER BY d.MedicalDictionaryId


insert into @t(levelId, levelKey)
VALUES 
(	45	,	'AZDD-ATC'	),
(	46	,	'AZDD-PRODUCT'	),
(	47	,	'AZDD-PRODUCTSYNONYM'	),
(	48	,	'AZDD-INGREDIENT'	),
(	50	,	'WHODrug-DDE-B2-ATC'	),
(	51	,	'WHODrug-DDE-B2-PRODUCT'	),
(	52	,	'WHODrug-DDE-B2-PRODUCTSYNONYM'	),
(	53	,	'WHODrug-DDE-B2-INGREDIENT'	),
(	55	,	'WHODrug-DD-B2-ATC'	),
(	56	,	'WHODrug-DD-B2-PRODUCT'	),
(	57	,	'WHODrug-DD-B2-PRODUCTSYNONYM'	),
(	58	,	'WHODrug-DD-B2-INGREDIENT'	),
(	60	,	'WHODrug-DDE_HD-B2-ATC'	),
(	61	,	'WHODrug-DDE_HD-B2-PRODUCT'	),
(	62	,	'WHODrug-DDE_HD-B2-PRODUCTSYNONYM'	),
(	63	,	'WHODrug-DDE_HD-B2-INGREDIENT'	),
(	65	,	'WHODrug-DD-C-ATC'	),
(	66	,	'WHODrug-DD-C-MEDICINALPRODUCT'	),
(	67	,	'WHODrug-DD-C-INGREDIENT'	),
(	69	,	'WHODrug-DDE-C-ATC'	),
(	70	,	'WHODrug-DDE-C-MEDICINALPRODUCT'	),
(	71	,	'WHODrug-DDE-C-INGREDIENT'	),
(	77	,	'MedDRA-SOC'	),
(	78	,	'MedDRA-HLGT'	),
(	79	,	'MedDRA-HLT'	),
(	80	,	'MedDRA-PT'	),
(	81	,	'MedDRA-LLT'	),
(	82	,	'JDrug-HighLevelClass'	),
(	83	,	'JDrug-MidLevelClass'	),
(	84	,	'JDrug-LowLevelClass'	),
(	85	,	'JDrug-DetailedClass'	),
(	86	,	'JDrug-PreferredName'	),
(	87	,	'JDrug-Category'	),
(	88	,	'JDrug-DrugName'	),
(	89	,	'JDrug-EnglishName'	),
(	95	,	'WHODrug-DDE_HD-C-ATC'	),
(	96	,	'WHODrug-DDE_HD-C-MEDICINALPRODUCT'	),
(	97	,	'WHODrug-DDE_HD-C-INGREDIENT'	)

	SELECT *
	FROM @t

END