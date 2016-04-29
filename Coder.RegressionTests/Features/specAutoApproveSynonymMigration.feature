@specAutoApproveSynonymMigration.feature
@CoderCore
Feature: This feature verifies synonym reconciliation during synonym list upgrades based on the user configurable options of the system.
The following truth table was used to help map the requirements to the cases.

 | Test Case        | 	Auto Approve | 	With Change | 	DDM Path    | 	Dictionary  || 	Included in Upversioning | 
 | PBMCC_197238_001 | 	On           | 	No          | 	Single path | 	MedDRA      || 	No                       | 
 | PBMCC_197238_002 | 	On           | 	SOC         | 	Single path | 	MedDRA      || 	Yes                      | 
 | PBMCC_197238_003 | 	On           | 	No          | 	Single path | 	Not MedDRA  || 	No                       | 
 | PBMCC_197238_004 | 	On           | 	ATC         | 	Single path | 	Not MedDRA  || 	Yes                      | 
 | PBMCC_197238_005 | 	Off          | 	No          | 	Single path | 	MedDRA      || 	No                       | 
 | PBMCC_197238_006 | 	Off          | 	SOC         | 	Single path | 	MedDRA      || 	Yes                      | 
 | PBMCC_197238_007 | 	Off          | 	No          | 	Single path | 	Not MedDRA  || 	No                       | 
 | PBMCC_197238_008 | 	Off          | 	ATC         | 	Single path | 	Not MedDRA  || 	Yes                      | 
 | PBMCC_197238_009 | 	On           | 	No          | 	Multi-path  | 	MedDRA      || 	No                       | 
 | PBMCC_197238_010 | 	On           | 	SOC         | 	Multi-path  | 	MedDRA      || 	Yes                      | 
 | PBMCC_197238_011 | 	On           | 	No          | 	Multi-path  | 	Not MedDRA  || 	No                       | 
 | PBMCC_197238_012 | 	On           | 	ATC         | 	Multi-path  | 	Not MedDRA  || 	Yes                      | 
 | PBMCC_197238_013 | 	Off          | 	No          | 	Multi-path  | 	MedDRA      || 	No                       | 
 | PBMCC_197238_014 | 	Off          | 	SOC         | 	Multi-path  | 	MedDRA      || 	Yes                      | 
 | PBMCC_197238_015 | 	Off          | 	No          | 	Multi-path  | 	Not MedDRA  || 	No                       | 
 | PBMCC_197238_016 | 	Off          | 	ATC         | 	Multi-path  | 	Not MedDRA  || 	Yes                      | 
                    

_ The following environment configuration settings were enabled:

   Empty Synonym Lists Registered:
   Synonym List 1: MedDRA             (ENG) 11.0     Initial_List
   Synonym List 2: MedDRA             (ENG) 12.0     Initial_List
   Synonym List 3: MedDRA             (ENG) 12.0     New_Primary_List
   Synonym List 4: MedDRA             (ENG) 13.0     New_Primary_List
   Synonym List 5: WhoDrugDDEB2       (ENG) 201009   Initial_List
   Synonym List 6: WhoDrugDDEB2       (ENG) 201212   Initial_List
   Synonym List 7: WhoDrugDDEB2       (ENG) 201012   New_Primary_List
   Synonym List 8: WhoDrugDDEB2       (ENG) 201303   New_Primary_List

   Common Configurations:
   Configuration Name       | Declarative Browser Class | 
   Basic                    | BasicSetup                | 

@VAL
@PBMCC_197238_001
@Release2015.3.0
@IncreaseTimeout_360000 
Scenario: When the Auto Approve option is "On", Single path MedDRA Direct Dictionary Match with no change shall not be taken into account during Synonym up-versioning.

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 11.0 Initial_List" containing entry "HEADACHE|10019211|LLT|LLT:10019211;PT:10019211;HLT:10019233;HLGT:10019231;SOC:10029205|True|||"
   And an unactivated synonym list "MedDRA ENG 12.0 New_Primary_List"
   When I configure dictionary "MedDRA" with "Auto Approve" set to "true"
   And starting synonym list migration
   Then synonym list migration is completed with "0" synonym and no reconciliation is needed
   And a synonym for verbatim term "HEADACHE" should be created and not exist in list "MedDRA ENG 12.0 New_Primary_List"

@VAL
@PBMCC_197238_002
@Release2015.3.0
@IncreaseTimeout_360000 
Scenario: When the Auto Approve option is "On", Single path MedDRA Direct Dictionary Match with a change shall be taken into account during Synonym up-versioning.

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 12.0 Initial_List" containing entry "Haemoglobinuria|10018906|LLT|LLT:10018906;PT:10018906;HLT:10000196;HLGT:10046590;SOC:10038359|TRUE|||"
   And an unactivated synonym list "MedDRA ENG 13.0 New_Primary_List"
   When I configure dictionary "MedDRA" with "Auto Approve" set to "true"
   And I perform a synonym migration accepting the reconciliation suggestion for the synonym "Haemoglobinuria" under the category "Multi Axiality Change"
   Then a synonym for verbatim term "Haemoglobinuria" should be created and not exist in list "MedDRA ENG 13.0 New_Primary_List"

@VAL
@PBMCC_197238_003
@Release2015.3.0
@IncreaseTimeout_360000 
Scenario: When the Auto Approve option is "On", Single path Direct Dictionary Match with no change shall not be taken into account during Synonym up-versioning.

   Given a "Basic" Coder setup with registered synonym list "WhoDrugDDEB2 ENG 201212 Initial_List" containing entry "TERRA PLANT SALVIA|068064 01 001|PRODUCT|PRODUCT:068064 01 001;ATC:A01A;ATC:A01;ATC:A|False|||"
   And an unactivated synonym list "WhoDrugDDEB2 ENG 201303 New_Primary_List"
   When I configure dictionary "WhoDrugDDEB2" with "Auto Approve" set to "true"
   And starting synonym list migration
   Then synonym list migration is completed with "0" synonym and no reconciliation is needed
   And a synonym for verbatim term "TERRA PLANT SALVIA" should be created and not exist in list "WhoDrugDDEB2 ENG 201303 New_Primary_List"

@VAL
@PBMCC_197238_004
@Release2015.3.0
@IncreaseTimeout_360000 
Scenario: When the Auto Approve option is "On", Single path Direct Dictionary Match with a change shall be taken into account during Synonym up-versioning.

   Given a "Basic" Coder setup with registered synonym list "WhoDrugDDEB2 ENG 201009 Initial_List" containing entry "CODEINE PHOSPHATE|000126 02 001|PRODUCT|PRODUCT:000126 02 001;ATC:R05DA;ATC:R05D;ATC:R05;ATC:R|False|||"
   And an unactivated synonym list "WhoDrugDDEB2 ENG 201303 New_Primary_List"
   When I configure dictionary "WhoDrugDDEB2" with "Auto Approve" set to "true"
   And I perform a synonym migration accepting the reconciliation suggestion for the synonym "CODEINE PHOSPHATE" under the category "No Clear Match"
   Then a synonym for verbatim term "CODEINE PHOSPHATE" should be created and not exist in list "WhoDrugDDEB2 ENG 201303 New_Primary_List"

@VAL
@PBMCC_197238_005
@Release2015.3.0
@IncreaseTimeout_360000 
Scenario: When the Auto Approve option is "Off", Single path MedDRA Direct Dictionary Match with no change shall not be taken into account during Synonym up-versioning.

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 12.0 Initial_List" containing entry "HEADACHE|10019211|LLT|LLT:10019211;PT:10019211;HLT:10019233;HLGT:10019231;SOC:10029205|True|||"
   And an unactivated synonym list "MedDRA ENG 13.0 New_Primary_List"
   When I configure dictionary "MedDRA" with "Auto Approve" set to "false"
   And starting synonym list migration
   Then synonym list migration is completed with "1" synonym and no reconciliation is needed
   And a synonym for verbatim term "HEADACHE" should be created and exist in list "MedDRA ENG 13.0 New_Primary_List"

@VAL
@PBMCC_197238_006
@Release2015.3.0
@IncreaseTimeout_360000 
Scenario: When the Auto Approve option is "Off", Single path MedDRA Direct Dictionary Match with a change shall be taken into account during Synonym up-versioning.

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 12.0 Initial_List" containing entry "Haemoglobinuria|10018906|LLT|LLT:10018906;PT:10018906;HLT:10000196;HLGT:10046590;SOC:10038359|TRUE|||"
   And an unactivated synonym list "MedDRA ENG 13.0 New_Primary_List"
   When I configure dictionary "MedDRA" with "Auto Approve" set to "false"
   And I perform a synonym migration accepting the reconciliation suggestion for the synonym "Haemoglobinuria" under the category "Multi Axiality Change"
   Then a synonym for verbatim term "Haemoglobinuria" should be created and exist in list "MedDRA ENG 13.0 New_Primary_List"

@VAL
@PBMCC_197238_007
@Release2015.3.0
@IncreaseTimeout_360000 
Scenario: When the Auto Approve option is "Off", Single path Direct Dictionary Match with no change shall not be taken into account during Synonym up-versioning.

   Given a "Basic" Coder setup with registered synonym list "WhoDrugDDEB2 ENG 201212 Initial_List" containing entry "TERRA PLANT SALVIA|068064 01 001|PRODUCT|PRODUCT:068064 01 001;ATC:A01A;ATC:A01;ATC:A|False|||"
   And an unactivated synonym list "WhoDrugDDEB2 ENG 201303 New_Primary_List"
   When I configure dictionary "WhoDrugDDEB2" with "Auto Approve" set to "false"
   And starting synonym list migration
   Then synonym list migration is completed with "1" synonym and no reconciliation is needed
   And a synonym for verbatim term "TERRA PLANT SALVIA" should be created and exist in list "WhoDrugDDEB2 ENG 201303 New_Primary_List"

@VAL
@PBMCC_197238_008
@Release2015.3.0
@IncreaseTimeout_360000 
Scenario: When the Auto Approve option is "Off", Single path Direct Dictionary Match with a change shall be taken into account during Synonym up-versioning.

   Given a "Basic" Coder setup with registered synonym list "WhoDrugDDEB2 ENG 201009 Initial_List" containing entry "CODEINE PHOSPHATE|000126 02 001|PRODUCT|PRODUCT:000126 02 001;ATC:R05DA;ATC:R05D;ATC:R05;ATC:R|False|||"
   And an unactivated synonym list "WhoDrugDDEB2 ENG 201303 New_Primary_List"
   When I configure dictionary "WhoDrugDDEB2" with "Auto Approve" set to "false"
   And I perform a synonym migration accepting the reconciliation suggestion for the synonym "CODEINE PHOSPHATE" under the category "No Clear Match"
   Then a synonym for verbatim term "CODEINE PHOSPHATE" should be created and exist in list "WhoDrugDDEB2 ENG 201303 New_Primary_List"
   
@VAL
@PBMCC_197238_009
@Release2015.3.0
@IncreaseTimeout_360000 
Scenario: When the Auto Approve option is "On", Multi-path MedDRA Direct Dictionary Match with no change shall not be taken into account during Synonym up-versioning.

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 12.0 Initial_List" containing entry "Cockayne's syndrome|10009835|LLT|LLT:10009835;PT:10009835;HLT:10029300;HLGT:10029299;SOC:10010331|TRUE|||"
   And an unactivated synonym list "MedDRA ENG 13.0 New_Primary_List"
   When I configure dictionary "MedDRA" with "Auto Approve" set to "true"
   And starting synonym list migration
   Then synonym list migration is completed with "0" synonym and no reconciliation is needed
   And a synonym for verbatim term "Cockayne's syndrome" should be created and not exist in list "MedDRA ENG 13.0 New_Primary_List"

@VAL
@PBMCC_197238_010
@Release2015.3.0
@IncreaseTimeout_360000 
Scenario: When the Auto Approve option is "On", Multi-path MedDRA Direct Dictionary Match with a change shall be taken into account during Synonym up-versioning.

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 12.0 Initial_List" containing entry "Kawasaki's disease|10023320|LLT|LLT:10023320;PT:10023320;HLT:10021982;HLGT:10002252;SOC:10021881|TRUE|||"
   And an unactivated synonym list "MedDRA ENG 13.0 New_Primary_List"
   When I configure dictionary "MedDRA" with "Auto Approve" set to "true"
   And I perform a synonym migration accepting the reconciliation suggestion for the synonym "Kawasaki's disease" under the category "Primary SOC Change"
   Then a synonym for verbatim term "Kawasaki's disease" should be created and not exist in list "MedDRA ENG 13.0 New_Primary_List"

@VAL
@PBMCC_197238_011
@Release2015.3.0
@IncreaseTimeout_360000 
Scenario: When the Auto Approve option is "On", Multi-path Direct Dictionary Match with no change shall not be taken into account during Synonym up-versioning.

   Given a "Basic" Coder setup with registered synonym list "WhoDrugDDEB2 ENG 201009 Initial_List" containing entry "PAIN|000277 04 191|PRODUCTSYNONYM|PRODUCTSYNONYM:000277 04 191;PRODUCT:000277 04 001;ATC:S01XA;ATC:S01X;ATC:S01;ATC:S|False|||"
   And an unactivated synonym list "WhoDrugDDEB2 ENG 201012 New_Primary_List"
   When I configure dictionary "WhoDrugDDEB2" with "Auto Approve" set to "true"
   And starting synonym list migration
   Then synonym list migration is completed with "1" synonym and no reconciliation is needed
   And a synonym for verbatim term "PAIN" should be created and exist in list "WhoDrugDDEB2 ENG 201012 New_Primary_List"

@VAL
@PBMCC_197238_012
@Release2015.3.0
@IncreaseTimeout_360000 
Scenario: When the Auto Approve option is "On", Multi-path Direct Dictionary Match with a change shall be taken into account during Synonym up-versioning.

   Given a "Basic" Coder setup with registered synonym list "WhoDrugDDEB2 ENG 201009 Initial_List" containing entry "KANA|003910 02 227|PRODUCTSYNONYM|PRODUCTSYNONYM:003910 02 227;PRODUCT:003910 02 001;ATC:D06AX;ATC:D06A;ATC:D06;ATC:D|False|||"
   And an unactivated synonym list "WhoDrugDDEB2 ENG 201303 New_Primary_List"
   When I configure dictionary "WhoDrugDDEB2" with "Auto Approve" set to "true"
   And I perform a synonym migration accepting the reconciliation suggestion for the synonym "KANA" under the category "No Clear Match"
   Then a synonym for verbatim term "KANA" should be created and exist in list "WhoDrugDDEB2 ENG 201303 New_Primary_List"

@VAL
@PBMCC_197238_013
@Release2015.3.0
@IncreaseTimeout_360000 
Scenario: When the Auto Approve option is "Off", Multi-path MedDRA Direct Dictionary Match with no change shall not be taken into account during Synonym up-versioning.

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 12.0 Initial_List" containing entry "Cockayne's syndrome|10009835|LLT|LLT:10009835;PT:10009835;HLT:10029300;HLGT:10029299;SOC:10010331|TRUE|||"
   And an unactivated synonym list "MedDRA ENG 13.0 New_Primary_List"
   When I configure dictionary "MedDRA" with "Auto Approve" set to "false"
   And starting synonym list migration
   Then synonym list migration is completed with "1" synonym and no reconciliation is needed
   And a synonym for verbatim term "Cockayne's syndrome" should be created and exist in list "MedDRA ENG 13.0 New_Primary_List"

@VAL
@PBMCC_197238_014
@Release2015.3.0
@IncreaseTimeout_360000 
Scenario: When the Auto Approve option is "Off", Multi-path MedDRA Direct Dictionary Match with a change shall be taken into account during Synonym up-versioning.

   Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 12.0 Initial_List" containing entry "Kawasaki's disease|10023320|LLT|LLT:10023320;PT:10023320;HLT:10021982;HLGT:10002252;SOC:10021881|TRUE|||"
   And an unactivated synonym list "MedDRA ENG 13.0 New_Primary_List"
   When I configure dictionary "MedDRA" with "Auto Approve" set to "false"
   And I perform a synonym migration accepting the reconciliation suggestion for the synonym "Kawasaki's disease" under the category "Primary SOC Change"
   Then a synonym for verbatim term "Kawasaki's disease" should be created and exist in list "MedDRA ENG 13.0 New_Primary_List"

@VAL
@PBMCC_197238_015
@Release2015.3.0
@IncreaseTimeout_360000 
Scenario: When the Auto Approve option is "Off", Multi-path Direct Dictionary Match with no change shall not be taken into account during Synonym up-versioning.

   Given a "Basic" Coder setup with registered synonym list "WhoDrugDDEB2 ENG 201009 Initial_List" containing entry "PAIN|000277 04 191|PRODUCTSYNONYM|PRODUCTSYNONYM:000277 04 191;PRODUCT:000277 04 001;ATC:S01XA;ATC:S01X;ATC:S01;ATC:S|False|||"
   And an unactivated synonym list "WhoDrugDDEB2 ENG 201012 New_Primary_List"
   When I configure dictionary "WhoDrugDDEB2" with "Auto Approve" set to "false"
   And starting synonym list migration
   Then synonym list migration is completed with "1" synonym and no reconciliation is needed
   And a synonym for verbatim term "PAIN" should be created and exist in list "WhoDrugDDEB2 ENG 201012 New_Primary_List"

@VAL
@PBMCC_197238_016
@Release2015.3.0
@IncreaseTimeout_360000 
Scenario: When the Auto Approve option is "Off", Multi-path Direct Dictionary Match with a change shall be taken into account during Synonym up-versioning.

   Given a "Basic" Coder setup with registered synonym list "WhoDrugDDEB2 ENG 201009 Initial_List" containing entry "KANA|003910 02 227|PRODUCTSYNONYM|PRODUCTSYNONYM:003910 02 227;PRODUCT:003910 02 001;ATC:D06AX;ATC:D06A;ATC:D06;ATC:D|False|||"
   And an unactivated synonym list "WhoDrugDDEB2 ENG 201303 New_Primary_List"
   When I configure dictionary "WhoDrugDDEB2" with "Auto Approve" set to "false"
   And I perform a synonym migration accepting the reconciliation suggestion for the synonym "KANA" under the category "No Clear Match"
   Then a synonym for verbatim term "KANA" should be created and exist in list "WhoDrugDDEB2 ENG 201303 New_Primary_List"
