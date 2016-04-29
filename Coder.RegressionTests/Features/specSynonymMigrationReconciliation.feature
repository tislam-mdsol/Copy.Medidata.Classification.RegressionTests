@specSynonymMigrationReconciliation.feature
@CoderCore
Feature: This feature file will verify the basic synonym migration features for suggestion generation and reconciliation

  Whenever you upgrade synonym lists and there is a change between the source and target dictionary versions, you have to use the Reconcile page to specify
  how you want to manage the differences. You must do this even if the differences do not affect the current verbatim/dictionary mapping. You must reconcile
  all issues before you can complete the synonym migration process

  https://learn.mdsol.com/display/CODERstg/Migrating+and+Managing+Synonym+Lists?lang=en

  Synonym Migration Categories:

  1] Clear Match: The synonym will automatically be migrated, given there was no change to the synonym or its alternative coding paths. Clear matches will not appear to be reconciled.

  2] Multi Axiality Change: The synonym will require manual reconciliation, given the term has more than 1 path and the alternative paths have changed yet not the main path

  3] Primary SOC Path Change: The synonym will require manual reconciliation, given (only applicable to MedDRA) the Primary path has changed.

  4] Path Does Not Exist: Synonym will require manual reconciliation, given the code path of a term has changed.

  5] No Match: The synonym will require manual reconciliation, given there is not matching path or (only applicable to MedDRA) the Lowest Level Term code changed from Current Term to a Non-Current Term

  6] No Clear Match: The synonym will require manual reconciliation, given Term text has changed or (only applicable to MedDRA) changed from Non-Current Term to Current Term.


The following environment configuration settings were enabled:

   Common Configurations:
     Configuration Name       | Force Primary Path Selection (MedDRA) | Synonym Creation Policy Flag | Bypass Reconsider Upon Reclassify | Default Select Threshold | Default Suggest Threshold | Auto Add Synonyms | Auto Approve | Term Requires Approval (IsApprovalRequired )  | Term Auto Approve with synonym (IsAutoApproval)   |
     Basic                    | TRUE                                  | Always Active                | TRUE                              | 100                      | 70                        | TRUE              | FALSE        | TRUE                                          | TRUE                                              |
     No Enforced Primary Path | FALSE                                 | Always Active                | TRUE                              | 100                      | 70                        | TRUE              | FALSE        | TRUE                                          | TRUE                                              |


@VAL
@Release2015.3.0
@PBMCC_168577_001
@IncreaseTimeout
Scenario: A synonym migration for a new dictionary version can be migrated from an empty new synonym list

  Given a "Basic" Coder setup with an empty registered synonym list "MedDRA ENG 11.0 Empty_List" 
  And an unactivated synonym list "MedDRA ENG 12.0 New_Primary_List"
  When starting synonym list migration
  Then synonym list migration is completed with "0" synonym and no reconciliation is needed


@VAL
@Release2015.3.0
@PBMCC_168577_002
@IncreaseTimeout
Scenario: A synonym migration with a Clear Match synonym will automatically be migrated, given there was no change to the synonym or its alternative coding paths

  Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 11.0 Clear_Match" containing entry "HEADACHE|10019211|LLT|LLT:10019211;PT:10019211;HLT:10019233;HLGT:10019231;SOC:10029205|True|AE.AECAT:OTHER|Approved|Headache"
  And an unactivated synonym list "MedDRA ENG 12.0 New_Primary_List"
  When starting synonym list migration
  Then synonym list migration is completed with "1" synonym and no reconciliation is needed


@VAL
@Release2015.3.0
@PBMCC_168577_003
@IncreaseTimeout
Scenario: A synonym migration with a Primary SOC Path Change synonym will require manual reconciliation, given (only applicable to MedDRA) the Primary path has changed.

  Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 15.0 Path Does Not Exist_MedDRA" containing entry "Hypo Activity|10020934|LLT|LLT:10020934;PT:10011953;HLT:10011975;HLGT:10008401;SOC:10037175|True||Approved|HYPOACTIVITY"
  And an unactivated synonym list "MedDRA ENG 18.0 New_Primary_List"
  When starting synonym list migration
  Then reconciliation is needed for the synonym "Hypo Activity" under the category "Primary SOC Change" with "1" synonym(s) not migrated


@VAL
@Release2015.3.0
@PBMCC_168577_004
@IncreaseTimeout
Scenario: A synonym migration with a No Clear Match synonym will require manual reconciliation, when the code term text has changed.

  Given a "Basic" Coder setup with registered synonym list "WhoDrugDDEB2 ENG 200703 No Clear Match_WhoDrug" containing entry "Core Drug 01|012848 01 007|PRODUCTSYNONYM|PRODUCTSYNONYM:012848 01 007;PRODUCT:012848 01 001;ATC:C09DA;ATC:C09D;ATC:C09;ATC:C|False||Approved|COZAAREX D"
  And an unactivated synonym list "WhoDrugDDEB2 ENG 200709 New_Primary_List"
  When starting synonym list migration
  Then reconciliation is needed for the synonym "Core Drug 01" under the category "No Clear Match" with "1" synonym(s) not migrated

@VAL
@Release2015.3.0
@PBMCC_168577_004
@IncreaseTimeout
Scenario: A synonym migration with a Path Does Not Exist synonym will require manual reconciliation, given the code path of a term has changed.

  Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 11.0 Path Does Not Exist_MedDRA" containing entry "PAIN WHILE WALKING|10014860|LLT|LLT:10014860;PT:10014860;HLT:10018013;HLGT:10017998;SOC:10042613|True||Approved|Enterectomy"
  And an unactivated synonym list "MedDRA ENG 12.0 New_Primary_List"
  When starting synonym list migration
  Then reconciliation is needed for the synonym "PAIN WHILE WALKING" under the category "Path Does Not Exist" with "1" synonym(s) not migrated


@VAL
@Release2015.3.0
@PBMCC_168577_005
@IncreaseTimeout
Scenario: A synonym migration with a No Match synonym will require manual reconciliation, given (only applicable to MedDRA) the Lowest Level Term code changed from Current Term to a Non-Current Term, and Coder will display no data for synonym migration term change details and suggestions given the is no matching current entries.

  Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 15.0 No_Match" containing entry "ARMS TINGLE|10000378|PT|PT:10000378;HLT:10064292;HLGT:10064289;SOC:10022117|True||Approved|Extensive limb swelling"
  And an unactivated synonym list "MedDRA ENG 18.0 New_Primary_List"
  When starting synonym list migration
  Then reconciliation is needed for the synonym "ARMS TINGLE" under the category "No Match" with "1" synonym(s) declined
  And the No Match synonym "ARMS TINGLE" has no suggested term data present


@VAL
@Release2015.3.0
@PBMCC_168577_006
@IncreaseTimeout
Scenario: A synonym migration with a Primary SOC Path Change synonym will require manual reconciliation, given (only applicable to MedDRA) all alternative paths of a dictionary term are the same, yet its primary path indication has changed.

  Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 15.0 Primary_SOC" containing entry "Eyelid Problems|10064976|LLT|LLT:10064976;PT:10034544;HLT:10027674;HLGT:10022114;SOC:10022117|True||Approved|EYELID HAEMATOMA"
  And an unactivated synonym list "MedDRA ENG 18.0 New_Primary_List"
  When starting synonym list migration
  Then reconciliation is needed for the synonym "Eyelid Problems" under the category "Primary SOC Change" with "1" synonym(s) not migrated


@VAL
@Release2015.3.0
@PBMCC_168577_007
@IncreaseTimeout
Scenario: A synonym migration with a Multi Axiality Change synonym will require manual reconciliation, given the term has more than 1 path and the alternative paths have changed but not the main path

  Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 15.0 Multi_Axiality" containing entry "Broken Face Bone|10006388|LLT|LLT:10006388;PT:10023149;HLT:10040961;HLGT:10005942;SOC:10022117|True||Approved|Broken jaw"
  And an unactivated synonym list "MedDRA ENG 16.0 New_Primary_List"
  When starting synonym list migration
  Then reconciliation is needed for the synonym "Broken Face Bone" under the category "Multi Axiality Change" with "1" synonym(s) not migrated


@VAL
@Release2015.3.0
@PBMCC_168577_008
@IncreaseTimeout
Scenario: A synonym migration with a No Clear Match synonym will require manual reconciliation, given Term text has changed.

  Given a "Basic" Coder setup with registered synonym list "MedDRA JPN 15.1 No_Clear_Match" containing entry "社会不安障害|10041242|LLT|LLT:10041242;PT:10041250;HLT:10068299;HLGT:10002861;SOC:10037175|True||Approved|社会不安障害"
  And an unactivated synonym list "MedDRA JPN 16.0 New_Primary_List"
  When starting synonym list migration
  Then reconciliation is needed for the synonym "社会不安障害" under the category "No Clear Match" with "1" synonym(s) not migrated


@VAL
@Release2015.3.0
@PBMCC_168577_009
@IncreaseTimeout_360000
Scenario: A synonym migration with a Path Does Not Exist synonym can have a suggestion accepted for migration due to a primary path change

  Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 11.0 Path Does Not Exist_MedDRA" containing entry "PAIN WHILE WALKING|10014860|LLT|LLT:10014860;PT:10014860;HLT:10018013;HLGT:10017998;SOC:10042613|True||Approved|Enterectomy"
  And an unactivated synonym list "MedDRA ENG 12.0 New_Primary_List"
  When starting synonym list migration
  And accepting the reconciliation suggestion for the synonym "PAIN WHILE WALKING" under the category "Path Does Not Exist"
  And completing synonym migration
  Then the synonym "PAIN WHILE WALKING" with code "10014860" exists after synonym migration is completed


@VAL
@Release2015.3.0
@PBMCC_168577_010
@IncreaseTimeout
Scenario: A synonym migration with a Path Does Not Exist synonym can have a suggestion accepted for migration due to single path change

  Given a "Basic" Coder setup with registered synonym list "WhoDrugDDEB2 ENG 201309 Path Does Not Exist_WhoDrug" containing entry "Core Drug 01|009177 01 001|PRODUCT|PRODUCT:009177 01 001;ATC:V03AX;ATC:V03A;ATC:V03;ATC:V|False||Approved|COZAAREX D"
  And an unactivated synonym list "WhoDrugDDEB2 ENG 201403 New_Primary_List"
  When starting synonym list migration
  And accepting the reconciliation suggestion for the synonym "Core Drug 01" under the category "Path Does Not Exist"
  And completing synonym migration
  Then the synonym "Core Drug 01" with code "009177 01 001" exists after synonym migration is completed


@VAL
@Release2015.3.0
@PBMCC_168577_011
@IncreaseTimeout
Scenario: A synonym migration with a No Match synonym will not keep the synonym after migration.

  Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 15.0 No_Match" containing entry "ARMS TINGLE|10000378|PT|PT:10000378;HLT:10064292;HLGT:10064289;SOC:10022117|True||Approved|Extensive limb swelling"
  And an unactivated synonym list "MedDRA ENG 18.0 New_Primary_List"
  When starting synonym list migration
  And completing synonym migration
  Then the synonym "ARMS TINGLE" does not exist after synonym migration is completed


@VAL
@Release2015.3.0
@PBMCC_168577_012
@IncreaseTimeout
Scenario: A synonym migration with a Primary SOC Change synonym can have a suggestion accepted for migration

  Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 15.0 Primary_SOC" containing entry "Tear Term|10014472|LLT|LLT:10014472;PT:10016674;HLT:10028914;HLGT:10019381;SOC:10021881|True||Approved|Meniscus tear"
  And an unactivated synonym list "MedDRA ENG 18.0 New_Primary_List"
  When starting synonym list migration
  And accepting the reconciliation suggestion for the synonym "Tear Term" under the category "Primary SOC Change"
  And completing synonym migration
  Then the synonym "Tear Term" with code "10014472" exists after synonym migration is completed


@VAL
@Release2015.3.0
@PBMCC_168577_013
@IncreaseTimeout
Scenario: A synonym migration with a Multi Axiality Change synonym can have a suggestion accepted for migration

  Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 15.0 Multi_Axiality" containing entry "Broken Face Bone|10006388|LLT|LLT:10006388;PT:10023149;HLT:10040961;HLGT:10005942;SOC:10022117|True||Approved|Broken jaw"
  And an unactivated synonym list "MedDRA ENG 16.0 New_Primary_List"
  When starting synonym list migration
  And accepting the reconciliation suggestion for the synonym "Broken Face Bone" under the category "Multi Axiality Change"
  And completing synonym migration
  Then the synonym "Broken Face Bone" with code "10006388" exists after synonym migration is completed


@VAL
@Release2015.3.0
@PBMCC_168577_014
@IncreaseTimeout
Scenario: A synonym migration with a No Clear Match synonym can have a suggestion accepted for migration

  Given a "Basic" Coder setup with registered synonym list "MedDRA JPN 15.1 No_Clear_Match" containing entry "社会不安障害|10041242|LLT|LLT:10041242;PT:10041250;HLT:10068299;HLGT:10002861;SOC:10037175|True||Approved|社会不安障害"
  And an unactivated synonym list "MedDRA JPN 16.0 New_Primary_List"
  When starting synonym list migration
  And accepting the reconciliation suggestion for the synonym "社会不安障害" under the category "No Clear Match"
  And completing synonym migration
  Then the synonym "社会不安障害" with code "10041242" exists after synonym migration is completed


@VAL
@Release2015.3.0
@PBMCC_168577_015
@IncreaseTimeout
Scenario: During synonym reconciliation a synonym can be dropped from Not Migrated section and declined

  Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 15.0 With_Synonym" containing entry "Tear Term|10072105|LLT|LLT:10072105;PT:10053777;HLT:10027686;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear"
  And an unactivated synonym list "MedDRA ENG 16.0 New_Primary_List"
  When starting synonym list migration
  And dropping the reconciliation suggestion for the synonym "Tear Term" under the category "Path Does Not Exist"
  Then the synonym "Tear Term" falls under the category "Path Does Not Exist" with "1" synonym(s) declined
  When completing synonym migration
  Then the synonym "Tear Term" does not exist after synonym migration is completed


@VAL
@Release2015.3.0
@PBMCC_168577_016
@IncreaseTimeout
Scenario: During synonym reconciliation a synonym that was dropped can still be accepted for migration

  Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 15.0 With_Synonym" containing entry "Tear Term|10072105|LLT|LLT:10072105;PT:10053777;HLT:10027686;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear"
  And an unactivated synonym list "MedDRA ENG 16.0 New_Primary_List"
  When starting synonym list migration
  And dropping the reconciliation suggestion for the synonym "Tear Term" under the category "Path Does Not Exist"
  And accepting the declined synonym "Tear Term" under the category "Path Does Not Exist"
  Then the synonym "Tear Term" falls under the category "Path Does Not Exist" with "1" synonym(s) migrated
  When completing synonym migration
  Then the synonym "Tear Term" with code "10072105" exists after synonym migration is completed


@VAL
@Release2015.3.0
@PBMCC_168577_017
@IncreaseTimeout
Scenario: During synonym reconciliation, containing a category with multiple synonyms, when a synonym is dropped only 1 synonym is declined

  Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 15.0 With_Multiple_Synonyms" containing entry "Tear Term|10072105|LLT|LLT:10072105;PT:10053777;HLT:10027686;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Broken Face Bone|10006388|LLT|LLT:10006388;PT:10023149;HLT:10040961;HLGT:10005942;SOC:10022117|True||Approved|Broken jaw"
  And an unactivated synonym list "MedDRA ENG 16.0 New_Primary_List"
  When starting synonym list migration
  And dropping the reconciliation suggestion for the synonym "Tear Term" under the category "Path Does Not Exist"
  Then the synonym "Tear Term" falls under the category "Path Does Not Exist" with "1" synonym(s) declined
  And the synonym "Broken Face Bone" falls under the category "Multi Axiality Change" with "1" synonym(s) not migrated


@VAL
@Release2015.3.0
@PBMCC_168577_020
@IncreaseTimeout_900000
Scenario: During synonym reconciliation, containing a category with multiple synonyms with the configuration option Force Primary Path enabled, a user can select Accept New Version For All to accept all primary path suggestions

  Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 15.0 With_Multiple_Synonyms" containing entry "Tear Term|10072105|LLT|LLT:10072105;PT:10053777;HLT:10027686;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Broken Face Bone|10017097|LLT|LLT:10017097;PT:10016450;HLT:10024957;HLGT:10005942;SOC:10022117|True||Approved|Broken jaw"
  And an unactivated synonym list "MedDRA ENG 18.0 New_Primary_List"
  When starting synonym list migration
  And accepting the reconciliation suggestions for all the new synonym versions
  Then all synonyms are ready for migration


@VAL
@Release2015.3.0
@PBMCC_168577_021
@IncreaseTimeout_900000
Scenario: During synonym reconciliation, containing a category with multiple synonyms with the configuration option Force Primary Path disabled, a user can select Accept All Suggestions to accept only single path suggestions

  Given a "No Enforced Primary Path" Coder setup with registered synonym list "MedDRA ENG 15.0 With_Multiple_Synonyms" containing entry "Tear Term|10019911|LLT|LLT:10019911;PT:10060954;HLT:10000072;HLGT:10000073;SOC:10017947|True||Approved|Meniscus tear~Broken Face Bone|10009588|LLT|LLT:10009588;PT:10039579;HLT:10046293;HLGT:10005942;SOC:10022117|True||Approved|Broken jaw"
  And an unactivated synonym list "MedDRA ENG 18.0 New_Primary_List"
  When starting synonym list migration
  And accepting the reconciliation suggestions for all the new synonym versions
  Then the single path synonym "Tear Term" under the category "Path Does Not Exist" is ready for migration
  And the non-single path synonym "Broken Face Bone" under the category "Path Does Not Exist" is not ready for migration

  
@VAL
@Release2015.3.0
@PBMCC_168577_021
@IncreaseTimeout_900000
Scenario: During synonym reconciliation, containing a category with multiple synonyms with the configuration option, a user can select Accept All Suggestions to accept only single path suggestions

  Given a "Basic" Coder setup with registered synonym list "WhoDrugDDEB2 ENG 201309 MultipleSynonyms" containing entry "Tear Term|009177 01 001|PRODUCT|PRODUCT:009177 01 001;ATC:V03AX;ATC:V03A;ATC:V03;ATC:V|False||Approved|COZAAREX D~Broken Face Bone|000217 01 001|PRODUCT|PRODUCT:000217 01 001;ATC:N02CA;ATC:N02C;ATC:N02;ATC:N|False||Approved|COZAAREX D"
  And an unactivated synonym list "WhoDrugDDEB2 ENG 201403 NewList"
  When starting synonym list migration
  And accepting the reconciliation suggestions for all the new synonym versions
  Then the single path synonym "Tear Term" under the category "Path Does Not Exist" is ready for migration
  And the non-single path synonym "Broken Face Bone" under the category "Multi Axiality Change" is not ready for migration


@VAL
@Release2015.3.0
@PBMCC_168577_022
@IncreaseTimeout
Scenario: During synonym reconciliation, a synonym that has multiple level changes, the system will display each line difference in the Prior Term Path, Upgraded Term Path, and Suggested Term Path

  Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 15.0 With_Synonym" containing entry "Tear Term|10029922|LLT|LLT:10029922;PT:10056390;HLT:10026907;HLGT:10026906;SOC:10036585|True||Approved|Meniscus tear"
  And an unactivated synonym list "MedDRA ENG 18.0 New_Primary_List"
  When starting synonym list migration
  Then the synonym "Tear Term" under the category "Primary SOC Change" has a line difference for each changed level in the Prior Term and Upgraded Term Path
  And the synonym "Tear Term" under the category "Primary SOC Change" has a line difference for each changed level in the Prior Term and Suggested Term Path

@VAL
@Release2015.3.0
@PBMCC_74551_023_a
@IncreaseTimeout_900000
Scenario: During synonym reconciliation, containing a category with twenty synonyms, a user can Accept fifteen synonym suggestions, drop five suggestions, and the system will display each in the migration column

  Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 15.0 With_Synonym" containing entry "Tear Term|10058730|LLT|LLT:10058730;PT:10058730;HLT:10003057;HLGT:10001316;SOC:10018065|True||Approved|Meniscus tear~Broken Face Bone|10009589|LLT|LLT:10009589;PT:10049946;HLT:10041574;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Tired Eyes|10059450|LLT|LLT:10059450;PT:10059450;HLT:10062916;HLGT:10046828;SOC:10038604|True||Approved|Meniscus tear~Liver Damage|10016475|LLT|LLT:10016475;PT:10016845;HLT:10008429;HLGT:10027664;SOC:10010331|True||Approved|Meniscus tear~Fractured Collarbone|10049164|LLT|LLT:10049164;PT:10049164;HLT:10041574;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Stomach Issues|10028248|LLT|LLT:10028248;PT:10028245;HLT:10052785;HLGT:10012303;SOC:10029205|True||Approved|Meniscus tear~Hunger Pains|10003025|LLT|LLT:10003025;PT:10061428;HLT:10003022;HLGT:10003018;SOC:10027433|True||Approved|Meniscus tear~Speaking Problems|10041471|LLT|LLT:10041471;PT:10041466;HLT:10041460;HLGT:10029305;SOC:10029205|True||Approved|Meniscus tear~Foot Problems|10000596|LLT|LLT:10000596;PT:10000596;HLT:10040834;HLGT:10040789;SOC:10010331|True||Approved|Meniscus tear~Seeing Stars|10003052|LLT|LLT:10003052;PT:10059005;HLT:10003057;HLGT:10001316;SOC:10018065|True||Approved|Meniscus tear~Back Pains|10049953|LLT|LLT:10049953;PT:10049946;HLT:10041574;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Stomach Tear|10034430|LLT|LLT:10034430;PT:10017815;HLT:10017847;HLGT:10018027;SOC:10017947|True||Approved|Meniscus tear~Rib Fracture|10050149|LLT|LLT:10050149;PT:10039117;HLT:10043467;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Sore Tongue|10043989|LLT|LLT:10043989;PT:10057371;HLT:10031021;HLGT:10031013;SOC:10017947|True||Approved|Meniscus tear~Bone Bruise|10064210|LLT|LLT:10064210;PT:10064210;HLT:10027677;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Adverse Event|10009591|LLT|LLT:10009591;PT:10049946;HLT:10041574;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Jaw Shattered|10028249|LLT|LLT:10028249;PT:10023149;HLT:10040961;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Eyes Rolling|10066681|LLT|LLT:10066681;PT:10046851;HLT:10022953;HLGT:10021877;SOC:10015919|True||Approved|Meniscus tear~Collapsed Lung|10022612|LLT|LLT:10022612;PT:10022611;HLT:10033979;HLGT:10024967;SOC:10038738|True||Approved|Meniscus tear~Fungus Appearing|10066200|LLT|LLT:10066200;PT:10060876;HLT:10038431;HLGT:10038360;SOC:10010331|True||Approved|Meniscus tear"
  And an unactivated synonym list "MedDRA ENG 18.0 New_Primary_List"
  When starting synonym list migration
  And accepting the reconciliation suggestion for "15" synonyms under the category "Multi Axiality Change"
  And dropping the reconciliation suggestion for "5" synonyms under the category "Multi Axiality Change"
  Then the synonyms fall under the category "Multi Axiality Change" with "15" synonym(s) migrated
  And the synonyms fall under the category "Multi Axiality Change" with "5" synonym(s) declined

@VAL
@Release2015.3.0
@PBMCC_74551_023_b
@IncreaseTimeout_900000
Scenario: During synonym reconciliation, containing a category with twenty synonyms, a user can drop fifteen synonyms that are ready for migration

  Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 15.0 With_Synonym" containing entry "Tear Term|10058730|LLT|LLT:10058730;PT:10058730;HLT:10003057;HLGT:10001316;SOC:10018065|True||Approved|Meniscus tear~Broken Face Bone|10009589|LLT|LLT:10009589;PT:10049946;HLT:10041574;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Tired Eyes|10059450|LLT|LLT:10059450;PT:10059450;HLT:10062916;HLGT:10046828;SOC:10038604|True||Approved|Meniscus tear~Liver Damage|10016475|LLT|LLT:10016475;PT:10016845;HLT:10008429;HLGT:10027664;SOC:10010331|True||Approved|Meniscus tear~Fractured Collarbone|10049164|LLT|LLT:10049164;PT:10049164;HLT:10041574;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Stomach Issues|10028248|LLT|LLT:10028248;PT:10028245;HLT:10052785;HLGT:10012303;SOC:10029205|True||Approved|Meniscus tear~Hunger Pains|10003025|LLT|LLT:10003025;PT:10061428;HLT:10003022;HLGT:10003018;SOC:10027433|True||Approved|Meniscus tear~Speaking Problems|10041471|LLT|LLT:10041471;PT:10041466;HLT:10041460;HLGT:10029305;SOC:10029205|True||Approved|Meniscus tear~Foot Problems|10000596|LLT|LLT:10000596;PT:10000596;HLT:10040834;HLGT:10040789;SOC:10010331|True||Approved|Meniscus tear~Seeing Stars|10003052|LLT|LLT:10003052;PT:10059005;HLT:10003057;HLGT:10001316;SOC:10018065|True||Approved|Meniscus tear~Back Pains|10049953|LLT|LLT:10049953;PT:10049946;HLT:10041574;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Stomach Tear|10034430|LLT|LLT:10034430;PT:10017815;HLT:10017847;HLGT:10018027;SOC:10017947|True||Approved|Meniscus tear~Rib Fracture|10050149|LLT|LLT:10050149;PT:10039117;HLT:10043467;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Sore Tongue|10043989|LLT|LLT:10043989;PT:10057371;HLT:10031021;HLGT:10031013;SOC:10017947|True||Approved|Meniscus tear~Bone Bruise|10064210|LLT|LLT:10064210;PT:10064210;HLT:10027677;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Adverse Event|10009591|LLT|LLT:10009591;PT:10049946;HLT:10041574;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Jaw Shattered|10028249|LLT|LLT:10028249;PT:10023149;HLT:10040961;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Eyes Rolling|10066681|LLT|LLT:10066681;PT:10046851;HLT:10022953;HLGT:10021877;SOC:10015919|True||Approved|Meniscus tear~Collapsed Lung|10022612|LLT|LLT:10022612;PT:10022611;HLT:10033979;HLGT:10024967;SOC:10038738|True||Approved|Meniscus tear~Fungus Appearing|10066200|LLT|LLT:10066200;PT:10060876;HLT:10038431;HLGT:10038360;SOC:10010331|True||Approved|Meniscus tear"
  And an unactivated synonym list "MedDRA ENG 18.0 New_Primary_List"
  When starting synonym list migration
  And accepting the reconciliation suggestions for all the new synonym versions
  And dropping "15" migrated synonyms under the category "Multi Axiality Change"
  Then the synonyms fall under the category "Multi Axiality Change" with "15" synonym(s) declined
  And the synonyms fall under the category "Multi Axiality Change" with "5" synonym(s) migrated

@VAL
@Release2015.3.0
@PBMCC_74551_023_c
@IncreaseTimeout_900000
Scenario: During synonym reconciliation, containing a category with twenty synonyms, a user can accept fifteen synonyms that were dropped

  Given a "Basic" Coder setup with registered synonym list "MedDRA ENG 15.0 With_Synonym" containing entry "Tear Term|10058730|LLT|LLT:10058730;PT:10058730;HLT:10003057;HLGT:10001316;SOC:10018065|True||Approved|Meniscus tear~Broken Face Bone|10009589|LLT|LLT:10009589;PT:10049946;HLT:10041574;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Tired Eyes|10059450|LLT|LLT:10059450;PT:10059450;HLT:10062916;HLGT:10046828;SOC:10038604|True||Approved|Meniscus tear~Liver Damage|10016475|LLT|LLT:10016475;PT:10016845;HLT:10008429;HLGT:10027664;SOC:10010331|True||Approved|Meniscus tear~Fractured Collarbone|10049164|LLT|LLT:10049164;PT:10049164;HLT:10041574;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Stomach Issues|10028248|LLT|LLT:10028248;PT:10028245;HLT:10052785;HLGT:10012303;SOC:10029205|True||Approved|Meniscus tear~Hunger Pains|10003025|LLT|LLT:10003025;PT:10061428;HLT:10003022;HLGT:10003018;SOC:10027433|True||Approved|Meniscus tear~Speaking Problems|10041471|LLT|LLT:10041471;PT:10041466;HLT:10041460;HLGT:10029305;SOC:10029205|True||Approved|Meniscus tear~Foot Problems|10000596|LLT|LLT:10000596;PT:10000596;HLT:10040834;HLGT:10040789;SOC:10010331|True||Approved|Meniscus tear~Seeing Stars|10003052|LLT|LLT:10003052;PT:10059005;HLT:10003057;HLGT:10001316;SOC:10018065|True||Approved|Meniscus tear~Back Pains|10049953|LLT|LLT:10049953;PT:10049946;HLT:10041574;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Stomach Tear|10034430|LLT|LLT:10034430;PT:10017815;HLT:10017847;HLGT:10018027;SOC:10017947|True||Approved|Meniscus tear~Rib Fracture|10050149|LLT|LLT:10050149;PT:10039117;HLT:10043467;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Sore Tongue|10043989|LLT|LLT:10043989;PT:10057371;HLT:10031021;HLGT:10031013;SOC:10017947|True||Approved|Meniscus tear~Bone Bruise|10064210|LLT|LLT:10064210;PT:10064210;HLT:10027677;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Adverse Event|10009591|LLT|LLT:10009591;PT:10049946;HLT:10041574;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Jaw Shattered|10028249|LLT|LLT:10028249;PT:10023149;HLT:10040961;HLGT:10005942;SOC:10022117|True||Approved|Meniscus tear~Eyes Rolling|10066681|LLT|LLT:10066681;PT:10046851;HLT:10022953;HLGT:10021877;SOC:10015919|True||Approved|Meniscus tear~Collapsed Lung|10022612|LLT|LLT:10022612;PT:10022611;HLT:10033979;HLGT:10024967;SOC:10038738|True||Approved|Meniscus tear~Fungus Appearing|10066200|LLT|LLT:10066200;PT:10060876;HLT:10038431;HLGT:10038360;SOC:10010331|True||Approved|Meniscus tear"
  And an unactivated synonym list "MedDRA ENG 18.0 New_Primary_List"
  When starting synonym list migration
  And accepting the reconciliation suggestions for all the new synonym versions
  And dropping "20" migrated synonyms under the category "Multi Axiality Change"
  And accepting "15" declined synonyms under the category "Multi Axiality Change"
  Then the synonyms fall under the category "Multi Axiality Change" with "15" synonym(s) migrated
  And the synonyms fall under the category "Multi Axiality Change" with "5" synonym(s) declined


@VAL
@Release2015.3.0
@PBMCC_37232_001_a
@IncreaseTimeout
Scenario: During synonym reconciliation for JDrug english, a term during synonym migration will reconcile to the No Clear Match category

  Given a "Basic" Coder setup with registered synonym list "JDrug ENG 2011H2 With_Synonym" containing entry "Adverse Event 1|2649717|DrugName|DrugName:2649717;Category:6;PreferredName:2649717;DetailedClass:2649;LowLevelClass:264;MidLevelClass:26;HighLevelClass:2|False||Approved|Adverse Event 1"
  And an unactivated synonym list "JDrug ENG 2014H2 New_Primary_List"
  When starting synonym list migration
  Then the synonym "Adverse Event 1" falls under the category "No Clear Match" with "1" synonym(s) not migrated


@VAL
@Release2015.3.0
@PBMCC_37232_001_b
@IncreaseTimeout
Scenario: During synonym reconciliation for JDrug japanese, a term during synonym migration will not need reconiliation

  Given a "Basic" Coder setup with registered synonym list "JDrug JPN 2011H2 With_Synonym" containing entry "んの咳|2649717|DrugName|DrugName:2649717;Category:6;PreferredName:2649717;DetailedClass:2649;LowLevelClass:264;MidLevelClass:26;HighLevelClass:2|False||Approved|んの咳"
  And an unactivated synonym list "JDrug JPN 2014H2 New_Primary_List"
  When starting synonym list migration
  Then synonym list migration is completed with "1" synonym and no reconciliation is needed