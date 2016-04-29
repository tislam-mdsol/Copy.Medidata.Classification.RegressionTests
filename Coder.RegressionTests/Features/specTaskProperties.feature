@specTaskProperties.feature
@CoderCore
Feature: This feature will verify that Coder will display Task Property & Assignments information for a term.

_ The following Task Property attributes are needed to be available to the client in order to obtain information about a term:

   Dictionary Property information   Source System Property information   Coding Status Property information
   _______________________________   __________________________________   __________________________________
   Medical Dictionary                Source System                        Coding Status
   Segment                           Locale                               Workflow
   Dictionary Level                  Study Name                           Creation Date
   Verbatim Term                     Connection URI                       Auto Code Date
   Priority                          File OID
   Locale                            Protocol Number
   UUID                              Protocol Name

  Segment: This refers to the client division/segment that contains coding data from a collection of studies; a Segment can be equated to an iMedidata Study Group which contains these studies.
  Dictionary Level: The level of the verbatim or EDC task submission.
  Verbatim Term: The verbatim text.
  Priority: [1_255] Priority is defined in Rave and can represent a "true" priority or can be a way to subset source data types. Priority is defined on the form level. For example, all Rave Adverse Events (AE) forms can be set to Priority 2, Rave Conmeds Priority 3, and Rave Medical History Terms Priority 4. You can also have all AEs, Conmeds, and Medical History Terms for one study set to Priority 1, and all AEs, Conmeds, and Medical History Terms for another study set to Priority 2. This number displays in the Task page in Coder for any verbatim term entered in this form. For example, if AE form =1, and the verbatim term "headache" is entered in this form, this number displays in the Task page for this verbatim term. Tip: The Priority field can be used to search for a form in Coder. This is a good way to determine what form the data is from. Make sure you are consistent with your numbering.
  UUID: A unique identifier for each verbatim task; only present for verbatim submitted from Rave 2013.4.0 sites and above.

  Study Name: The name of the verbatim term's study.
  Connection URI: The base url for source system.
  File OID: A source system submits terms to Coder through the transmission of ODM_XML formatted files, which contain the verbatim information. The File OID is the unique identifier for the request.
  Protocol Number: Maps to the iMedidata Protocol Number field. _ Coder 2015.1.0 does not sync this data after the initial data sync. *Coder DB _> ExternalObjectOID
  Protocol Name: Maps to the iMedidata field Protocol.          _ Coder 2015.1.0 does not sync this data after the initial data sync. *Coder DB _> ProtocolName

  Workflow: This is the configured Workflow of the system that determines system actions for verbatim terms. There is currently only one Workflow named default.
  Creation Date: Time term was sent from Rave. This time is slightly off from what the Rave Audit trail sent time, due to processing time.
  Auto Code Date: Time in which a verbatim task was coded.


_ Reference the coding help information residing in:
   https://learn.mdsol.com/display/CODERstg/Viewing+Coder+Transaction+Details+While+Coding?lang=en#ViewingCoderTransactionDetailsWhileCoding_ViewTaskProperties
   https://learn.mdsol.com/display/CODERstg/Viewing+Coder+Transaction+Details+While+Coding?lang=en#ViewingCoderTransactionDetailsWhileCoding_ViewTaskAssignments


_ The following environment configuration settings were enabled:

   Empty Synonym Lists Registered:
   Synonym List 1: MedDRA       (ENG) 15.0   Primary List

   Common Configurations:
   Configuration Name       | Force Primary Path Selection (MedDRA) | Synonym Creation Policy Flag | Bypass Reconsider Upon Reclassify | Default Select Threshold | Default Suggest Threshold | Auto Add Synonyms | Auto Approve | Term Requires Approval (IsApprovalRequired )  | Term Auto Approve with synonym (IsAutoApproval)   |
   Basic                    | TRUE                                  | Always Active                | TRUE                              | 100                      | 70                        | TRUE              | FALSE        | TRUE                                          | TRUE                                              |
   No Approval              | TRUE                                  | Always Active                | TRUE                              | 100                      | 70                        | TRUE              | FALSE        | FALSE                                         | TRUE                                              |
   Reconsider               | TRUE                                  | Always Active                | FALSE                             | 100                      | 70                        | TRUE              | FALSE        | TRUE                                          | TRUE                                              |


@VAL
@PBMCC_157109_001
@Release2015.3.0
Scenario: The following information will be available to the client as a term's Dictionary Property information:   Medical Dictionary, Segment, Priority, Locale, UUID

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  And coding task "Adverse Event Term 1" for dictionary level "LLT"
  When I view task "Adverse Event Term 1"
  Then I verify the following Medical Dictionary Property information is displayed
       | Medical Dictionary | Segment   | Dictionary Level | Verbatim Term        | Priority | Locale   | UUID             |
       | MedDRA - 15.0      | <Segment> | Low Level Term   | Adverse Event Term 1 | 1        | <Locale> | <CodingTermUuid> |


@VAL
@PBMCC_157109_002
@Release2015.3.0
Scenario: The following information will be available to the client as a term's Dictionary Property information:   Locale, Study Name, Connection URI, File OID, Protocol Number, Protocol Name

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  And coding task "Adverse Event Term 1" for dictionary level "LLT"
  When I view task "Adverse Event Term 1"
  Then I verify the following Source System Property information is displayed
       | Source System  | Locale   | Study Name  | Connection URI  | File OID  | Protocol Number  | Protocol Name |
       | <SourceSystem> | <Locale> | <StudyName> | <ConnectionUri> | <FileOid> | <ProtocolNumber> |               |


@VAL
@PBMCC_157109_003
@Release2015.3.0
Scenario:  Dictionary Property information will display the following options for a coding status:   Coding Status, Workflow, Creation Date, Auto Code Date

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  And coding task "Adverse Event Term 1" for dictionary level "LLT"
  When I view task "Adverse Event Term 1"
  Then I verify the following Coding Status Property information is displayed
       | Coding Status       | Workflow | Creation Date  | Auto Code Date |
       | Waiting Manual Code | Default  | <CreationDate> |                |


@VAL
@PBMCC_157109_004
@Release2015.3.0
Scenario: The following information will be available to the client as a term's Dictionary Property information for a status of Waiting Approval

  Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  And coding task "Toxic effect of venom" for dictionary level "LLT"
  When I view task "Toxic effect of venom"
  Then I verify the following Coding Status Property information is displayed
       | Coding Status    | Workflow | Creation Date  | Auto Code Date |
       | Waiting Approval | Default  | <CreationDate> | <AutoCodeDate> |


@VAL
@PBMCC_157109_005
@Release2015.3.0
Scenario: The following information will be available to the client as a term's Dictionary Property information for a status of Reconsider

  Given a "Reconsider" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  And coding task "Allergy to venom" for dictionary level "LLT"
  When reclassifying task "Allergy to venom" with a comment "Regression testing" and Include Autocoded Items set to "True"
  And I view task "Allergy to venom"
  Then I verify the following Coding Status Property information is displayed
       | Coding Status | Workflow | Creation Date  | Auto Code Date |
       | Reconsider    | Default  | <CreationDate> | <AutoCodeDate> |