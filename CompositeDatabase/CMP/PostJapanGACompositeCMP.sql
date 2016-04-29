-- *** 1. Register the new/updated Stored Procedures ***
-- 1.a) CMP_08_FixBadTermUpdatesAndImpactAnalysis.sql -- spCoder_CMP_008
-- 1.c) CMP_10_FixImpactAnalysisForNotFoundInNewVersion.sql -- spCoder_CMP_010

-- *** 2. Fix DE1468 ***
EXEC spCoder_CMP_008 'WHODrug_DDE_C' -- expected completion time 04:00:00


-- *** 3. Fix DE1490 ***

---- ** WHODrug_DDE_C **
EXEC spCoder_CMP_010 'WHODrug_DDE_C', '200906', 'eng' -- 156013  | 00:01:19
EXEC spCoder_CMP_010 'WHODrug_DDE_C', '200909', 'eng' -- 314422  | 00:01:31
EXEC spCoder_CMP_010 'WHODrug_DDE_C', '200912', 'eng' -- 476085  | 00:01:38
EXEC spCoder_CMP_010 'WHODrug_DDE_C', '201003', 'eng' -- 1045815  | 00:02:01
EXEC spCoder_CMP_010 'WHODrug_DDE_C', '201006', 'eng' -- 1272988  | 00:02:01
EXEC spCoder_CMP_010 'WHODrug_DDE_C', '201009', 'eng' -- 1505845  | 00:02:14
EXEC spCoder_CMP_010 'WHODrug_DDE_C', '201012', 'eng' -- 1740351  | 00:02:00
EXEC spCoder_CMP_010 'WHODrug_DDE_C', '201103', 'eng' -- 7334211  | 00:05:14
EXEC spCoder_CMP_010 'WHODrug_DDE_C', '201106', 'eng' -- 8519608  | 00:04:43
EXEC spCoder_CMP_010 'WHODrug_DDE_C', '201109', 'eng' -- 9706208  | 00:06:05
EXEC spCoder_CMP_010 'WHODrug_DDE_C', '201112', 'eng' -- 10896511  | 00:06:09

---- ** MedDRA **
EXEC spCoder_CMP_010 'MedDRA', '15.0', 'eng'

---- ** MedDRAMedHistory **
EXEC spCoder_CMP_010 'MedDRAMedHistory', '15.0', 'eng'

---- ** MedDRA/MedDRAJ **
EXEC spCoder_CMP_010 'MedDRA', '9.0', 'jpn'
EXEC spCoder_CMP_010 'MedDRA', '9.1', 'jpn'
EXEC spCoder_CMP_010 'MedDRA', '10.0', 'jpn'
EXEC spCoder_CMP_010 'MedDRA', '10.1', 'jpn'
EXEC spCoder_CMP_010 'MedDRA', '11.0', 'jpn'
EXEC spCoder_CMP_010 'MedDRA', '11.1', 'jpn'
EXEC spCoder_CMP_010 'MedDRA', '12.0', 'jpn'
EXEC spCoder_CMP_010 'MedDRA', '12.1', 'jpn'
EXEC spCoder_CMP_010 'MedDRA', '13.0', 'jpn'
EXEC spCoder_CMP_010 'MedDRA', '13.1', 'jpn'
EXEC spCoder_CMP_010 'MedDRA', '14.0', 'jpn'
EXEC spCoder_CMP_010 'MedDRA', '14.1', 'jpn'

---- ** JDrug **
EXEC spCoder_CMP_010 'JDrug', '2011H2', 'eng'
EXEC spCoder_CMP_010 'JDrug', '2011H2', 'jpn'

