@specTaskSourceTerm.feature
@CoderCore
Feature: This feature will verify that Coder will display Source information on a term.

- The following source term attributes are needed to be available to the client in order to obtain information about a term:

   Source information   Source Coding information   EDC information   Component information   Supplemental information
   ------------------   -------------------------   ---------------   ---------------------   ------------------------
   Source System        Dictionary                  Field             Component Name          Supplemental Name
   Study                Locale                      Line              Component Value         Supplemental Value
                        Priority                    Form
                        Level                       Event
                        Term                        Subject
                                                    Site

  Source System: The integrated system that is the source of where the term came from.
  Study:         The iMedidata study that was created for that Study Group / Segment

  Dictionary: The medical coding dictionary name where the term will be coded in.
  Locale:     The coding dictionary's locale, such as ENG or JPN
  Priority:   The number associated with the relative priority of the task as set up in EDC for that form. The task with the highest priority shows the smallest number.
  Level:      The term's coding level.
  Term:       The verbatim and entered text submission to be coded.

  Field:   The field the verbatim was entered in. (In EDC correlates to Field OID)
  Line:    The line the verbatim was entered in.   (In EDC correlates to Log-line Number)
  Form:    The form the verbatim was entered in.   (In EDC correlates to Form OID)
  Event:   The event the verbatim was entered in.
  Subject: The subject's name the verbatim was entered for.
  Site:    The site's name where the verbatim was entered.

  Supplemental Name:  From Dictionary Term Search, text of additional properties for the verbatim term.
  Supplemental Value: From Dictionary Term Search, text showing exact match of supplemental name.

  Component Name:  From Dictionary Term Search, text of additional properties for verbatim term.
  Component Value: From the Dictionary Term Search, text showing exact match of component or component type.


- Reference the coding help information residing in:  https://learn.mdsol.com/display/CODERprd/Viewing+Coder+Transaction+Details+While+Coding?lang=en#ViewingCoderTransactionDetailsWhileCoding-ViewSourceTerms


- The following environment configuration settings were enabled:

   Empty Synonym Lists Registered:
   Synonym List 1: MedDRA       (ENG) 15.0   Primary List

   Common Configurations:
   Configuration Name | Force Primary Path Selection (MedDRA) | Synonym Creation Policy Flag | Bypass Reconsider Upon Reclassify | Default Select Threshold | Default Suggest Threshold | Auto Add Synonyms | Auto Approve | Term Requires Approval (IsApprovalRequired )  | Term Auto Approve with synonym (IsAutoApproval)   |
   Basic              | TRUE                                  | Always Active                | TRUE                              | 100                      | 70                        | TRUE              | FALSE        | TRUE                                          | TRUE                                              |

@VAL
@Release2015.3.0
@PBMCC_152100_001a
@SmokeTest
Scenario: The following information will be available to the client as Source Term information as well as testing auto coding

  Given a "Waiting Approval" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  When the following externally managed verbatim requests are made
      | Verbatim Term         | Dictionary Level |
      | Toxic effect of venom | LLT              |
  Then the task "Toxic effect of venom" should have a status of "Waiting Approval"
  And I verify the following Source Term information is displayed
       | Source System  | Study              | Dictionary    | Locale | Term                  | Level          | Priority |
       | <SourceSystem> | <StudyDisplayName> | MedDRA - 15.0 | ENG    | Toxic effect of venom | Low Level Term | 1        |


@VAL
@PBMCC_152100_001
@Release2015.3.0
Scenario: The following information will be available to the client as a term's source information:   Source System, Study, Dictionary, Locale, Term, Level, Priority
  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  When the following externally managed verbatim requests are made
      | Verbatim Term        | Dictionary Level |
      | Adverse Event Term 1 | LLT              |
  When I view task "Adverse Event Term 1"
  Then I verify the following Source Term information is displayed
       | Source System  | Study              | Dictionary    | Locale | Term                 | Level          | Priority |
       | <SourceSystem> | <StudyDisplayName> | MedDRA - 15.0 | ENG    | Adverse Event Term 1 | Low Level Term | 1        |


@VAL
@PBMCC_152100_003
@Release2015.3.0
Scenario: The following information will be available to the client as a term's term EDC data information:   Field, Line, Form, Event, Subject, Site

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  When the following externally managed verbatim requests are made
      | Verbatim Term        | Dictionary Level |
      | Adverse Event Term 1 | LLT              |
  When I view task "Adverse Event Term 1"
  Then I verify the following EDC information is displayed
       |Field        |Line        |Form           |Event     |Subject       |Site          |
       |Field 1      |Line 1      |Form 1         |Event 1   |Subject 1     |Site 1        |

@VAL
@PBMCC_152100_005
@Release2015.3.0
Scenario: The following information will be available to the client as a term's supplemental data information:   Supplemental Term, Supplemental Value

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  When the following externally managed verbatim requests are made
      | Verbatim Term      | Dictionary Level | Supplemental Field 1 | Supplemental Value 1 |
      | Adverse Event Term | LLT              | Field1               | Oral                 |
  When I view task "Adverse Event Term"
  Then I verify the following Supplemental information is displayed
       | Supplemental Term | Supplemental Value |
       | Field1            | Oral               |


@VAL
@PBMCC_152100_006
@Release2015.3.0
Scenario: Non-production studies are displayed in the source term information
  Given a "Basic" Coder setup for a non-production study with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  When the following externally managed verbatim requests are made
      | Verbatim Term        | Dictionary Level |
      | Adverse Event Term 2 | LLT              |
  When I view task "Adverse Event Term 2"
  Then I verify the following Source Term information is displayed
       | Source System  | Study              | Dictionary    | Locale | Term                 | Level          | Priority |
       | <SourceSystem> | <StudyDisplayName> | MedDRA - 15.0 | ENG    | Adverse Event Term 2 | Low Level Term | 1        |

@VAL
@PBMCC_152100_008
@Release2015.3.0
Scenario: A term will have multiple and blank supplemental information displayed

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  When the following externally managed verbatim requests are made
      | Verbatim Term        | Dictionary Level | Supplemental Field 1 | Supplemental Value 1 | Supplemental Field 2 | Supplemental Value 2 |
      | Adverse Event Term 3 | LLT              | Field1               |                      | Field2               | INDICATION ONE      |
  When I view task "Adverse Event Term 3"
  Then I verify the following Supplemental information is displayed
       | Supplemental Term | Supplemental Value |
       | Field1            |                    |
       | Field2            | INDICATION ONE     |


@VAL
@PBMCC_152100_009
@Release2015.3.0
Scenario: When there is no component or supplemental information, No data will be displayed

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  When the following externally managed verbatim requests are made
      | Verbatim Term        | Dictionary Level |
      | Adverse Event Term 4 | LLT              |
  When I view task "Adverse Event Term 4"
  Then I verify when no component or supplemental data is present and Coder displays "No data"


@VAL
@PBMCC_133578_001
@Release2015.3.0
Scenario: When selecting a term the default view will display Source Term Information

  Given a "Basic" Coder setup with no tasks and no synonyms and dictionary "MedDRA ENG 15.0"
  When the following externally managed verbatim requests are made
      | Verbatim Term        | Dictionary Level |
      | Adverse Event Term   | LLT              |
  When I view task "Adverse Event Term"
  Then I verify that the default view contains Source Term information
