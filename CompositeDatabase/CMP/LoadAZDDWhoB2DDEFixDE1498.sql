-- ******************* PRODUCTION ENVIRONMENT *************************

-- Take a backup of coder_v1 (Takes approximately 2 hours)
-- Stop Mirroring

-- *** 1. Register the new/updated Stored Procedures ***
-- 1.a) CMP_11_FixMissingTermUpdatesAndImpactAnalysis.sql -- spCoder_CMP_011
-- 1.b) CMP_12_FixCategory5ForJpn.sql -- spCoder_CMP_012
-- 1.c) CMP_07_FixDictionaryName.sql -- spCoder_CMP_007
-- 1.c) spMedDictVerDiffEngTermV1_1.sql


-- *** 2. Fix DE1498 ***

EXEC spCoder_CMP_011 'MedDRA'
EXEC spCoder_CMP_011 'MedDRAMedHistory'

-- *** 3. Fix DE1505 ***
EXEC spCoder_CMP_012 'MedDRA'

-- *** 4. Rename AZDD ***
EXEC spCoder_CMP_007 'AZDD', 'AZDD_old'
delete from LocalizedStrings where  StringName='AZDD'


-- *** 5. Rename WhodrugB2 ***
EXEC spCoder_CMP_007 'WhoDrugB2', 'WhoDrugB2_old'
delete from LocalizedStrings where  StringName='WhoDrugB2'


-- Load AZDD 

--1) Please copy the zip files DictionaryCopy_AZDD_UpTo_March2012.rar and DictionaryCopy_WHODrug_DDE_B2.rar from S3 located at aws-mdsol-dev-software-installation-coder/DictionaryBackupsFullSets into D drive. 
--2) Right click on DictionaryCopy_AZDD_UpTo_March2012.rar zip file and click "Extract to DictionaryCopy_AZDD_UpTo_March2012\" 
--3) Right click on DictionaryCopy_WHODrug_DDE_B2.rar zip file and click "Extract to DictionaryCopy_WHODrug_DDE_B2\" 
--4) Use command line and change the directory to D:\DictionaryCopy_AZDD_UpTo_March2012
--5) If the DictImport db exists in the sql server databases. Please delete it.

--6) Run the Import script - (Approximate running time: 3 mins)
--	.\Import developer developer localhost 

--7) Run the HotUpdate script - (Approximate running time: 10 mins)
--  .\HotUpdate developer developer localhost

--8) Run FinalTransfer - (Approximate running time: 10 mins)

--  .\FinalTransfer developer developer localhost

--Load WhoDrugDDEB2

--9) Use command line and change the directory to D:\DictionaryCopy_WHODrug_DDE_B2

--10) If the DictImport db exists in the sql server databases. Please delete it.

--11) Run the Import script - (Approximate running time: 10 mins)
--	.\Import developer developer localhost 

--12) Run the HotUpdate script - (Approximate running time: 1 hour)
--  .\HotUpdate developer developer localhost

--13) Run FinalTransfer (Approximate running time: 1 hour)
--  .\FinalTransfer developer developer localhost

--14) Run CMP to fix dictionary name to WhoDrugDDEB2
-- EXEC spCoder_CMP_007 'WHODrug_DDE_B2', 'WhoDrugDDEB2'

--15) Recreate mirror in production


-- ******************* INNOVATE ENVIRONMENT ************************* 

-- Take a backup of coder_v1 (Takes approximately 2 hours)

-- *** 1. Register the new/updated Stored Procedures ***
-- 1.b) CMP_12_FixCategory5ForJpn.sql -- spCoder_CMP_012
-- 1.a) CMP_11_FixMissingTermUpdatesAndImpactAnalysis.sql -- spCoder_CMP_011
-- 1.c) CMP_07_FixDictionaryName.sql -- spCoder_CMP_007
-- 1.c) spMedDictVerDiffEngTermV1_1.sql


-- *** 2. Fix DE1498 ***
EXEC spCoder_CMP_011 'MedDRA'
EXEC spCoder_CMP_011 'MedDRAMedHistory'
EXEC spCoder_CMP_011 'MedDRASafety'


-- *** 3. Fix DE1505 ***
EXEC spCoder_CMP_012 'MedDRA'

-- *** 4. Rename AZDD ***
EXEC spCoder_CMP_007 'AZDD', 'AZDD_old'

-- *** 5. Rename WhodrugB2 ***
EXEC spCoder_CMP_007 'WhoDrugB2', 'WhoDrugB2_old'

-- Load AZDD 

--1) Please copy the zip files DictionaryCopy_AZDD_UpTo_March2012.rar and DictionaryCopy_WHODrug_DDE_B2.rar from S3 located at aws-mdsol-dev-software-installation-coder/DictionaryBackupsFullSets into D drive. 
--2) Right click on DictionaryCopy_AZDD_UpTo_March2012.rar zip file and click "Extract to DictionaryCopy_AZDD_UpTo_March2012\" 
--3) Right click on DictionaryCopy_WHODrug_DDE_B2.rar zip file and click "Extract to DictionaryCopy_WHODrug_DDE_B2\" 
--4) Use command line and change the directory to D:\DictionaryCopy_AZDD_UpTo_March2012
--5) If the DictImport db exists in the sql server databases. Please delete it.

--6) Run the Import script - (Approximate running time: 3 mins)
--	.\Import_Innovate developer developer localhost

--7) Run the HotUpdate script - (Approximate running time: 10 mins) 
--  .\HotUpdate_Innovate developer developer localhost

--8) Run FinalTransfer - (Approximate running time: 10 mins) 

--   .\FinalTransfer_Innovate developer developer localhost

--Load WhoDrugDDEB2

--9) Use command line and change the directory to D:\DictionaryCopy_WHODrug_DDE_B2

--10) If the DictImport db exists in the sql server databases. Please delete it.

--11) Run the Import script - (Approximate running time: 10 mins)
--	.\Import_Innovate developer developer localhost 

--12) Run the HotUpdate script - (Approximate running time: 1 hour) 
--  .\HotUpdate_Innovate developer developer localhost

--13) Run FinalTransfer - (Approximate running time: 1 hour) 
--  .\FinalTransfer_Innovate developer developer localhost

--14) Run CMP to fix dictionary name to WhoDrugDDEB2
-- EXEC spCoder_CMP_007 'WHODrug_DDE_B2', 'WhoDrugDDEB2'


