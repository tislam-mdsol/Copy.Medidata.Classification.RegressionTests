@CoderBasicScript
Feature: When selecting a requires response option for Coder configuration, when a Coder query is open they will respect the configuration settings. Remove requires manual close and option for Coder configuration

Preassumptions:

1] coderadmin and medidatareserved1 are setup on that environment
2] Main Client Beta Preview Study Group was created with codersuperuser
3] coderadmin was assigned to study group as study group owner
4] Rave Configuration file was uploaded to the Rave URL with the different roles
5]


@DFT
@MCC_00000_001
@Release2016.1.0
Scenario: Setting up client studies and sites

Given "iMedidata" study group "Client Beta Preview" assigned to study group owner and user "CoderAdmin" 
When Creating "iMedidata" studies and sites for the following clients through iMedidata API for Study Group "Client Beta Preview"
| Client                                 |
| A2healthcare                           |
| actelion                               |
| Alcon                                  |
| Asclepius                              |
| Bayer                                  |
| CAC CROIT                              |
| Chiltern                               |
| Chugai                                 |
| cmic                                   |
| CMIC Co Ltd                            |
| COG                                    |
| Cognizant Technology Solutions         |
| Covance                                |
| CSL Behring                            |
| Daiichi Sankyo                         |
| eTrial Co Ltd                          |
| eClinical Solutions                    |
| Edwards Lifesciences                   |
| FSTRF                                  |
| Gilead                                 |
| H Lundbeck AS                          |
| ICON                                   |
| INC Research                           |
| J&J                                    |
| Janssen                                |
| Janssen Pharma                         |
| JNJ                                    |
| Mapi                                   |
| Mayo Clinic                            |
| Shared Data                            |
| Merck                                  |
| Merz Pharmaceuticals                   |
| Mundipharma Research                   |
| Novella Clinical LLC                   |
| OHSU                                   |
| PAREXEL                                | 
| Pharmamar                              |
| PPD                                    |
| quintiles                              |
| Sanofi                                 |
| Seattle Childrens                      |
| Tata Consultancy Services              |
| USC                                    |
| Westat                                 |
| Wincere                                |


@DFT
@MCC_00000_002
@Release2016.1.0
Scenario: Roll out the following dictionary subscription ranges

Given accessing Coder segment "MedidataReserved1" with user "CoderAdmin"
When rolling out the following dictionaries for segment "Client Beta Preview"
| Dictionary           | Start Date     | End Date  |  
| MedDRA (eng)         | 9/1/2014       | 9/1/2016  |
| WHODrug-DDE-B2 (eng) | 9/1/2105       | 9/1/2016  |
| WHODrug-DDE-C (eng)  | 9/1/2105       | 9/1/2016  |
| JDrug (jpn)          | 12/1/2014      | 12/2/2016 |   



@DFT
@MCC_00000_003
@Release2016.1.0
Scenario: Create roles for Coder Admin, which would have to be assigned later in a study basis for each client user

Given accessing Coder segment "CLient Beta Preview" with user "CoderAdmin"
When creating and activating a new workflow role called "Workflow Admin"
And assigning workflow role "Workflow Admin" for "All" study
And creating and activating a "Page Study Security" role called "StudyAdmin"
And assigning "Page Study Security" General Role "StudyAdmin" for "All" type
And creating and activating a "Page Dictionary Security" role called "DictAdmin"
And assigning "Page Dictionary Security" General Role "DictAdmin" for "All" type


@DFT
@MCC_00000_004
@Release2016.1.0
Scenario: Create Synonym Lists for each study

Given dictionaries are present 
And an activated synonym list "MedDRA ENG 17.1 Primary_List" for "50" times 


@DFT
@MCC_00000_005
@Release2016.1.0
Scenario: Upload standard draft for each project in Rave 

Given accessing Rave EDC segment "Client Beta Preview" with user "CoderAdmin"
When uploading standard client draft for the following project
| Project                                |
| A2healthcare_Study                     |
| actelion_Study                         |
| Alcon_Study                            |
| Asclepius_Study                        |
| Bayer_Study                            |
| CAC CROIT_Study                        |
| Chiltern_Study                         |
| Chugai_Study                           |
| cmic_Study                             |
| CMIC Co Ltd_Study                      |
| COG_Study                              |
| Cognizant Technology Solutions_Study   |
| Covance_Study                          |
| CSL Behring_Study                      |
| Daiichi Sankyo_Study                   |
| eTrial Co Ltd_Study                    |
| eClinical Solutions_Study              |
| Edwards Lifesciences_Study             |
| FSTRF_Study                            |
| Gilead_Study                           |
| H Lundbeck AS_Study                    |
| ICON_Study                             |
| INC Research_Study                     |
| J&J_Study                              |
| Janssen_Study                          |
| Janssen Pharma_Study                   |
| JNJ_Study                              |
| Mapi_Study                             |
| Mayo Clinic_Study                      |
| Shared Data_Study                      |
| Merck_Study                            |
| Merz Pharmaceuticals_Study             |
| Mundipharma Research_Study             |
| Novella Clinical LLC_Study             |
| OHSU_Study                             |
| PAREXEL_Study                          |
| Pharmamar_Study                        |
| PPD_Study                              |
| quintiles_Study                        |
| Sanofi_Study                           |
| Seattle Childrens_Study                |
| Tata Consultancy Services_Study        |
| USC_Study                              |
| Westat_Study                           |
| Wincere_Study                          |



@DFT
@MCC_00000_006
@Release2016.1.0
Scenario: Assign rave coderimport user the following production studies

Given accessing Rave EDC segment "Client Beta Preview" with user "CoderAdmin"
When assigning the coderimport user in user administration to the following "production" project
| Project                                |
| A2healthcare_Study                     |
| actelion_Study                         |
| Alcon_Study                            |
| Asclepius_Study                        |
| Bayer_Study                            |
| CAC CROIT_Study                        |
| Chiltern_Study                         |
| Chugai_Study                           |
| cmic_Study                             |
| CMIC Co Ltd_Study                      |
| COG_Study                              |
| Cognizant Technology Solutions_Study   |
| Covance_Study                          |
| CSL Behring_Study                      |
| Daiichi Sankyo_Study                   |
| eTrial Co Ltd_Study                    |
| eClinical Solutions_Study              |
| Edwards Lifesciences_Study             |
| FSTRF_Study                            |
| Gilead_Study                           |
| H Lundbeck AS_Study                    |
| ICON_Study                             |
| INC Research_Study                     |
| J&J_Study                              |
| Janssen_Study                          |
| Janssen Pharma_Study                   |
| JNJ_Study                              |
| Mapi_Study                             |
| Mayo Clinic_Study                      |
| Shared Data_Study                      |
| Merck_Study                            |
| Merz Pharmaceuticals_Study             |
| Mundipharma Research_Study             |
| Novella Clinical LLC_Study             |
| OHSU_Study                             |
| PAREXEL_Study                          |
| Pharmamar_Study                        |
| PPD_Study                              |
| quintiles_Study                        |
| Sanofi_Study                           |
| Seattle Childrens_Study                |
| Tata Consultancy Services_Study        |
| USC_Study                              |
| Westat_Study                           |
| Wincere_Study                          |


@DFT
@MCC_00000_007
@Release2016.1.0
Scenario: Perform project registration for client projects for WHodrug

Given accessing Coder segment "MedidataReserved1" with user "CoderAdmin"
When registering a project with the following options
| Project                                | Dictionary       | Version   | Locale | SynonymListName   | RegistrationName |
| A2healthcare_Study                     | WhoDrugDDEB2     | 201509    | eng    | Primary_List1     | WHODrug-DDE-B2   |
| actelion_Study                         | WhoDrugDDEB2     | 201509    | eng    | Primary_List2     | WHODrug-DDE-B2   |
| Alcon_Study                            | WhoDrugDDEB2     | 201509    | eng    | Primary_List3     | WHODrug-DDE-B2   |
| Asclepius_Study                        | WhoDrugDDEB2     | 201509    | eng    | Primary_List4     | WHODrug-DDE-B2   |
| Bayer_Study                            | WhoDrugDDEB2     | 201509    | eng    | Primary_List5     | WHODrug-DDE-B2   |
| CAC CROIT_Study                        | WhoDrugDDEB2     | 201509    | eng    | Primary_List6     | WHODrug-DDE-B2   |
| Chiltern_Study                         | WhoDrugDDEB2     | 201509    | eng    | Primary_List7     | WHODrug-DDE-B2   |
| Chugai_Study                           | WhoDrugDDEB2     | 201509    | eng    | Primary_List8     | WHODrug-DDE-B2   |
| cmic_Study                             | WhoDrugDDEB2     | 201509    | eng    | Primary_List9     | WHODrug-DDE-B2   |
| CMIC Co Ltd_Study                      | WhoDrugDDEB2     | 201509    | eng    | Primary_List10    | WHODrug-DDE-B2   |
| COG_Study                              | WhoDrugDDEB2     | 201509    | eng    | Primary_List11    | WHODrug-DDE-B2   |
| Cognizant Technology Solutions_Study   | WhoDrugDDEB2     | 201509    | eng    | Primary_List12    | WHODrug-DDE-B2   |
| Covance_Study                          | WhoDrugDDEB2     | 201509    | eng    | Primary_List13    | WHODrug-DDE-B2   |
| CSL Behring_Study                      | WhoDrugDDEB2     | 201509    | eng    | Primary_List14    | WHODrug-DDE-B2   |
| Daiichi Sankyo_Study                   | WhoDrugDDEB2     | 201509    | eng    | Primary_List15    | WHODrug-DDE-B2   |
| eTrial Co Ltd_Study                    | WhoDrugDDEB2     | 201509    | eng    | Primary_List16    | WHODrug-DDE-B2   |
| eClinical Solutions_Study              | WhoDrugDDEB2     | 201509    | eng    | Primary_List17    | WHODrug-DDE-B2   |
| Edwards Lifesciences_Study             | WhoDrugDDEB2     | 201509    | eng    | Primary_List18    | WHODrug-DDE-B2   |
| FSTRF_Study                            | WhoDrugDDEB2     | 201509    | eng    | Primary_List19    | WHODrug-DDE-B2   |
| Gilead_Study                           | WhoDrugDDEB2     | 201509    | eng    | Primary_List20    | WHODrug-DDE-B2   |
| H Lundbeck AS_Study                    | WhoDrugDDEB2     | 201509    | eng    | Primary_List21    | WHODrug-DDE-B2   |
| ICON_Study                             | WhoDrugDDEB2     | 201509    | eng    | Primary_List22    | WHODrug-DDE-B2   |
| INC Research_Study                     | WhoDrugDDEB2     | 201509    | eng    | Primary_List23    | WHODrug-DDE-B2   |
| J&J_Study                              | WhoDrugDDEB2     | 201509    | eng    | Primary_List24    | WHODrug-DDE-B2   |
| Janssen_Study                          | WhoDrugDDEB2     | 201509    | eng    | Primary_List25    | WHODrug-DDE-B2   |
| Janssen Pharma_Study                   | WhoDrugDDEB2     | 201509    | eng    | Primary_List26    | WHODrug-DDE-B2   |
| JNJ_Study                              | WhoDrugDDEB2     | 201509    | eng    | Primary_List27    | WHODrug-DDE-B2   |
| Mapi_Study                             | WhoDrugDDEB2     | 201509    | eng    | Primary_List28    | WHODrug-DDE-B2   |
| Mayo Clinic_Study                      | WhoDrugDDEB2     | 201509    | eng    | Primary_List29    | WHODrug-DDE-B2   |
| Shared Data_Study                      | WhoDrugDDEB2     | 201509    | eng    | Primary_List30    | WHODrug-DDE-B2   |
| Merck_Study                            | WhoDrugDDEB2     | 201509    | eng    | Primary_List31    | WHODrug-DDE-B2   |
| Merz Pharmaceuticals_Study             | WhoDrugDDEB2     | 201509    | eng    | Primary_List32    | WHODrug-DDE-B2   |
| Mundipharma Research_Study             | WhoDrugDDEB2     | 201509    | eng    | Primary_List33    | WHODrug-DDE-B2   |
| Novella Clinical LLC_Study             | WhoDrugDDEB2     | 201509    | eng    | Primary_List34    | WHODrug-DDE-B2   |
| OHSU_Study                             | WhoDrugDDEB2     | 201509    | eng    | Primary_List35    | WHODrug-DDE-B2   |
| PAREXEL_Study                          | WhoDrugDDEB2     | 201509    | eng    | Primary_List36    | WHODrug-DDE-B2   |
| Pharmamar_Study                        | WhoDrugDDEB2     | 201509    | eng    | Primary_List37    | WHODrug-DDE-B2   |
| PPD_Study                              | WhoDrugDDEB2     | 201509    | eng    | Primary_List38    | WHODrug-DDE-B2   |
| quintiles_Study                        | WhoDrugDDEB2     | 201509    | eng    | Primary_List39    | WHODrug-DDE-B2   |
| Sanofi_Study                           | WhoDrugDDEB2     | 201509    | eng    | Primary_List40    | WHODrug-DDE-B2   |
| Seattle Childrens_Study                | WhoDrugDDEB2     | 201509    | eng    | Primary_List41    | WHODrug-DDE-B2   |
| Tata Consultancy Services_Study        | WhoDrugDDEB2     | 201509    | eng    | Primary_List42    | WHODrug-DDE-B2   |
| USC_Study                              | WhoDrugDDEB2     | 201509    | eng    | Primary_List43    | WHODrug-DDE-B2   |
| Westat_Study                           | WhoDrugDDEB2     | 201509    | eng    | Primary_List44    | WHODrug-DDE-B2   |
| Wincere_Study                          | WhoDrugDDEB2     | 201509    | eng    | Primary_List45    | WHODrug-DDE-B2   |


@DFT
@MCC_00000_008
@Release2016.1.0
Scenario: Perform project registration for client projects for MedDRa

Given accessing Coder segment "MedidataReserved1" with user "CoderAdmin"
When registering a project with the following options
| Project                                | Dictionary | Version | Locale | SynonymListName   | RegistrationName |
| A2healthcare_Study                     | MedDRA     | 17.1    | eng    | Primary_List1     | MedDRA           |
| actelion_Study                         | MedDRA     | 17.1    | eng    | Primary_List2     | MedDRA           |
| Alcon_Study                            | MedDRA     | 17.1    | eng    | Primary_List3     | MedDRA           |
| Asclepius_Study                        | MedDRA     | 17.1    | eng    | Primary_List4     | MedDRA           |
| Bayer_Study                            | MedDRA     | 17.1    | eng    | Primary_List5     | MedDRA           |
| CAC CROIT_Study                        | MedDRA     | 17.1    | eng    | Primary_List6     | MedDRA           |
| Chiltern_Study                         | MedDRA     | 17.1    | eng    | Primary_List7     | MedDRA           |
| Chugai_Study                           | MedDRA     | 17.1    | eng    | Primary_List8     | MedDRA           |
| cmic_Study                             | MedDRA     | 17.1    | eng    | Primary_List9     | MedDRA           |
| CMIC Co Ltd_Study                      | MedDRA     | 17.1    | eng    | Primary_List10    | MedDRA           |
| COG_Study                              | MedDRA     | 17.1    | eng    | Primary_List11    | MedDRA           |
| Cognizant Technology Solutions_Study   | MedDRA     | 17.1    | eng    | Primary_List12    | MedDRA           |
| Covance_Study                          | MedDRA     | 17.1    | eng    | Primary_List13    | MedDRA           |
| CSL Behring_Study                      | MedDRA     | 17.1    | eng    | Primary_List14    | MedDRA           |
| Daiichi Sankyo_Study                   | MedDRA     | 17.1    | eng    | Primary_List15    | MedDRA           |
| eTrial Co Ltd_Study                    | MedDRA     | 17.1    | eng    | Primary_List16    | MedDRA           |
| eClinical Solutions_Study              | MedDRA     | 17.1    | eng    | Primary_List17    | MedDRA           |
| Edwards Lifesciences_Study             | MedDRA     | 17.1    | eng    | Primary_List18    | MedDRA           |
| FSTRF_Study                            | MedDRA     | 17.1    | eng    | Primary_List19    | MedDRA           |
| Gilead_Study                           | MedDRA     | 17.1    | eng    | Primary_List20    | MedDRA           |
| H Lundbeck AS_Study                    | MedDRA     | 17.1    | eng    | Primary_List21    | MedDRA           |
| ICON_Study                             | MedDRA     | 17.1    | eng    | Primary_List22    | MedDRA           |
| INC Research_Study                     | MedDRA     | 17.1    | eng    | Primary_List23    | MedDRA           |
| J&J_Study                              | MedDRA     | 17.1    | eng    | Primary_List24    | MedDRA           |
| Janssen_Study                          | MedDRA     | 17.1    | eng    | Primary_List25    | MedDRA           |
| Janssen Pharma_Study                   | MedDRA     | 17.1    | eng    | Primary_List26    | MedDRA           |
| JNJ_Study                              | MedDRA     | 17.1    | eng    | Primary_List27    | MedDRA           |
| Mapi_Study                             | MedDRA     | 17.1    | eng    | Primary_List28    | MedDRA           |
| Mayo Clinic_Study                      | MedDRA     | 17.1    | eng    | Primary_List29    | MedDRA           |
| Shared Data_Study                      | MedDRA     | 17.1    | eng    | Primary_List30    | MedDRA           |
| Merck_Study                            | MedDRA     | 17.1    | eng    | Primary_List31    | MedDRA           |
| Merz Pharmaceuticals_Study             | MedDRA     | 17.1    | eng    | Primary_List32    | MedDRA           |
| Mundipharma Research_Study             | MedDRA     | 17.1    | eng    | Primary_List33    | MedDRA           |
| Novella Clinical LLC_Study             | MedDRA     | 17.1    | eng    | Primary_List34    | MedDRA           |
| OHSU_Study                             | MedDRA     | 17.1    | eng    | Primary_List35    | MedDRA           |
| PAREXEL_Study                          | MedDRA     | 17.1    | eng    | Primary_List36    | MedDRA           |
| Pharmamar_Study                        | MedDRA     | 17.1    | eng    | Primary_List37    | MedDRA           |
| PPD_Study                              | MedDRA     | 17.1    | eng    | Primary_List38    | MedDRA           |
| quintiles_Study                        | MedDRA     | 17.1    | eng    | Primary_List39    | MedDRA           |
| Sanofi_Study                           | MedDRA     | 17.1    | eng    | Primary_List40    | MedDRA           |
| Seattle Childrens_Study                | MedDRA     | 17.1    | eng    | Primary_List41    | MedDRA           |
| Tata Consultancy Services_Study        | MedDRA     | 17.1    | eng    | Primary_List42    | MedDRA           |
| USC_Study                              | MedDRA     | 17.1    | eng    | Primary_List43    | MedDRA           |
| Westat_Study                           | MedDRA     | 17.1    | eng    | Primary_List44    | MedDRA           |
| Wincere_Study                          | MedDRA     | 17.1    | eng    | Primary_List45    | MedDRA           |


@DFT
@MCC_00000_009
@Release2016.1.0
Scenario: Load MEV data for the Shared Data Study

When loading data for study content "Shared Data_Study"
