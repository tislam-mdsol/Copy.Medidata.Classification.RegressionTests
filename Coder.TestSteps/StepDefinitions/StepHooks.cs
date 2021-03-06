﻿using System;
using System.IO;
using System.Linq;
using Coder.DeclarativeBrowser;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Helpers;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.ETEModels;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using NUnit.Framework;
using TechTalk.SpecFlow;

namespace Coder.TestSteps.StepDefinitions
{
    [Binding]
    public class StepHooks
    {
        private readonly StepContext _StepContext;

        public StepHooks(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null)) throw new ArgumentNullException("stepContext");

            _StepContext = stepContext;
        }

        [BeforeTestRun]
        public static void BeforeTestRun()
        {
            CreateScreenshotDirectory();
        }

        [BeforeScenario("CoderBasicScript")]
        public void BeforeCoderBasicScriptScenario()
        {
            _StepContext.Browser.CoderCoreLogin(_StepContext.CoderAdminUser.Username);
        }

        [BeforeScenario("CoderCore")]
        public void BeforeCoreScenario()
        {
            var generatedUser = CoderUserGenerator.GenerateUser(Config.StudyNamePrefix);

            _StepContext.CoderTestUser    = generatedUser.User;
            _StepContext.SegmentUnderTest = generatedUser.Segment;

            CommonBeforeScenario(_StepContext);

            try
            {
                _StepContext.Browser.CoderCoreLogin(_StepContext.GetUser());
            }
            catch (Exception ex)
            {
                var user    = _StepContext.CoderTestUser;
                var segment = _StepContext.SegmentUnderTest;

                Console.WriteLine($"Exception thrown with message: {ex.Message}");
                Console.WriteLine($"Error while trying to log into Coder with user: ID: {user.Id}; username: {user.Username}");
                Console.WriteLine($"Segment Info: ID {segment.SegmentId}; Name: {segment.SegmentName}; UUID: {segment.SegmentUuid}");

                throw;
            }
        }

        [BeforeScenario("EndToEndDynamicSegment")]
        public void BeforeEndToEndScenarioDynamicSegment()
        {
            var generatedSuffix = SetBrowsingContext();

            var browser = _StepContext.Browser;
            
            LoginAsAdministrator();

            var newStudyGroup = CreateSegmentSetupData(generatedSuffix); 
            
            SetSegmentContext(newStudyGroup);

            CreateTestUserContext(generatedSuffix, newStudyGroup, createNewSegment: true);

            browser.EnrollSegment(Config.SetupSegment, _StepContext.GetSegment());

            browser.LogoutOfCoderAndImedidata();

            CompleteUserRegistration(_StepContext.CoderTestUser, newStudyGroup);

            WriteSetupDetails(_StepContext.CoderTestUser, newStudyGroup);
        }

        [BeforeScenario("DebugEndToEndDynamicSegment")]
        public void BeforeDebugEndToEndScenarioDynamicSegment()
        {
            var generatedSuffix           = SetBrowsingContext();

            var browser                   = _StepContext.Browser;

            var adminUser                 = new MedidataUser
            {
                Username                  = Config.AdminLogin,
                Password                  = Config.AdminPassword
            };
            _StepContext.CoderAdminUser   = adminUser;

            var newStudyGroup = CreateSegmentSetupData("8e1375e401167");
            _StepContext.SegmentUnderTest = newStudyGroup;

            SetSegmentContext(newStudyGroup);
            MedidataUser newUser = new MedidataUser
            {
                Username = "medidatacoder+MDF8e1375e401167@gmail.com",
                Password = "Password1",
                Email = "medidatacoder+MDF8e1375e401167@gmail.com",
                MedidataId = "8e1375e401167",
                FirstName = "Coder"
            };
            _StepContext.CoderTestUser = newUser;
     
            WriteSetupDetails(_StepContext.CoderTestUser, newStudyGroup);
            browser.LoginToiMedidata(_StepContext.CoderTestUser.Username, _StepContext.CoderTestUser.Password);
            _StepContext.DraftName     = "RaveCoderDraft";
        }

        [BeforeScenario("EndToEndDynamicStudy")]
        public void BeforeEndToEndScenarioDynamicStudy()
        {
            var generatedSuffix = SetBrowsingContext();

            var browser = _StepContext.Browser;

            LoginAsAdministrator();
            
            var newStudyGroup = CreateSegmentSetupData(generatedSuffix);
            
            newStudyGroup.SegmentName = String.Concat(Config.StudyNamePrefix, Config.ETESetupSuffix);
            newStudyGroup.SegmentUuid = browser.GetStudyGroupUUID(newStudyGroup.SegmentName);
            
            SetSegmentContext(newStudyGroup);
            
            CreateTestUserContext(generatedSuffix, newStudyGroup, createNewSegment: false);

            browser.LogoutOfiMedidata();

            CompleteUserRegistration(_StepContext.CoderTestUser, newStudyGroup);

            WriteSetupDetails(_StepContext.CoderTestUser, newStudyGroup);
        }

        [BeforeScenario("EndToEndStaticSegment")]
        public void BeforeEndToEndScenarioSerialExecution()
        {
            SetBrowsingContext();

            var newStudyGroup = CreateSegmentSetupData(Config.ETESetupSuffix);

            _StepContext.SegmentUnderTest = newStudyGroup;

            var userName  = String.Concat(Config.StudyNamePrefix, Config.ETESetupSuffix);
            var userEmail = userName.CreateUserEmail();

            _StepContext.CoderTestUser = new MedidataUser
            {
                Username = userEmail,
                Password = Config.Password
            };

            WriteSetupDetails(_StepContext.CoderTestUser, newStudyGroup);
        }

        private string SetBrowsingContext()
        {
            var generatedSuffix            = Guid.NewGuid().GetFirstSectionAppendedWithRandomNumbers();

            _StepContext.DownloadDirectory = CreateUserDirectory(Config.ParentDownloadDirectory, generatedSuffix);
            _StepContext.DumpDirectory     = CreateUserDirectory(Config.ParentDumpDirectory, generatedSuffix);
            var browser                    = CoderDeclarativeBrowser.StartBrowsing(_StepContext.DownloadDirectory);
            _StepContext.Browser           = browser;

            _StepContext.CoderSystemuser = new MedidataUser
            {
                Username = "systemuser"
            };

            return generatedSuffix;
        }

        private void LoginAsAdministrator()
        {
            var adminUser = new MedidataUser
            {
                Username = Config.AdminLogin,
                Password = Config.AdminPassword
            };
            _StepContext.CoderAdminUser = adminUser;

            _StepContext.Browser.LoginToiMedidata(adminUser.Username, adminUser.Password);
        }
        
        private void SetSegmentContext(SegmentSetupData newStudyGroup)
        {
            if(ReferenceEquals(newStudyGroup, null)) throw new ArgumentNullException("newStudyGroup");

            _StepContext.SegmentUnderTest = newStudyGroup;

            _StepContext.SetStudyGroupSetupData(newStudyGroup);
        }

        private void CreateTestUserContext(string nameSuffix, SegmentSetupData newStudyGroup, bool createNewSegment)
        {
            if (String.IsNullOrWhiteSpace(nameSuffix)) throw new ArgumentNullException("nameSuffix");
            if (ReferenceEquals(newStudyGroup, null))  throw new ArgumentNullException("newStudyGroup");

            var userName = String.Concat(Config.StudyNamePrefix, nameSuffix);

            var newUser = _StepContext.Browser.CreateTestUserContext(newStudyGroup, userName, createNewSegment);
       
            _StepContext.CoderTestUser = newUser;
        }

        private void CompleteUserRegistration(MedidataUser user, SegmentSetupData studyGroup)
        {
            if (ReferenceEquals(user, null))       throw new ArgumentNullException("user");
            if (ReferenceEquals(studyGroup, null)) throw new ArgumentNullException("studyGroup");

            var browser = _StepContext.Browser;

            browser.LoginToiMedidata(user.Username, user.Password);

            browser.AcceptStudyInvitation();

            browser.LoadiMedidataRaveModulesAppSegment(_StepContext.GetSegment());

            var productionStudyName = studyGroup.Studies.FirstOrDefault(x => x.IsProduction).StudyName;
            var environmentPrefix   = "Live: ";
            var studies             = studyGroup.Studies;

            foreach (var study in studies)
            {
                environmentPrefix = "Aux: ";               

                if (study.IsProduction)
                {
                    productionStudyName = study.StudyName;
                    environmentPrefix   = "Live: ";
                }

                var projectEnvironment = String.Concat(environmentPrefix, study.StudyType.ToString());

                browser.AssignUserToStudy("coderimport", "Coder Import Role", study: productionStudyName, projectEnvironment: projectEnvironment );
            }
            
            browser.LogoutOfiMedidata();
        }
        
        private void WriteSetupDetails(MedidataUser user, SegmentSetupData studyGroup)
        {
            if (ReferenceEquals(user, null))       throw new ArgumentNullException("user");
            if (ReferenceEquals(studyGroup, null)) throw new ArgumentNullException("studyGroup");

            Console.WriteLine("Created the following test setup:");
            Console.WriteLine(String.Format("Name Suffix: {0}", studyGroup.NameSuffix));
            Console.WriteLine(String.Format("Segment: {0}", studyGroup.SegmentName));

            foreach (var study in studyGroup.Studies)
            {
                var index = 0;
                Console.WriteLine(String.Format("Study {0}: {1}", index++, study.StudyName));
            }

            Console.WriteLine(String.Format("Site: {0}", studyGroup.ProdStudy.Sites[0].SiteName));
            Console.WriteLine(String.Format("User: {0}", user.Email));
            Console.WriteLine(String.Format("User Password: {0}", user.Password));
        }
        
        [BeforeScenario("ApplicationMonitoring")]
        public void BeforeApplicationMonitoringScenario()
        {
            _StepContext.CoderTestUser = new MedidataUser
            {
                Username = Config.Login,
                Password = Config.Password
            };
            
            var newStudyGroup = new SegmentSetupData
            {
                SegmentName = Config.Segment,
                Studies     = new StudySetupData[]
                {
                    new StudySetupData
                    {
                        StudyName = Config.StudyName,
                        Sites     = new SiteSetupData[]
                        {
                            new SiteSetupData
                            {
                                SiteName = Config.Site
                            }
                        }
                    }
                }
            };

            _StepContext.SegmentUnderTest = newStudyGroup;

            _StepContext.DownloadDirectory     = CreateUserDirectory(Config.ParentDownloadDirectory, _StepContext.GetUser());
            _StepContext.DumpDirectory         = CreateUserDirectory(Config.ParentDumpDirectory, _StepContext.GetUser());

            _StepContext.Browser               = CoderDeclarativeBrowser.StartBrowsing(_StepContext.DownloadDirectory);

            _StepContext.Browser.LoginToiMedidata(_StepContext.GetUser(), Config.Password);
        }

        [BeforeScenario("Deployment")]
        public void BeforeRaveDeploymentScenario()
        {
            var raveAdminUser = new MedidataUser
            {
                Username      = Config.RaveAdminLogin,
                Password      = Config.RaveAdminPassword
            };

            _StepContext.RaveAdminUser     = raveAdminUser;

            var newStudyGroup              = CreateSegmentSetupData("c56d2b4d6267");
            _StepContext.SegmentUnderTest  = newStudyGroup;
            
            _StepContext.DownloadDirectory = CreateUserDirectory(Config.ParentDownloadDirectory, raveAdminUser.Username);
            _StepContext.DumpDirectory     = CreateUserDirectory(Config.ParentDumpDirectory, raveAdminUser.Username);
            _StepContext.Browser           = CoderDeclarativeBrowser.StartBrowsing(_StepContext.DownloadDirectory);

            _StepContext.Browser.LoginToRave(raveAdminUser);

        }

        private void CommonBeforeScenario(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext,null))  throw new ArgumentNullException("stepContext");
            if (String.IsNullOrWhiteSpace(stepContext.GetUser())) throw new ArgumentNullException("loginId");

            var systemUser = CoderDatabaseAccess.GetUserNameByLogin("System User");
            stepContext.CoderSystemuser   = new MedidataUser
            {
                Username                  = systemUser
            };

            var user                      = stepContext.GetUser();

            stepContext.DownloadDirectory = CreateUserDirectory(Config.ParentDownloadDirectory, user);
            stepContext.DumpDirectory     = CreateUserDirectory(Config.ParentDumpDirectory, user);

            stepContext.Browser           = CoderDeclarativeBrowser.StartBrowsing(_StepContext.DownloadDirectory);
        }

        private SegmentSetupData CreateSegmentSetupData(string nameSuffix)
        {
            const string userAcceptanceStudySuffix = "(UAT)";
            const string developmentStudySuffix    = "(Dev)";

            if (String.IsNullOrWhiteSpace(nameSuffix)) throw new ArgumentNullException("nameSuffix");

            var studyName = String.Concat(Config.StudyNamePrefix, nameSuffix, "_Study");
            var studyExternalOid = studyName.RemoveNonAlphanumeric();

            var siteName = String.Concat(Config.StudyNamePrefix, nameSuffix, "_Site");
            var siteNumber = String.Concat(nameSuffix, "_Site").RemoveNonAlphanumeric();

            var newStudyGroup = new SegmentSetupData
            {
                NameSuffix = nameSuffix,
                SegmentName = String.Concat(Config.StudyNamePrefix, nameSuffix),
                Studies = new StudySetupData[]
                {
                    new StudySetupData()
                    {
                        StudyType    = StudyType.Prod,
                        StudyName    = studyName,
                        ExternalOid  = studyExternalOid,
                        IsProduction = true,
                        Sites        = new SiteSetupData[]
                        {
                            new SiteSetupData
                            {
                                SiteName   = siteName,
                                SiteNumber = siteNumber
                            }
                        },
                        ProtocolNumber = studyName.Replace("_", "")
                    },
                    new StudySetupData()
                    {
                        StudyType    = StudyType.UAT,
                        StudyName    = String.Concat(studyName, " ",userAcceptanceStudySuffix),
                        ExternalOid  = String.Concat(studyExternalOid, userAcceptanceStudySuffix).RemoveNonAlphanumeric(),
                        IsProduction = false,
                        Sites        = new SiteSetupData[]
                        {
                            new SiteSetupData
                            {
                                SiteName   = String.Concat(siteName, " ", userAcceptanceStudySuffix),
                                SiteNumber = String.Concat(siteNumber, userAcceptanceStudySuffix).RemoveNonAlphanumeric()
                            }
                        },
                        ProtocolNumber = studyName.Replace("_", "")
                    },
                    new StudySetupData()
                    {
                        StudyType    = StudyType.Dev,
                        StudyName    = String.Concat(studyName, " ", developmentStudySuffix),
                        ExternalOid  = String.Concat(studyExternalOid, developmentStudySuffix).RemoveNonAlphanumeric(),
                        IsProduction = false,
                        Sites        = new SiteSetupData[]
                        {
                            new SiteSetupData
                            {
                                SiteName   = String.Concat(siteName, " ", developmentStudySuffix),
                                SiteNumber = String.Concat(siteNumber, developmentStudySuffix).RemoveNonAlphanumeric()
                            }
                        },
                        ProtocolNumber = studyName.Replace("_", "")
                    }
                }
            };

            return newStudyGroup;
        }

        [AfterScenario("CoderCore")]
        public void AfterCoreScenario()
        {
            if (!ReferenceEquals(_StepContext.Browser, null))
            {
                var testPassed = ReferenceEquals(ScenarioContext.Current.TestError, null);

                if (testPassed)
                {
                    try
                    {
                        TaskAttempt.TryAction(_StepContext.Browser.CleanUpCodingTasks, TimeSpan.FromSeconds(30));
                }
                    catch(Exception ex)
                    {
                        Console.WriteLine(String.Format("Error cleaning up tasks after test pass: {0}", ex));
                    }
                }

                CommonAfterScenario();

                if (testPassed)
                {
                    CoderUserGenerator.DeleteGeneratedUser(_StepContext.CoderTestUser, _StepContext.SegmentUnderTest);
                }
            }
        }

        [AfterScenario("ApplicationMonitoring")]
        public void AfterApplicationMonitoringScenario()
        {
            CommonAfterScenario();

            AssertTestWasConclusive(_StepContext);
        }

        [AfterScenario("EditGlobalRaveConfiguration")]
        public void AfterEditGlobalRaveConfigurationScenario()
        {
            var browser = _StepContext.Browser;
            var configurationSetting = new RaveCoderGlobalConfiguration
            {
                ReviewMarkingGroup = Config.DefaultReviewMarkingGroupValue,
                IsRequiresResponse = Config.DefaultRequiresResponseValue
            };

            browser.EditGlobalRaveConfiguration(configurationSetting);

            CommonAfterScenario();
        }

        [AfterScenario("EndToEndDynamicSegment")]
        [AfterScenario("EndToEndDynamicStudy")]
        [AfterScenario("EndToEndStaticSegment")]
        [AfterScenario("Deployment")]
        private void CommonAfterScenario()
        {
            var browser = _StepContext.Browser;

            if (!ReferenceEquals(browser, null))
            {

                Console.WriteLine("Test run with user: {0}", _StepContext.GetUser());

                var error = ScenarioContext.Current.TestError;

                if (!ReferenceEquals(error, null))
                {
                    var fileName = "ScenarioError_" + error.TargetSite;

                    browser.SaveScreenshot(fileName);

                    Console.WriteLine("An error occurred with user: " + _StepContext.GetUser());
                    Console.WriteLine("Error: "+ error.Message);
                }
                browser.Dispose();
            }

            ScenarioContext.Current.Clear();

            #if !DEBUG
                RemoveTempDirectoryByName(_StepContext.DownloadDirectory);
                RemoveTempDirectoryByName(_StepContext.DumpDirectory);
            #endif
        }

        [AfterTestRun]
        public static void AfterTestRun()
        {

        }

        private static void AssertTestWasConclusive(StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null)) throw new ArgumentNullException("stepContext");

            if (stepContext.IsAutoApproval.EqualsIgnoreCase("false") &&
                stepContext.IsApprovalRequired.EqualsIgnoreCase("true"))
            {
                Assert.Inconclusive("Coding decision for task required manual approval. The autoworkflow service may not be functional.");
            }
        }

        private static void CreateScreenshotDirectory()
        {
            var screenshotDirectory = BrowserUtility.GetScreenshotDirectory();

            CreateTempDirectoryByName(screenshotDirectory);
        }

        private static string CreateUserDirectory(string parentDirectory, string loginId)
        {
            if (String.IsNullOrWhiteSpace(parentDirectory)) throw new ArgumentNullException("parentDirectory");
            if (String.IsNullOrWhiteSpace(loginId)) throw new ArgumentNullException("loginId");

            var directoryName = Path.Combine(parentDirectory, loginId);

            CreateTempDirectoryByName(directoryName);

            return directoryName;
        }

        private static void CreateTempDirectoryByName(string directoryName)
        {
            if (String.IsNullOrEmpty(directoryName)) throw new ArgumentNullException("directoryName");

            if (!Directory.Exists(directoryName))
            {
                Directory.CreateDirectory(directoryName);
            }
        }

        private static void RemoveTempDirectoryByName(string directoryName)
        {
            if (String.IsNullOrEmpty(directoryName)) throw new ArgumentNullException("directoryName");

            if (Directory.Exists(directoryName))
            {
                Directory.Delete(directoryName, true);
            }
        }
    }
}