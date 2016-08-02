@specMevUpload.feature
@CoderCore
Feature: This feature file verifies the functionality for Manage External Verbatim's CSV upload capabilities through the Manage External Verbatims page.

@VAL
@PBMCC_168481_001
@Release2015.3.0
Scenario: Verbatim Term information will be uploaded successfully in the system with a CSV file format and the corresponding task upload history will be displayed

	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 11.0"
	When the following externally managed verbatim requests are made
		| Verbatim Term              | Supplemental Field 1 | Supplemental Value 1 | Dictionary | Dictionary Level | Is Approval Required | Is Auto Approval |
		| Major Big Painful Headache | SupFieldA            | Sup1                 | MedDRA     | LLT              | FALSE                | TRUE             | 
	Then the coding task has the following information
		| Verbatim Term              |
		| MAJOR BIG PAINFUL HEADACHE |

@VAL
@PBMCC_168481_002
@Release2015.3.0
Scenario: Verify success message with file name is displayed on the Coder Success Alert
	
	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 11.0"
	When the following externally managed verbatim requests are made
		| Verbatim Term              | Supplemental Field 1 | Supplemental Value 1 | Dictionary | Dictionary Level | Is Approval Required | Is Auto Approval |
		| Major Big Painful Headache | SupFieldA            | Sup1                 | MedDRA     | LLT              | FALSE                | TRUE             |
	Then the user should be notified with the following message "Csv file <MevFileName> format validated. Starting task import."

@VAL
@PBMCC_168481_003
@Release2015.3.0
Scenario: Verify multiple csv files can be uploaded
	
	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
		| SynonymListName | Dictionary | Version | Locale |
		| Primary     | MedDRA         | 11.0    | ENG    |
		| Primary     | WhoDrugDDEB2   | 201506  | ENG    |
	When the following externally managed verbatim requests are made
		| Verbatim Term              | Dictionary | Dictionary Level | Is Approval Required | Is Auto Approval |
		| Major Big Painful Headache | MedDRA     | LLT              | FALSE                | TRUE             |
	And uploading MEV content
		| Verbatim Term                                                                   | Dictionary | Dictionary Level | Is Approval Required | Is Auto Approval |
		| Headache                                                                        | MedDRA     | LLT              | TRUE                 | FALSE            |
		| Allergy to Venom                                                                | MedDRA     | LLT              | TRUE                 | FALSE            |
		| "Acute gastrojejunal ulcer w/o mention of hem or perf, w/o ment of obstruction" | MedDRA     | LLT              | TRUE                 | FALSE            |
		| "Large Headache &#xD &#xA;"                                                     | MedDRA     | LLT              | TRUE                 | FALSE            |
		| "HEAD !@#$%^&#38;*()_+={}[]&lt;&gt;?;~\/*-&#96; PAIN"                           | MedDRA     | LLT              | TRUE                 | FALSE            |
		| "He'a'd "Pain""                                                                 | MedDRA     | LLT              | TRUE                 | FALSE            |
		| Russell's viper venom time normal                                               | MedDRA     | LLT              | TRUE                 | FALSE            |
		| Blood Builder                                                                   | MedDRA     | LLT              | TRUE                 | FALSE            |
		| SPIDER VENOM ANTISERUM                                                          | MedDRA     | LLT              | TRUE                 | FALSE            |
		| ABSENOR                            /00228501/                                   | MedDRA     | LLT              | TRUE                 | FALSE            |
		| "ACIDO !@#$%^&#38;*()_+={}[]&lt;&gt;?;~\/*-&#96; Vital"                         | MedDRA     | LLT              | TRUE                 | FALSE            |
		| APO IBUPROFEN                                                                   | MedDRA     | LLT              | TRUE                 | FALSE            |
		| 3-BENZHYDRYLOXY-8-ISOPROPYL-NORTROPAN MESILA.                                   | MedDRA     | LLT              | TRUE                 | FALSE            |
		| FERRANIN COMPLEX                                                                | MedDRA     | LLT              | TRUE                 | FALSE            |
	Then the uploaded coding tasks has the following information
		| File Name | Uploaded    | User              | Status           | Succeeded | Failed |
		| 2         | <TimeStamp> | <UserDisplayName> | Upload Completed | 14        | 0      |
		| 1         | <TimeStamp> | <UserDisplayName> | Upload Completed | 1         | 0      |
		

	
@VAL
@PBMCC_168481_004
@Release2015.3.0
Scenario: Verbatim Term supplemental information will be captured from the uploaded file
	
	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
		| SynonymListName | Dictionary   | Version | Locale |
		| Primary         | MedDRA       | 11.0    | ENG    |
		| Primary         | WhoDrugDDEB2 | 201506  | ENG    |
	When the following externally managed verbatim requests are made
		| Verbatim Term                                                                   | Supplemental Field 1 | Supplemental Value 1  | Supplemental Field 2 | Supplemental Value 2 | Supplemental Field 3 | Supplemental Value 3 | Supplemental Field 4 | Supplemental Value 4 | Supplemental Field 5 | Supplemental Value 5 | Dictionary | Dictionary Level | Is Approval Required | Is Auto Approval |
		| Headache                                                                        |                      |                       |                      |                      |                      |                      |                      |                      |                      |                      | MedDRA     | LLT              | TRUE                 | FALSE            |
		| Allergy to Venom                                                                | SupTermFieldA        | Sup Term Value 1      |                      |                      |                      |                      |                      |                      |                      |                      | MedDRA     | LLT              | TRUE                 | FALSE            |
		| "Acute gastrojejunal ulcer w/o mention of hem or perf, w/o ment of obstruction" | SupTermFieldA        | "Sup w/o obstruction" | SupTermFieldB        | Sup Term Value 2     |                      |                      |                      |                      |                      |                      | MedDRA     | LLT              | TRUE                 | FALSE            |
		| "Large Headache &#xD &#xA;"                                                     | SupTermFieldA        | Sup &#xD &#xA; Value  | SupTermFieldB        | " =lue2 "            | SupTermFieldC        | " Sup &#xDxA;"       |                      |                      |                      |                      | MedDRA     | LLT              | TRUE                 | FALSE            |
		| "HEAD !@#$%^&#38;*()_+={}[]&lt;&gt;?;~\/*-&#96; PAIN"                           | SupTermFieldA        | "Sup/*-&#96; PAIN"    | SupTermFieldB        | Sup Term Value 2     | SupTermFieldC        | Sup Term Value 3     | SupTermFieldD        | "Su*-&#96; PAIN"     |                      |                      | MedDRA     | LLT              | TRUE                 | FALSE            |
		| "He'a'd "Pain""                                                                 | SupTermFieldA        | "Sup He'a'd "Pain""   | SupTermFieldB        | Sup Term Value 2     | SupTermFieldC        | Sup Term Value 3     | SupTermFieldD        | Sup Term Value 4     | SupTermFieldE        | Sup Term Value 5     | MedDRA     | LLT              | TRUE                 | FALSE            |
		| Russell's viper venom time normal                                               |                      | MedDRA                |                      |                      | SupTermFieldC        | Sup Term Value 3     |                      |                      |                      |                      | MedDRA     | LLT              | TRUE                 | FALSE            |
		| Blood Builder                                                                   |                      | MedDRA                |                      |                      |                      |                      |                      |                      |                      |                      | MedDRA     | LLT              | TRUE                 | FALSE            |
		| SPIDER VENOM ANTISERUM                                                          | SupTermFieldA        | Sup Term Value 1      |                      |                      |                      |                      |                      |                      |                      |                      | MedDRA     | LLT              | TRUE                 | FALSE            |
		| ABSENOR                            /00228501/                                   | SupTermFieldA        | Sup Term Value 1      | SupTermFieldB        | Sup Term Value 2     |                      |                      |                      |                      |                      |                      | MedDRA     | LLT              | TRUE                 | FALSE            |
		| "ACIDO !@#$%^&#38;*()_+={}[]&lt;&gt;?;~\/*-&#96; Vital"                         | SupTermFieldA        | Sup Term Value 1      | SupTermFieldB        | Sup Term Value 2     |                      |                      |                      |                      |                      |                      | MedDRA     | LLT              | TRUE                 | FALSE            |
		| APO IBUPROFEN                                                                   | SupTermFieldA        | Sup Term Value 1      | SupTermFieldB        | Sup Term Value 2     | SupTermFieldC        | Sup Term Value 3     |                      |                      |                      |                      | MedDRA     | LLT              | TRUE                 | FALSE            |
		| 3-BENZHYDRYLOXY-8-ISOPROPYL-NORTROPAN MESILA.                                   | SupTermFieldA        | Sup Term Value 1      | SupTermFieldB        | Sup Term Value 2     | SupTermFieldC        | Sup Term Value 3     | SupTermFieldD        | Sup Term Value 4     | SupTermFieldE        | Sup Term Value 5     | MedDRA     | LLT              | TRUE                 | FALSE            |
		| FERRANIN COMPLEX                                                                |                      |                       |                      |                      | SupTermFieldC        | Sup Term Value 3     | SupTermFieldD        | Sup Term Value 4     | SupTermFieldE        | Sup Term Value 5     | MedDRA     | LLT              | TRUE                 | FALSE            |
	Then the "3-BENZHYDRYLOXY-8-ISOPROPYL-NORTROPAN MESILA." task has the following supplemental information
		| Term          | Value            |
		| SupTermFieldA | Sup Term Value 1 |
		| SupTermFieldB | Sup Term Value 2 |
		| SupTermFieldC | Sup Term Value 3 |
		| SupTermFieldD | Sup Term Value 4 |
		| SupTermFieldE | Sup Term Value 5 |
		
@DFT
@PBMCC_168481_005
@Release2015.3.0
#TODO:: This test needs to be update to verify that on the study report page, all of the tasks are in the correct status after the upload
Scenario: Japanese Verbatim Terms are able to be uploaded into the system in different statuses
 
	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
		| SynonymListName | Dictionary | Version | Locale |
		| Primary         | MedDRA     | 16.0    | JPN    |
		| Primary         | JDrug      | 2013H1  | JPN    |
	When  uploading MEV content and AutoCoding is complete
		| Verbatim Term																				| Dictionary | Dictionary Level | Is Approval Required | Is Auto Approval | Locale |
		| 適応障害ＮＯＳ																				| MedDRA     | LLT              | TRUE                 | TRUE             | jpn    |
		| ボレリア・ブルグドルフェリ免疫グロブリンＧ                                                   | MedDRA     | LLT              | TRUE                 | FALSE            | jpn    |
		| 体外回路内血液凝固                                           								| MedDRA     | LLT              | TRUE                 | FALSE            | jpn    |
		| """わたし &#xD &#xA;"""																	| MedDRA     | LLT              | TRUE                 | FALSE            | jpn    |
		| """エンテロバクター・アグロメランス感染 !@#$%^&#38;*()_+={}[]&lt;&gt;?;~\\/*-&#96; 日本語""" | MedDRA     | LLT              | TRUE                 | TRUE             | jpn    |
		| """あなた'アメリカ'簡単 ""ＦＢＳＳ"""""														| MedDRA     | LLT              | TRUE                 | FALSE            | jpn    |
		| 小児期崩壊性障害																			| MedDRA     | PT               | TRUE                 | FALSE            | jpn    |
		| アセチルコリン塩化物漢字ひらがなカタカナ万葉仮名変体仮名オㇹ oh								| JDrug      | DrugName         | TRUE                 | TRUE             | jpn    |
		| 治療を主目的としない医薬品																	| JDrug      | HighLevelClass   | TRUE                 | TRUE             | jpn    |
		| 公衆衛生用薬																				| JDrug      | MidLevelClass    | TRUE                 | FALSE            | jpn    |
		| """コカアルカロイド系製剤"""																| JDrug      | LowLevelClass    | TRUE                 | TRUE             | jpn    |
		| アヘンチンキ																				| JDrug      | DetailedClass    | TRUE                 | FALSE            | jpn    |
		| 内																							| JDrug      | DrugName         | TRUE                 | FALSE            | jpn    |
		| "ｱﾍﾝﾁﾝｷ"																					| JDrug      | DrugName         | TRUE                 | FALSE            | jpn    |
	Then the coding task has the following information
	    | Verbatim Term     											    |
	    | アセチルコリン塩化物漢字ひらがなカタカナ万葉仮名変体仮名オㇹ OH		|
	    | ボレリア・ブルグドルフェリ免疫グロブリンＧ							|
	    | 体外回路内血液凝固													|
	

@VAL
@PBMCC_168481_005a
@Release2015.3.0
Scenario: Japanese Supplemental information is able to be uploaded fine into the system
	
	Given a "Basic" Coder setup with no tasks and no synonyms and dictionaries
		| SynonymListName | Dictionary | Version | Locale |
		| Primary         | MedDRA     | 16.0    | JPN    |
		| Primary         | JDrug      | 2013H1  | JPN    |
	When  uploading MEV content
		| Verbatim Term																				| Supplemental Field 1 | Supplemental Value 1										 | Supplemental Field 2 | Supplemental Value 2						| Supplemental Field 3 | Supplemental Value 3											| Supplemental Field 4 | Supplemental Value 4 | Supplemental Field 5 | Supplemental Value 5 | Dictionary | Dictionary Level | Is Approval Required | Is Auto Approval | Locale |
		| 適応障害ＮＯＳ																				|                      |															 |                      |											|                      |																|                      |                      |                      |                      | MedDRA     | LLT              | TRUE                 | TRUE             | jpn    |
		| ボレリア・ブルグドルフェリ免疫グロブリンＧ                                                   | SupTermFieldA        | ブルグドルフェリ免疫グ										 |                      |											|                      |																|                      |                      |                      |                      | MedDRA     | LLT              | TRUE                 | FALSE            | jpn    |
		| """体外回路内血液凝固ㇰ ㇱ ㇲ ㇳ ㇴ ㇵ ㇶ ㇷ ㇸ ㇹ ㇺ ㇻ ㇼ ㇽ ㇾ ㇿ"""						| SupTermFieldA        | "Sブリ免疫グction"											 | SupTermFieldB        | アメリカ									|                      |																|                      |                      |                      |                      | MedDRA     | LLT              | FALSE                | TRUE             | jpn    |
		| """わたし &#xD &#xA;"""																	| SupTermFieldA        | ブtestグA; Value											 | SupTermFieldB        | ""  &#xD &#x								| SupTermFieldC        | " Sup &#xDxA;"													|                      |                      |                      |                      | MedDRA     | LLT              | FALSE                | FALSE            | jpn    |
		| """エンテロバクター・アグロメランス感染 !@#$%^&#38;*()_+={}[]&lt;&gt;?;~\\/*-&#96; 日本語""" | SupTermFieldA        | "8;*()_+={}[]&lt;"											 | SupTermFieldB        | Sup Term Value 2							| SupTermFieldC        | Sup Term Value 3												| SupTermFieldD        | "Su*-&#96; PAIN"     |                      |                      | MedDRA     | LLT              | TRUE                 | TRUE             | jpn    |
		| """あなた'アメリカ'簡単 ""ＦＢＳＳ"""""														| SupTermFieldA        | 8;*()_+={}[]&lt;											 | SupTermFieldB        | Sup Term Value 2							| SupTermFieldC        | Sup Term Value 3												| SupTermFieldD        | Sup Term Value 4     | SupTermFieldE        | Sup Term Value 5     | MedDRA     | LLT              | TRUE                 | FALSE            | jpn    |
		| 小児期崩壊性障害																			|                      |															 |						|											|                      |																| SupTermFieldC        | Sup Term Value 3     |                      |                      | MedDRA	 | PT               | TRUE                 | FALSE            | jpn    |
		| アセチルコリン塩化物漢字ひらがなカタカナ万葉仮名変体仮名オㇹ oh								|                      |															 |						|											|                      |																|                      |                      |                      |                      | JDrug		 | DrugName         | TRUE                 | TRUE             | jpn    |
		| 治療を主目的としない医薬品																	| SupTermFieldA        | Sup Term Value 1											 |                      |											|                      |																|                      |                      |                      |                      | JDrug      | HighLevelClass   | FALSE                | TRUE             | jpn    |
		| 公衆衛生用薬																				| SupTermFieldA        | Sup Term Value 1											 | SupTermFieldB        | Sup Term Value 2							|                      |																|                      |                      |                      |                      | JDrug      | MidLevelClass    | FALSE                | FALSE            | jpn    |
		| """コカアルカロイド系製剤"""																| SupTermFieldA        | Sup Term Value 1											 | SupTermFieldB        | Sup Term Value 2							|                      |																|                      |                      |                      |                      | JDrug      | LowLevelClass    | TRUE                 | TRUE             | jpn    |
		| アヘンチンキ																				| SupTermFieldA        | Sup Term Value 1											 | SupTermFieldB        | Sup Term Value 2							| SupTermFieldC        | Sup Term Value 3												|                      |                      |                      |                      | JDrug      | DetailedClass    | TRUE                 | FALSE            | jpn    |
		| 内																							| SupTermFieldA        | アセチルコリン塩化物漢字ひらがなカタカナ万葉仮名変体仮名オㇹ oh	 | SupTermFieldB        | ボレリア・ブルグドルフェリ免疫グロブリンＧ	| SupTermFieldC        | 体外回路内血液凝固ㇰ ㇱ ㇲ ㇳ ㇴ ㇵ ㇶ ㇷ ㇸ ㇹ ㇺ ㇻ ㇼ ㇽ ㇾ ㇿ	| SupTermFieldD        | Sup Term Value 4     | SupTermFieldE        | Sup Term Value 5     | JDrug      | DrugName         | TRUE                 | FALSE            | jpn    |
		| "ｱﾍﾝﾁﾝｷ"																					|                      |															 |                      |											| SupTermFieldC        | Sup Term Value 3												| SupTermFieldD        | Sup Term Value 4     | SupTermFieldE        | Sup Term Value 5     | JDrug      | DrugName         | TRUE                 | FALSE            | jpn    |
	Then the "内" task has the following supplemental information
		| Term				| Value																|
		| SupTermFieldA     | アセチルコリン塩化物漢字ひらがなカタカナ万葉仮名変体仮名オㇹ oh		|
		| SupTermFieldB     | ボレリア・ブルグドルフェリ免疫グロブリンＧ							|
		| SupTermFieldC     | 体外回路内血液凝固ㇰ ㇱ ㇲ ㇳ ㇴ ㇵ ㇶ ㇷ ㇸ ㇹ ㇺ ㇻ ㇼ ㇽ ㇾ ㇿ		|
 
@VAL
@PBMCC_168481_006
@Release2015.3.0
Scenario: An uploaded csv file can not surpass 5001 rows
	
	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "WhoDrugDDEB2 ENG 201506"
	When uploading "5002" WhoDrug tasks
	Then the user should be notified with the following message "CSV file <MevFileName> is too large to upload. The accepted file limit is 5001 rows."
	
@VAL
@PBMCC_168481_006a
@Release2015.3.0
Scenario: An uploaded csv file can not be larger than a file size of 40mb
	
	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 11.0"
	When uploading the external verbatim CSV file named "CrammedFile_41mb.csv"
	Then the user should be notified with the following message "CSV file CrammedFile_41mb.csv is too large to upload. The accepted file limit is 40MB."	
	
@VALLongRunningTask
@PBMCC_168481_006b
@Release2015.3.0
@IncreaseTimeout_2100000
Scenario: An uploaded 5000 task csv file is able to be uploaded and have uploaded coding tasks displayed

	Given a "Approval" Coder setup with no tasks and no synonyms and dictionary "WhoDrugDDEB2 ENG 201506"
	When uploading "5000" WhoDrug tasks
	Then the uploaded coding tasks has the following information
		| File Name | Uploaded    | User              | Status           | Succeeded | Failed |
		| 1         | <TimeStamp> | <UserDisplayName> | Upload Completed | 5000      | 0      |

	
@VALLongRunningTask
@PBMCC_168481_006c
@Release2015.3.0
@IncreaseTimeout_2100000
Scenario: An uploaded 5000 task csv file is able to be uploaded and have been processed by the workflow

	Given a "Approval" Coder setup with no tasks and no synonyms and dictionary "WhoDrugDDEB2 ENG 201506"
	When uploading "5000" WhoDrug tasks
	Then "5000" tasks are processed by the workflow
	
	
@VAL
@PBMCC_168481_007
@Release2015.3.0
@IncreaseTimeout_900000
Scenario: Upload history contains a downloadable csv file with error information for the failed tasks

	Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 11.0"
	When uploading incorrect MEV content
	Then the uploaded coding tasks has the following information
		| File Name | Uploaded    | User              | Status           | Succeeded | Failed |
		| 1         | <TimeStamp> | <UserDisplayName> | Upload Completed | 1         | 40     |
	When downloading MEV failure content
	Then the downloaded Mev error file should contain following
	| Study ID                            | Supplemental Field 1 | Supplemental Field 5 | Dictionary                | Dictionary Level     | Error                                                                       |
	| <DevStudyUuid>                      |                      |                      | MedDRA                    | SOC                  | Medical Dictionary Level is not codable                                     |
	| 00000000-1111-2222-3333-44444444444 |                      |                      | MedDRA                    | LLT                  | Study does Not Exist                                                        |
	| <DevStudyUuid>                      |                      |                      | MedDRA                    | Level Does Not Exist | Unknown error occurred                                                      |
	| Study Does Not Exist                |                      |                      | MedDRA                    | LLT                  | Study Does Not Exist                                                        |
	| <DevStudyUuid>                      |                      |                      | Dictionary Does Not Exist | LLT                  | Study must be registered                                                    |
	| <DevStudyUuid>                      |                      |                      | MedDRA                    | "LLT "               | Dictionary Level contains invalid leading or trailing spaces                |
	| <DevStudyUuid>                      |                      |                      | MedDRA                    | "LLT "               | Dictionary Level contains invalid leading or trailing spaces                |
	| <DevStudyUuid>                      |                      |                      | "MedDRA "                 | LLT                  | Dictionary contains invalid leading or trailing spaces                      |
	| <DevStudyUuid>                      | SupplementalFieldA   |                      | WhoDrugDDEB2              | PRODUCTSYNONYM       | Supplement Field OID must be unique                                         |
	| <StudyUuid>                         |                      | Supplemental Field 5 | MedDRA                    | LLT                  | Supplemental Field 5 is required to be alphanumeric with zero or one period |


@VAL
@PBMCC_168481_008
@Release2015.3.0
Scenario: Upload history will not process external verbatims for studies that are in the process of being migrated to new dictionary version

	Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 15.0 From_List" containing entry ""
    And an activated synonym list "MedDRA ENG 18.0 To_List"
	When performing limited study migration
	And uploading MEV content
		| Verbatim Term              | Supplemental Field 1 | Supplemental Value 1 | Dictionary | Dictionary Level | Is Approval Required | Is Auto Approval | 
		| Major Big Painful Headache | SupFieldA            | Sup1                 | MedDRA     | LLT              | FALSE                | TRUE             | 
	And downloading MEV failure content
	Then the downloaded Mev error file should contain following
		| Error                 |
		| Study is in migration |