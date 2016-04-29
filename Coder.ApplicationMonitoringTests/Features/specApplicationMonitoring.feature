@specApplicationMonitoring.feature
@ApplicationMonitoring
Feature: This feature shall verify that the Coder system is operational. This is intended to be a scheduled task run in Production.
Like Production ETE environments can utilize this feature to determine if proposed Rave changes will affect the test in Production and
to verify the operation status of the lower environment.

This feature requires the following test configuration settings:
| Config.cs               | Settings.config.dice                     |
| Login                   | configured.regression_test_user_id       |
| Password                | configured.regression_test_user_password | 
| Segment                 | configured.segment                       |
| StudyName               | configured.study_name                    |
| ParentDownloadDirectory | DEFAULT                                  |
| ParentDumpDirectory     | DEFAULT                                  |

This feature was designed to execute in Production with no database access. No connection settings are included.

Possible Rave configuration settings affecting Coder auto-coding workflow:
| Type                                            |  IsAutoApproval | IsApprovalRequired |
| AutoApprovalRequired                            |  TRUE           | TRUE               |
| ApprovalRequired                                |  TRUE           | FALSE              |
| AutoApprovalNotRequired (will not auto-approve) |  FALSE          | TRUE               |
| ApprovalNotRequired                             |  FALSE          | FALSE              |

The scenario steps will dynamically detect the Rave configuration settings and manually approve coding decisions if required.

This scenario uses the RetryPolicy.RaveCoderTransmission to wait for information during the bidirectional exchanges between Rave and Coder.
These waits are currently configured to check for the data every 30 seconds for 5 minutes. It is possible that all waits in sequence could
extend the duration of the test past the next scheduled execution. IncreaseTimeout tag is set to limit the execution time to 28 minutes.
Base execution time in AssemblyInfo (3 mins) + Increased Timeout (25 mins) = 28 mins.

@VAL
@Release2016.1.0
@PBMCC_209375_001
@IncreaseTimeout_1500000
Scenario: The services required to code adverse events added to new subjects shall be running and functioning correctly

Given Rave Modules App Segment "<Segment>" is loaded
And a unique adverse event "CoderAppMon"
When adding a new manual ID subject "TST"
And adding a new adverse event "<AdverseEventText>" to subject "<SubjectId>" of study "<StudyName>"
Then the audit log for occurrence "1" of the adverse event "<AdverseEventText>" is updated when the term is sent to coder
When Coder App Segment "<Segment>" is loaded
Then the MEV upload capability is available
And the task "<AdverseEventText>" should have a status of "Waiting Manual Code"
Given the Rave settings used for task "<AdverseEventText>"
When I configure "Force Primary Path Selection" to "true"
And I configure the Synonym Creation Policy Flag to "Always Active"
And I configure dictionary "<Dictionary>" with "Auto Add Synonyms" set to "true"
And I configure dictionary "<Dictionary>" with "Auto Approve" set to "false"
And task "<AdverseEventText>" is coded to term "Gastroesophageal burning" at search level "Low Level Term" with code "10066998" at level "LLT" and higher level terms with a synonym created
| Operator | Attribute             | Text                                |
| Has      | System Organ Class    | Gastrointestinal disorders          |
| Has      | High Level Group Term | Gastrointestinal signs and symptoms |
| Has      | High Level Term       | Dyspeptic signs and symptoms        |
| Has      | Preferred Term        | Dyspepsia                           |
Then the synonym for verbatim "<AdverseEventText>" and code "10066998" should be active
When approving task "<AdverseEventText>" if required
Then the coding decision for the task "<AdverseEventText>" is approved for term "Gastroesophageal burning"
And the audit log for occurrence "1" of the adverse event "<AdverseEventText>" is updated with the term path "SOC: Gastrointestinal disorders, HLGT: Gastrointestinal signs and symptoms, HLT: Dyspeptic signs and symptoms, PT: Dyspepsia, LLT: Gastroesophageal burning"
When adding a new adverse event "<AdverseEventText>" to subject "<SubjectId>" of study "<StudyName>" and the coding decision approved
Then the audit log for occurrence "2" of the adverse event "<AdverseEventText>" is updated with the term path "SOC: Gastrointestinal disorders, HLGT: Gastrointestinal signs and symptoms, HLT: Dyspeptic signs and symptoms, PT: Dyspepsia, LLT: Gastroesophageal burning"
