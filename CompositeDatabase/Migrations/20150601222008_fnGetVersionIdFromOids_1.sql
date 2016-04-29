﻿IF object_id('fnGetVersionIdFromOids') IS NOT NULL
	DROP FUNCTION dbo.fnGetVersionIdFromOids
GO

CREATE FUNCTION [dbo].fnGetVersionIdFromOids
(
	 @Dictionary NVARCHAR(100),  
	 @Version  NVARCHAR(100)
)
RETURNS INT
AS
BEGIN

	DECLARE @versionId INT

	DECLARE @t TABLE(versionId INT, dictionaryid INT, dictionaryOid VARCHAR(50), versionOid VARCHAR(50))

insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	1	,	1	, 'MedDRA_Orig'	, '9.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	2	,	1	, 'MedDRA_Orig'	, '9.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	3	,	1	, 'MedDRA_Orig'	, '10.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	4	,	1	, 'MedDRA_Orig'	, '10.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	5	,	1	, 'MedDRA_Orig'	, '11.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	6	,	1	, 'MedDRA_Orig'	, '11.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	7	,	1	, 'MedDRA_Orig'	, '12.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	8	,	1	, 'MedDRA_Orig'	, '12.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	9	,	1	, 'MedDRA_Orig'	, '13.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	10	,	1	, 'MedDRA_Orig'	, '13.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	11	,	1	, 'MedDRA_Orig'	, '14.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	66	,	5	, 'MedDRAMedHistory_Orig'	, '9.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	67	,	5	, 'MedDRAMedHistory_Orig'	, '9.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	68	,	5	, 'MedDRAMedHistory_Orig'	, '10.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	69	,	5	, 'MedDRAMedHistory_Orig'	, '10.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	70	,	5	, 'MedDRAMedHistory_Orig'	, '11.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	71	,	5	, 'MedDRAMedHistory_Orig'	, '11.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	72	,	5	, 'MedDRAMedHistory_Orig'	, '12.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	73	,	5	, 'MedDRAMedHistory_Orig'	, '12.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	74	,	5	, 'MedDRAMedHistory_Orig'	, '13.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	75	,	5	, 'MedDRAMedHistory_Orig'	, '13.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	76	,	5	, 'MedDRAMedHistory_Orig'	, '14.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	102	,	1	, 'MedDRA_Orig'	, '14.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	107	,	5	, 'MedDRAMedHistory_Orig'	, '14.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	161	,	12	, 'JDrug_Orig'	, '2011H2')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	162	,	1	, 'MedDRA_Orig'	, '15.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	163	,	5	, 'MedDRAMedHistory_Orig'	, '15.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	166	,	14	, 'AZDD'	, '6.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	167	,	14	, 'AZDD'	, '6.2')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	168	,	14	, 'AZDD'	, '7.2')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	169	,	14	, 'AZDD'	, '7.3')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	170	,	14	, 'AZDD'	, '8.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	171	,	14	, 'AZDD'	, '8.3')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	172	,	14	, 'AZDD'	, '9.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	173	,	14	, 'AZDD'	, '9.2')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	174	,	14	, 'AZDD'	, '10.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	175	,	14	, 'AZDD'	, '10.2')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	176	,	14	, 'AZDD'	, '11.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	177	,	14	, 'AZDD'	, '11.2')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	178	,	14	, 'AZDD'	, '12.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	180	,	16	, 'WhoDrugDDEB2'	, '200603')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	181	,	16	, 'WhoDrugDDEB2'	, '200606')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	182	,	16	, 'WhoDrugDDEB2'	, '200609')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	183	,	16	, 'WhoDrugDDEB2'	, '200612')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	184	,	16	, 'WhoDrugDDEB2'	, '200703')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	185	,	16	, 'WhoDrugDDEB2'	, '200706')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	186	,	16	, 'WhoDrugDDEB2'	, '200709')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	187	,	16	, 'WhoDrugDDEB2'	, '200712')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	188	,	16	, 'WhoDrugDDEB2'	, '200803')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	189	,	16	, 'WhoDrugDDEB2'	, '200806')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	190	,	16	, 'WhoDrugDDEB2'	, '200809')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	191	,	16	, 'WhoDrugDDEB2'	, '200812')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	192	,	16	, 'WhoDrugDDEB2'	, '200903')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	193	,	16	, 'WhoDrugDDEB2'	, '200906')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	194	,	16	, 'WhoDrugDDEB2'	, '200909')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	195	,	16	, 'WhoDrugDDEB2'	, '200912')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	196	,	16	, 'WhoDrugDDEB2'	, '201003')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	197	,	16	, 'WhoDrugDDEB2'	, '201006')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	198	,	16	, 'WhoDrugDDEB2'	, '201009')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	199	,	16	, 'WhoDrugDDEB2'	, '201012')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	200	,	16	, 'WhoDrugDDEB2'	, '201103')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	201	,	16	, 'WhoDrugDDEB2'	, '201106')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	202	,	16	, 'WhoDrugDDEB2'	, '201109')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	203	,	16	, 'WhoDrugDDEB2'	, '201112')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	204	,	16	, 'WhoDrugDDEB2'	, '201203')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	206	,	18	, 'WhoDrugDDB2'	, '200603')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	207	,	18	, 'WhoDrugDDB2'	, '200606')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	208	,	18	, 'WhoDrugDDB2'	, '200609')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	209	,	18	, 'WhoDrugDDB2'	, '200612')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	210	,	18	, 'WhoDrugDDB2'	, '200703')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	211	,	18	, 'WhoDrugDDB2'	, '200706')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	212	,	18	, 'WhoDrugDDB2'	, '200709')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	213	,	18	, 'WhoDrugDDB2'	, '200712')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	214	,	18	, 'WhoDrugDDB2'	, '200803')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	215	,	18	, 'WhoDrugDDB2'	, '200806')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	216	,	18	, 'WhoDrugDDB2'	, '200809')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	217	,	18	, 'WhoDrugDDB2'	, '200812')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	218	,	18	, 'WhoDrugDDB2'	, '200903')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	219	,	18	, 'WhoDrugDDB2'	, '200906')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	220	,	18	, 'WhoDrugDDB2'	, '200909')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	221	,	18	, 'WhoDrugDDB2'	, '200912')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	222	,	18	, 'WhoDrugDDB2'	, '201003')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	223	,	18	, 'WhoDrugDDB2'	, '201006')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	224	,	18	, 'WhoDrugDDB2'	, '201009')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	225	,	18	, 'WhoDrugDDB2'	, '201012')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	226	,	18	, 'WhoDrugDDB2'	, '201103')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	227	,	18	, 'WhoDrugDDB2'	, '201106')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	228	,	18	, 'WhoDrugDDB2'	, '201109')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	229	,	18	, 'WhoDrugDDB2'	, '201112')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	230	,	18	, 'WhoDrugDDB2'	, '201203')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	232	,	20	, 'HD_DDE_B2'	, '200603')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	233	,	20	, 'HD_DDE_B2'	, '200606')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	234	,	20	, 'HD_DDE_B2'	, '200609')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	235	,	20	, 'HD_DDE_B2'	, '200612')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	236	,	20	, 'HD_DDE_B2'	, '200703')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	237	,	20	, 'HD_DDE_B2'	, '200706')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	238	,	20	, 'HD_DDE_B2'	, '200709')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	239	,	20	, 'HD_DDE_B2'	, '200712')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	240	,	20	, 'HD_DDE_B2'	, '200803')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	241	,	20	, 'HD_DDE_B2'	, '200806')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	242	,	20	, 'HD_DDE_B2'	, '200809')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	243	,	20	, 'HD_DDE_B2'	, '200812')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	244	,	20	, 'HD_DDE_B2'	, '200903')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	245	,	20	, 'HD_DDE_B2'	, '200906')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	246	,	20	, 'HD_DDE_B2'	, '200909')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	247	,	20	, 'HD_DDE_B2'	, '200912')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	248	,	20	, 'HD_DDE_B2'	, '201003')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	249	,	20	, 'HD_DDE_B2'	, '201006')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	250	,	20	, 'HD_DDE_B2'	, '201009')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	251	,	20	, 'HD_DDE_B2'	, '201012')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	252	,	20	, 'HD_DDE_B2'	, '201103')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	253	,	20	, 'HD_DDE_B2'	, '201106')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	254	,	20	, 'HD_DDE_B2'	, '201109')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	255	,	20	, 'HD_DDE_B2'	, '201112')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	256	,	20	, 'HD_DDE_B2'	, '201203')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	258	,	22	, 'WhoDrugDDC'	, '200603')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	259	,	22	, 'WhoDrugDDC'	, '200606')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	260	,	22	, 'WhoDrugDDC'	, '200609')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	261	,	22	, 'WhoDrugDDC'	, '200612')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	262	,	22	, 'WhoDrugDDC'	, '200703')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	263	,	22	, 'WhoDrugDDC'	, '200706')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	264	,	22	, 'WhoDrugDDC'	, '200709')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	265	,	22	, 'WhoDrugDDC'	, '200712')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	266	,	22	, 'WhoDrugDDC'	, '200803')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	267	,	22	, 'WhoDrugDDC'	, '200806')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	268	,	22	, 'WhoDrugDDC'	, '200809')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	269	,	22	, 'WhoDrugDDC'	, '200812')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	270	,	22	, 'WhoDrugDDC'	, '200903')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	271	,	22	, 'WhoDrugDDC'	, '200906')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	272	,	22	, 'WhoDrugDDC'	, '200909')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	273	,	22	, 'WhoDrugDDC'	, '200912')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	274	,	22	, 'WhoDrugDDC'	, '201003')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	275	,	22	, 'WhoDrugDDC'	, '201006')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	276	,	22	, 'WhoDrugDDC'	, '201009')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	277	,	22	, 'WhoDrugDDC'	, '201012')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	278	,	22	, 'WhoDrugDDC'	, '201103')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	279	,	22	, 'WhoDrugDDC'	, '201106')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	280	,	22	, 'WhoDrugDDC'	, '201109')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	281	,	22	, 'WhoDrugDDC'	, '201112')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	282	,	22	, 'WhoDrugDDC'	, '201203')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	284	,	24	, 'WHODrug_DDE_C'	, '200603')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	285	,	24	, 'WHODrug_DDE_C'	, '200606')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	286	,	24	, 'WHODrug_DDE_C'	, '200609')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	287	,	24	, 'WHODrug_DDE_C'	, '200612')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	288	,	24	, 'WHODrug_DDE_C'	, '200703')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	289	,	24	, 'WHODrug_DDE_C'	, '200706')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	290	,	24	, 'WHODrug_DDE_C'	, '200709')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	291	,	24	, 'WHODrug_DDE_C'	, '200712')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	292	,	24	, 'WHODrug_DDE_C'	, '200803')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	293	,	24	, 'WHODrug_DDE_C'	, '200806')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	294	,	24	, 'WHODrug_DDE_C'	, '200809')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	295	,	24	, 'WHODrug_DDE_C'	, '200812')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	296	,	24	, 'WHODrug_DDE_C'	, '200903')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	297	,	24	, 'WHODrug_DDE_C'	, '200906')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	298	,	24	, 'WHODrug_DDE_C'	, '200909')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	299	,	24	, 'WHODrug_DDE_C'	, '200912')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	300	,	24	, 'WHODrug_DDE_C'	, '201003')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	301	,	24	, 'WHODrug_DDE_C'	, '201006')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	302	,	24	, 'WHODrug_DDE_C'	, '201009')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	303	,	24	, 'WHODrug_DDE_C'	, '201012')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	304	,	24	, 'WHODrug_DDE_C'	, '201103')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	305	,	24	, 'WHODrug_DDE_C'	, '201106')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	306	,	24	, 'WHODrug_DDE_C'	, '201109')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	307	,	24	, 'WHODrug_DDE_C'	, '201112')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	308	,	24	, 'WHODrug_DDE_C'	, '201203')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	309	,	22	, 'WhoDrugDDC'	, '201206')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	310	,	18	, 'WhoDrugDDB2'	, '201206')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	311	,	20	, 'HD_DDE_B2'	, '201206')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	312	,	24	, 'WHODrug_DDE_C'	, '201206')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	313	,	16	, 'WhoDrugDDEB2'	, '201206')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	314	,	12	, 'JDrug_Orig'	, '2012H1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	315	,	14	, 'AZDD'	, '12.2')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	316	,	1	, 'MedDRA_Orig'	, '15.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	317	,	5	, 'MedDRAMedHistory_Orig'	, '15.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	318	,	16	, 'WhoDrugDDEB2'	, '201209')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	319	,	22	, 'WhoDrugDDC'	, '201209')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	320	,	18	, 'WhoDrugDDB2'	, '201209')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	321	,	20	, 'HD_DDE_B2'	, '201209')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	322	,	24	, 'WHODrug_DDE_C'	, '201209')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	323	,	16	, 'WhoDrugDDEB2'	, '201212')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	324	,	18	, 'WhoDrugDDB2'	, '201212')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	325	,	22	, 'WhoDrugDDC'	, '201212')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	326	,	20	, 'HD_DDE_B2'	, '201212')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	327	,	24	, 'WHODrug_DDE_C'	, '201212')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	329	,	26	, 'MedDRA'	, '9.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	330	,	26	, 'MedDRA'	, '9.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	331	,	26	, 'MedDRA'	, '10.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	332	,	26	, 'MedDRA'	, '10.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	333	,	26	, 'MedDRA'	, '11.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	334	,	26	, 'MedDRA'	, '11.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	335	,	26	, 'MedDRA'	, '12.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	336	,	26	, 'MedDRA'	, '12.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	337	,	26	, 'MedDRA'	, '13.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	338	,	26	, 'MedDRA'	, '13.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	339	,	26	, 'MedDRA'	, '14.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	340	,	26	, 'MedDRA'	, '14.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	341	,	26	, 'MedDRA'	, '15.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	342	,	26	, 'MedDRA'	, '15.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	343	,	27	, 'JDrug'	, '2011H1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	344	,	27	, 'JDrug'	, '2011H2')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	345	,	27	, 'JDrug'	, '2012H1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	346	,	28	, 'MedDRAMedHistory'	, '9.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	347	,	28	, 'MedDRAMedHistory'	, '9.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	348	,	28	, 'MedDRAMedHistory'	, '10.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	349	,	28	, 'MedDRAMedHistory'	, '10.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	350	,	28	, 'MedDRAMedHistory'	, '11.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	351	,	28	, 'MedDRAMedHistory'	, '11.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	352	,	28	, 'MedDRAMedHistory'	, '12.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	353	,	28	, 'MedDRAMedHistory'	, '12.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	354	,	28	, 'MedDRAMedHistory'	, '13.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	355	,	28	, 'MedDRAMedHistory'	, '13.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	356	,	28	, 'MedDRAMedHistory'	, '14.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	357	,	28	, 'MedDRAMedHistory'	, '14.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	358	,	28	, 'MedDRAMedHistory'	, '15.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	359	,	28	, 'MedDRAMedHistory'	, '15.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	360	,	26	, 'MedDRA'	, '16.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	361	,	28	, 'MedDRAMedHistory'	, '16.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	362	,	14	, 'AZDD'	, '13.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	363	,	27	, 'JDrug'	, '2012H2')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	364	,	16	, 'WhoDrugDDEB2'	, '201303')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	365	,	18	, 'WhoDrugDDB2'	, '201303')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	366	,	20	, 'HD_DDE_B2'	, '201303')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	367	,	24	, 'WHODrug_DDE_C'	, '201303')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	368	,	22	, 'WhoDrugDDC'	, '201303')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	369	,	27	, 'JDrug'	, '2013H1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	370	,	18	, 'WhoDrugDDB2'	, '201306')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	371	,	16	, 'WhoDrugDDEB2'	, '201306')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	372	,	20	, 'HD_DDE_B2'	, '201306')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	373	,	24	, 'WHODrug_DDE_C'	, '201306')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	374	,	22	, 'WhoDrugDDC'	, '201306')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	375	,	26	, 'MedDRA'	, '16.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	376	,	28	, 'MedDRAMedHistory'	, '16.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	377	,	24	, 'WHODrug_DDE_C'	, '201309')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	378	,	22	, 'WhoDrugDDC'	, '201309')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	379	,	20	, 'HD_DDE_B2'	, '201309')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	380	,	18	, 'WhoDrugDDB2'	, '201309')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	381	,	16	, 'WhoDrugDDEB2'	, '201309')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	382	,	14	, 'AZDD'	, '13.2')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	383	,	27	, 'JDrug'	, '2013H2')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	384	,	20	, 'HD_DDE_B2'	, '201312')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	385	,	22	, 'WhoDrugDDC'	, '201312')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	386	,	16	, 'WhoDrugDDEB2'	, '201312')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	387	,	18	, 'WhoDrugDDB2'	, '201312')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	388	,	24	, 'WHODrug_DDE_C'	, '201312')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	389	,	29	, 'WhoDrugHDDDEC'	, '200603')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	390	,	29	, 'WhoDrugHDDDEC'	, '200606')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	391	,	29	, 'WhoDrugHDDDEC'	, '200609')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	392	,	29	, 'WhoDrugHDDDEC'	, '200612')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	393	,	29	, 'WhoDrugHDDDEC'	, '200703')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	394	,	29	, 'WhoDrugHDDDEC'	, '200706')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	395	,	29	, 'WhoDrugHDDDEC'	, '200709')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	396	,	29	, 'WhoDrugHDDDEC'	, '200712')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	397	,	29	, 'WhoDrugHDDDEC'	, '200803')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	398	,	29	, 'WhoDrugHDDDEC'	, '200806')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	399	,	29	, 'WhoDrugHDDDEC'	, '200809')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	400	,	29	, 'WhoDrugHDDDEC'	, '200812')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	401	,	29	, 'WhoDrugHDDDEC'	, '200903')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	402	,	29	, 'WhoDrugHDDDEC'	, '200906')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	403	,	29	, 'WhoDrugHDDDEC'	, '200909')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	404	,	29	, 'WhoDrugHDDDEC'	, '200912')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	405	,	29	, 'WhoDrugHDDDEC'	, '201003')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	406	,	29	, 'WhoDrugHDDDEC'	, '201006')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	407	,	29	, 'WhoDrugHDDDEC'	, '201009')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	408	,	29	, 'WhoDrugHDDDEC'	, '201012')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	409	,	29	, 'WhoDrugHDDDEC'	, '201103')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	410	,	29	, 'WhoDrugHDDDEC'	, '201106')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	411	,	29	, 'WhoDrugHDDDEC'	, '201109')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	412	,	29	, 'WhoDrugHDDDEC'	, '201112')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	413	,	29	, 'WhoDrugHDDDEC'	, '201203')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	414	,	29	, 'WhoDrugHDDDEC'	, '201206')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	415	,	29	, 'WhoDrugHDDDEC'	, '201209')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	416	,	29	, 'WhoDrugHDDDEC'	, '201212')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	417	,	29	, 'WhoDrugHDDDEC'	, '201303')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	418	,	29	, 'WhoDrugHDDDEC'	, '201306')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	419	,	29	, 'WhoDrugHDDDEC'	, '201309')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	420	,	29	, 'WhoDrugHDDDEC'	, '201312')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	421	,	14	, 'AZDD'	, '14.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	422	,	20	, 'HD_DDE_B2'	, '201403')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	423	,	26	, 'MedDRA'	, '17.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	424	,	28	, 'MedDRAMedHistory'	, '17.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	425	,	24	, 'WHODrug_DDE_C'	, '201403')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	426	,	18	, 'WhoDrugDDB2'	, '201403')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	427	,	22	, 'WhoDrugDDC'	, '201403')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	428	,	16	, 'WhoDrugDDEB2'	, '201403')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	429	,	29	, 'WhoDrugHDDDEC'	, '201403')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	430	,	16	, 'WhoDrugDDEB2'	, '201406')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	431	,	18	, 'WhoDrugDDB2'	, '201406')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	432	,	20	, 'HD_DDE_B2'	, '201406')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	433	,	22	, 'WhoDrugDDC'	, '201406')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	434	,	24	, 'WHODrug_DDE_C'	, '201406')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	435	,	29	, 'WhoDrugHDDDEC'	, '201406')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	436	,	27	, 'JDrug'	, '2014H1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	437	,	26	, 'MedDRA'	, '17.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	438	,	28	, 'MedDRAMedHistory'	, '17.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	439	,	20	, 'HD_DDE_B2'	, '201409')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	440	,	24	, 'WHODrug_DDE_C'	, '201409')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	441	,	16	, 'WhoDrugDDEB2'	, '201409')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	442	,	14	, 'AZDD'	, '14.2')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	443	,	22	, 'WhoDrugDDC'	, '201409')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	444	,	18	, 'WhoDrugDDB2'	, '201409')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	445	,	18	, 'WhoDrugDDB2'	, '201412')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	446	,	16	, 'WhoDrugDDEB2'	, '201412')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	447	,	22	, 'WhoDrugDDC'	, '201412')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	448	,	24	, 'WHODrug_DDE_C'	, '201412')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	449	,	20	, 'HD_DDE_B2'	, '201412')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	450	,	27	, 'JDrug'	, '2014H2')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	451	,	29	, 'WhoDrugHDDDEC'	, '201409')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	452	,	29	, 'WhoDrugHDDDEC'	, '201412')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	453	,	26	, 'MedDRA'	, '18.0')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	454	,	16	, 'WhoDrugDDEB2'	, '201503')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	455	,	20	, 'HD_DDE_B2'	, '201503')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	456	,	14	, 'AZDD'	, '15.1')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	457	,	18	, 'WhoDrugDDB2'	, '201503')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	458	,	24	, 'WHODrug_DDE_C'	, '201503')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	459	,	22	, 'WhoDrugDDC'	, '201503')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	460	,	29	, 'WhoDrugHDDDEC'	, '201503')
insert into @t(versionId, dictionaryid, dictionaryOid, versionOid)
values(	461	,	28	, 'MedDRAMedHistory'	, '18.0')

	SELECT @versionId = versionId
	FROM @t
	WHERE dictionaryOid = @Dictionary
		AND versionOid = @Version

	RETURN @versionId

END