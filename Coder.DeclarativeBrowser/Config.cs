using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Configuration;
using System.Data.SqlClient;
using System.Dynamic;
using System.Linq;
using Coypu;
using Coypu.Drivers;
using CsvHelper;
using CsvHelper.Configuration;
using Polly;
using NUnit.Framework;
using Coder.DeclarativeBrowser.Models;

namespace Coder.DeclarativeBrowser
{
    internal static class Config
    {
        internal static readonly Browser BrowserDriver   = Browser.Firefox;

        internal const String EmptyHtmlValue     = "&nbsp;";
        internal const String NewUserPassword    = "Password5";
        internal const String ActiveUserPassword = "Password1";
        internal const String NewUserLocale      = "eng";
        internal const String NewUserTimeZone    = "Eastern Time (US & Canada)";
        internal const String NewUserFirstName   = "Coder";
        internal const String NewUserLastName    = "User";
        internal const String NewUserTelephone   = "800-888-9876";

        internal static string CoderDbConnectionString
        {
            get
            {
                var coderConnectionStringSettings = ConfigurationManager.ConnectionStrings["coder"];

                if (ReferenceEquals(coderConnectionStringSettings, null))                  throw new ConfigurationErrorsException("coder");
                if (String.IsNullOrEmpty(coderConnectionStringSettings.ConnectionString))  throw new NullReferenceException("ConnectionString"); 

                return coderConnectionStringSettings.ConnectionString;
            }
        }

        internal static string ELearningLoginTitle
        {
            get
            {
                var eLearningLoginTitle = ConfigurationManager.AppSettings["ELearningLoginTitle"];

                if (String.IsNullOrEmpty(eLearningLoginTitle)) throw new ConfigurationErrorsException("ELearningLoginTitle");

                return eLearningLoginTitle;
            }
        }

        internal static string HelpWindowName
        {
            get
            {
                var helpWindowName = ConfigurationManager.AppSettings["ScreenHelpWindowName"];

                if (String.IsNullOrEmpty(helpWindowName))     throw new ConfigurationErrorsException("HelpWindowName"); 

                return helpWindowName;
            }
        }

        internal static string HelpCenterWindowName
        {
            get
            {
                var helpCenterWindowName = ConfigurationManager.AppSettings["HelpCenterWindowName"];

                if (String.IsNullOrEmpty(helpCenterWindowName))     throw new ConfigurationErrorsException("HelpCenterWindowName"); 

                return helpCenterWindowName;
            }
        }

        internal static string AdminLogin
        {
            get
            {
                var adminLogin = ConfigurationManager.AppSettings["AdminLogin"];

                if (String.IsNullOrEmpty(adminLogin))               throw new ConfigurationErrorsException("AdminLogin"); 

                return adminLogin;
            }
        }

        internal static string AdminLoginPassword
        {
            get
            {
                var adminLoginPassword = ConfigurationManager.AppSettings["AdminLoginPassword"];

                if (String.IsNullOrEmpty(adminLoginPassword))       throw new ConfigurationErrorsException("AdminLoginPassword"); 

                return adminLoginPassword;
            }
        }

        internal static string StudyAdminLogin
        {
            get
            {
                var StudyAdminLogin = ConfigurationManager.AppSettings["StudyAdminLogin"];

                if (String.IsNullOrEmpty(StudyAdminLogin))               throw new ConfigurationErrorsException("StudyAdminLogin"); 

                return StudyAdminLogin;
            }
        }

        internal static string StudyAdminLoginPassword
        {
            get
            {
                var StudyAdminLoginPassword = ConfigurationManager.AppSettings["StudyAdminLoginPassword"];

                if (String.IsNullOrEmpty(StudyAdminLoginPassword)) throw new ConfigurationErrorsException("StudyAdminLoginPassword"); 

                return StudyAdminLoginPassword;
            }
        }

        internal static string AppHost
        {
            get
            {
                var appHost = ConfigurationManager.AppSettings["AppHost"];

                if (String.IsNullOrEmpty(appHost)) throw new ConfigurationErrorsException("AppHost"); 

                return appHost;
            }
        }

        internal static string RaveHost
        {
            get
            {
                var raveHost = ConfigurationManager.AppSettings["RaveHost"];

                if (String.IsNullOrEmpty(raveHost)) throw new ConfigurationErrorsException("RaveHost");

                return raveHost;
            }
        }

        internal static string LocalHost
        {
            get
            {
                var localHost = ConfigurationManager.AppSettings["LocalHost"];

                if (String.IsNullOrEmpty(localHost))                throw new ConfigurationErrorsException("LocalHost"); 

                return localHost;
            }
        }

        internal static string ScreenshotDirectoryName
        {
            get
            {
                var screenshotDirectoryName = ConfigurationManager.AppSettings["ScreenshotDirectoryName"];

                if (String.IsNullOrEmpty(screenshotDirectoryName))      throw new ConfigurationErrorsException("ScreenshotDirectoryName"); 

                return screenshotDirectoryName;
            }
        }

        internal static string FirefoxExecutablePath
        {
            get
            {
                var firefoxExecutablePath = ConfigurationManager.AppSettings["FirefoxExecutablePath"];

                if (String.IsNullOrEmpty(firefoxExecutablePath))    throw new ConfigurationErrorsException("FirefoxExecutablePath");

                return firefoxExecutablePath;
            }
        }

        internal static string ApplicationName
        {
            get
            {
                var applicationName = ConfigurationManager.AppSettings["ApplicationName"];

                if (String.IsNullOrEmpty(applicationName))          throw new ConfigurationErrorsException("ApplicationName");

                return applicationName;
            }
        }

        internal static string LicenseCode
        {
            get
            {
                var licenseCode = ConfigurationManager.AppSettings["LicenseCode"];

                if (String.IsNullOrEmpty(licenseCode)) throw new ConfigurationErrorsException("LicenseCode");

                return licenseCode;
            }
        }

        internal static string DateTimeFormat
        {
            get
            {
                var dateTimeFormat = ConfigurationManager.AppSettings["DateTimeFormat"];

                if (ReferenceEquals(dateTimeFormat, null)) throw new ConfigurationErrorsException("DateTimeFormat");

                return dateTimeFormat;
            }
        }

        internal static string BrowserAutoSaveFileTypes
        {
            get
            {
                var browserAutoSaveFileTypes = ConfigurationManager.AppSettings["BrowserAutoSaveFileTypes"];

                if (String.IsNullOrEmpty(browserAutoSaveFileTypes)) throw new ConfigurationErrorsException("BrowserAutoSaveFileTypes");

                return browserAutoSaveFileTypes;
            }
        }

        internal static string DefaultSynonymListName
        {
            get
            {
                var synonymListName = ConfigurationManager.AppSettings["DefaultSynonymListName"];
                
                if (String.IsNullOrWhiteSpace(synonymListName)) throw new ConfigurationErrorsException("DefaultSynonymListName");

                return synonymListName;
            }
        }

        internal static readonly IDictionary<String, String> TermLevelFromStyleAttribute =
            new ReadOnlyDictionary<String, String>(
                new Dictionary<String, String>
        {
                    {"pSOC.gif"              , "SOC" },
                    {"pHLGT.gif"             , "HLGT"},
                    {"pHLT.gif"              , "HLT" },
                    {"pPT.gif"               , "PT"  },
                    {"pLLT.gif"              , "LLT" },
                    {"SOC.gif"               , "SOC" },
                    {"HLGT.gif"              , "HLGT"},
                    {"HLT.gif"               , "HLT" },
                    {"PT.gif"                , "PT"  },
                    {"LLT.gif"               , "LLT" },
                    {"PRODUCT.gif"           , "PN"  },
                    {"ATC.gif"               , "ATC" },
                    {"PRODUCTSYNONYM.gif"    , "TN"  },
                    {"INGREDIENT.gif"        , "ING" },
                    {"HighLevelClass.gif"    , "大"  },
                    {"MidLevelClass.gif"     , "中"  },
                    {"LowLevelClass.gif"     , "小"  },
                    {"DetailedClass.gif"     , "細"  },
                    {"PreferredName.gif"     , "般"  },
                    {"Category.gif"          , "区"  },
                    {"DrugName.gif"          , "薬"  }
                });

        internal static Options GetDefaultCoypuOptions()
        {
            var timeOut         = OptionsTimeOut;
            var retryInterval   = OptionsRetryInterval;

            var options = new Options
            {
                Timeout         = TimeSpan.FromSeconds(timeOut),
                RetryInterval   = TimeSpan.FromSeconds(retryInterval)
            };

            return options;
        }

        internal static Options GetDefaultTransmissionOptions()
        {
            var timeOut       = TransmissionOptionsTimeOut;
            var retryInterval = TransmissionOptionsRetryInterval;

            var options = new Options
            {
                Timeout = TimeSpan.FromSeconds(timeOut),
                RetryInterval = TimeSpan.FromSeconds(retryInterval)
            };

            return options;
        }

        private static int OptionsTimeOut
        {
            get
            {
                var timeOutString = ConfigurationManager.AppSettings["DefaultCoypuOptionsTimeOut"] ?? "60";

                int timeOut;
                if (!Int32.TryParse(timeOutString, out timeOut))
                {
                    throw new ConfigurationErrorsException("DefaultCoypuOptionsTimeOut");
                };

                return timeOut;
            }
        }

        private static double OptionsRetryInterval
        {
            get
            {
                var retryIntervalString = ConfigurationManager.AppSettings["DefaultCoypuOptionsRetryInterval"] ?? "1";

                double retryInterval;
                if (!Double.TryParse(retryIntervalString, out retryInterval))
                {
                    throw new ConfigurationErrorsException("DefaultCoypuOptionsRetryInterval");
                };

                return retryInterval;
            }
        }

        private static int TransmissionOptionsTimeOut
        {
            get
            {
                var timeOutString = ConfigurationManager.AppSettings["DefaultTransmissionOptionsTimeOut"] ?? "75";

                int timeOut;
                if (!Int32.TryParse(timeOutString, out timeOut))
                {
                    throw new ConfigurationErrorsException("DefaultTransmissionOptionsTimeOut");
                };

                return timeOut;
            }
        }

        private static double TransmissionOptionsRetryInterval
        {
            get
            {
                var retryIntervalString = ConfigurationManager.AppSettings["DefaultTransmissionOptionsRetryInterval"] ?? "1";

                double retryInterval;
                if (!Double.TryParse(retryIntervalString, out retryInterval))
                {
                    throw new ConfigurationErrorsException("DefaultTransmissionOptionsRetryInterval");
                };

                return retryInterval;
            }
        }

        internal static Options LongExistsOptions
        {
            get
            {
                var options = new Options
                {
                    Timeout = TimeSpan.FromMilliseconds(5000),
                    RetryInterval = TimeSpan.FromMilliseconds(500)
                };

                return options;
            }
        }

        internal static Options ExistsOptions
        {
            get
            {
                var options = new Options
                {
                    Timeout = TimeSpan.FromMilliseconds(1000),
                    RetryInterval = TimeSpan.FromMilliseconds(500)
                };

                return options;
            }
        }

        internal static Options InstantOptions
        {
            get
            {
                var options = new Options
                {
                    Timeout       = TimeSpan.FromTicks(100),
                    RetryInterval = TimeSpan.FromTicks(100)
                };

                return options;
            }
        }

        internal static Options GetLoadingCoypuOptions()
        {
            var timeOut       = LoadingOptionsTimeOut;
            var retryInterval = LoadingOptionsRetryInterval;

            var options       = new Options
            {
                Timeout       = TimeSpan.FromSeconds(timeOut),
                RetryInterval = TimeSpan.FromSeconds(retryInterval)
            };

            return options;
        }

        private static int LoadingOptionsTimeOut
        {
            get
            {
                return 240;
            }
        }

        private static double LoadingOptionsRetryInterval
        {
            get
            {
                return 1;
            }
        }

        internal static string SynonymListTemplate
        {
            get
            {
                var synonymListTemplate = ConfigurationManager.AppSettings["SynonymListTemplate"];

                if (String.IsNullOrEmpty(synonymListTemplate)) throw new ConfigurationErrorsException("SynonymListTemplate");

                return synonymListTemplate;
            }
        }

        internal static Policy FindElementShortPolicy
        {
            get
            {
                var policy = Policy
                    .Handle<MissingHtmlException>()
                    .WaitAndRetry(5, retryAttempt =>
                        TimeSpan.FromMilliseconds(500));

                return policy;
            }
        }

        internal static Policy GetUploadCompletedPolicy
        {
            get
            {
                var policy = Policy
                    .Handle<AssertionException>()
                    .Or<NullReferenceException>()
                    .WaitAndRetry(
                        from attempt in Enumerable.Range(1, 10)
                        select TimeSpan.FromSeconds(Math.Pow(2, attempt)));

                return policy;
            }
        }

        internal static Policy StoredProcRetryPolicy
        {
            get
            {
                var policy = Policy
                    .Handle<SqlException>()
                    .Or<InvalidOperationException>()
                    .WaitAndRetry(
                        from attempt in Enumerable.Range(1,6)
                        select TimeSpan.FromSeconds(Math.Pow(2, attempt)));

                return policy;
            }
        }

        internal static int ScreenWidth
        {
            get
            {
                var screenWidthConfig = ConfigurationManager.AppSettings["BuildAgentScreenWidth"] ?? "1024";

                int widthOut;
                if (!Int32.TryParse(screenWidthConfig, out widthOut))
                {
                    throw new ConfigurationErrorsException("BuildAgentScreenWidth");
                }

                return widthOut;
            }
        }

        internal static int ScreenHeight
        {
            get
            {
                var screenHeightConfig = ConfigurationManager.AppSettings["BuildAgentScreenHeight"] ?? "768";

                int heightOut;
                if (!Int32.TryParse(screenHeightConfig, out heightOut))
                {
                    throw new ConfigurationErrorsException("BuildAgentScreenHeight");
                }

                return heightOut;
            }
        }

        internal static string CoderWsUri
        {
            get
            {
                var coderWsUri = ConfigurationManager.AppSettings["CoderWsUri"];
                
                if (String.IsNullOrWhiteSpace(coderWsUri))
                {
                    throw new ConfigurationErrorsException("CoderWsUri");
                }

                return coderWsUri;
            }
        }

        internal static Options SynonymFileCopyuOptions()
        {
            var options = new Options
            {
                RetryInterval   =   TimeSpan.FromSeconds(20),
                Timeout         =   TimeSpan.FromSeconds(1800)
            };

            return options;
        }

        internal static Options ConfigFileCopyuOptions()
        {
            var options = new Options
            {
                RetryInterval = TimeSpan.FromSeconds(1),
                Timeout = TimeSpan.FromMinutes(5)
            };

            return options;
        }
       
        internal static string DefaultSubjectKey
        {
            get
            {
                return "Subject 1";
            }
        }

        internal static string DefaultFormKey
        {
            get
            {
                return "Form 1";
            }
        }

        internal static string DefaultFieldKey
        {
            get
            {
                return "Field 1";
            }
        }

        internal static string DefaultSiteKey
        {
            get
            {
                return "Site 1";
            }
        }

        internal static string DefaultEventKey
        {
            get
            {
                return "Event 1";
            }
        }

        internal static string DefaultLineKey
        {
            get
            {
                return "Line 1";
            }
        }

        internal static string DefaultPriority
        {
            get
            {
                return "1";
            }
        }

        internal static string DefaultLogLine
        {
            get
            {
                return "1";
            }
        }

        internal static string DefaultBatchIdentifier
        {
            get
            {
                return "Batch 1";
            }
        }

        internal static string DefaultSupplementalField
        {
            get
            {
                return "SupplementalField";
            }
        }

        internal static string DefaultSupplementalValue
        {
            get
            {
                return "SupplementalValue";
            }
        }

        internal static string CodingHistoryReportFileName
        {
            get
            {
                return "CodingHistoryReport.csv";
            }
        }

        internal static string CodingDecisionsReportFileName
        {
            get
            {
                return "CodingDecisionsReport.csv";
            }
        }

        internal static int DefaultMevFileCount
        {
            get
            {
                return 1;
            }
        }

        private static string TestThreadId
        {
            get
            {
                var testThreadId = ConfigurationManager.AppSettings["SpecRunThreadId"];

                if (String.IsNullOrWhiteSpace(testThreadId))
                {
                    return String.Empty;
                }

                return testThreadId;
            }
        }

        internal static string[,] CoderDictionaries
        {
            get
            {
                var coderDictionaries = new string[,]
                {
                    {"MedDRA"           , "eng"},
                    {"MedDRA"           , "jpn"},
                    {"WHODrug-DD-B2"    , "eng"},
                    {"WHODrug-DD-C"     , "eng"},
                    {"WHODrug-DDE_HD-B2", "eng"},
                    {"WHODrug-DDE_HD-C" , "eng"},
                    {"WHODrug-DDE-B2"   , "eng"},
                    {"WHODrug-DDE-C"    , "eng"},
                    {"AZDD"             , "eng"},
                    {"JDrug"            , "eng"},
                    {"JDrug"            , "jpn"}
                };

                return coderDictionaries;
            }
        }

        internal static Tuple<int, string, int[]>[] CoderGeneralRoles 
        {
            get
            {
                int[] segmentAdminActions     = { 13, 14, 15, 16, 17, 18, 19, 28, 29, 30 };
                int[] studyAdminActions       = { 20, 21, 22, 23, 24, 25, 27 };
                int[] dictionaryAdminActions  = { 6, 7, 8, 9, 10, 12, 32, 33 };
                int[] mevAdminActions         = { 34 };

                var generalRoles = new Tuple<int, string, int[]>[]
                {
                    Tuple.Create(4, "SegmentAdmin", segmentAdminActions),
                    Tuple.Create(2, "StudyAdmin", studyAdminActions),
                    Tuple.Create(3, "DictionaryAdmin", dictionaryAdminActions),
                    Tuple.Create(4, "ExternalVerbatimAdmin", mevAdminActions)
                };

                return generalRoles;
            }
        }

        internal static string DevelopmentStudySuffix
        {
            get
            {
                return "(Dev)";
            }
        }

        internal static string UserAcceptanceStudySuffix
        {
            get
            {
                return "(UAT)";
            }
        }

        internal static Uri GridHubHost
        {
            get
            {
                var isGridConfigured = IsGridConfigured;

                if (!isGridConfigured)
                {
                    throw new ConfigurationErrorsException("GridHubHost is not set, use local Selenium or configure Grid");
                }

                var configuredHost    = ConfiguredGridHubHost;
                var configuredHostUri = new Uri(configuredHost);

                return configuredHostUri;
            }
        }

        internal static bool IsGridConfigured
        {
            get
            {
                var configuredHost = ConfiguredGridHubHost;

                if (String.IsNullOrWhiteSpace(configuredHost))
                {
                    return false;
                }

                return true;
            }
        }

        private static string ConfiguredGridHubHost
        {
            get 
            {
                var configuredHost = ConfigurationManager.AppSettings["GridHubHost"];

                if (ReferenceEquals(configuredHost, null))
                {
                    configuredHost = String.Empty;
                }

                return configuredHost;
            }
        }

        public static string IngredientReportFileName
        {
            get
            {
                var fileName = ConfigurationManager.AppSettings["IngredientReportFileName"];

                if (String.IsNullOrWhiteSpace(fileName))
                {
                    fileName = "IngredientReport.csv";
                }

                return fileName;
            }
        }

        internal static void SetCsvReaderConfig(CsvReader csv)
        {
            if (ReferenceEquals(csv,null)) throw new ArgumentNullException("csv");
            
            csv.Configuration.HasHeaderRecord         = true;
            csv.Configuration.IgnoreHeaderWhiteSpace  = true;
            csv.Configuration.WillThrowOnMissingField = false;
            csv.Configuration.IsHeaderCaseSensitive   = false;
            csv.Configuration.Quote                   = '"';
        }

        internal static string IMedidataHost
        {
            get
            {
                var mAuthHost = ConfigurationManager.AppSettings["IMedidataHost"];

                if (String.IsNullOrWhiteSpace(mAuthHost))
                {
                    throw new ConfigurationErrorsException("IMedidataHost");
                }

                return mAuthHost;
            }
        }

        internal static string IMedidataCoderAppId
        {
            get
            {
                var mAuthAppId = ConfigurationManager.AppSettings["IMedidataAppId"];

                if (String.IsNullOrWhiteSpace(mAuthAppId))
                {
                    throw new ConfigurationErrorsException("IMedidataAppId");
                }

                return mAuthAppId;
            }
        }

        internal static string IMedidataPrivateKeyPath
        {
            get
            {
                var relativePath = ConfigurationManager.AppSettings["IMedidataPrivateKeyPath"];

                if (String.IsNullOrWhiteSpace(relativePath))
                {
                    throw new ConfigurationErrorsException("IMedidataPrivateKeyPath");
                }

                return relativePath;
            }
        }

        internal static string TestSegmentCustomer
        {
            get
            {
                var customer = ConfigurationManager.AppSettings["TestSegmentCustomer"];

                if (String.IsNullOrWhiteSpace(customer))
                {
                    customer = "Medidata Testing";
                }

                return customer;
            }
        }

        internal static string EdcAppName
        {
            get
            {
                var appName = ConfigurationManager.AppSettings["EdcAppName"];

                if (String.IsNullOrWhiteSpace(appName))
                {
                    throw new ConfigurationErrorsException("EdcAppName");
                }

                return appName;
            }
        }

        internal static string EdcModulesAppName
        {
            get
            {
                var appName = ConfigurationManager.AppSettings["EdcModulesAppName"];

                if (String.IsNullOrWhiteSpace(appName))
                {
                    throw new ConfigurationErrorsException("EdcModulesAppName");
                }

                return appName;
            }
        }

        internal static string ArchitectRoleAppName
        {
            get
            {
                var appName = ConfigurationManager.AppSettings["ArchitectRoleAppName"];

                if (String.IsNullOrWhiteSpace(appName))
                {
                    throw new ConfigurationErrorsException("ArchitectRoleAppName");
                }

                return appName;
            }
        }

        internal static string SafetyGatewayMappingAppName
        {
            get
            {
                var appName = ConfigurationManager.AppSettings["SafetyGatewayMappingAppName"];

                if (String.IsNullOrWhiteSpace(appName))
                {
                    appName = String.Empty;
                }

                return appName;
            }
        }

        internal static string SafetyGatewayManagementAppName
        {
            get
            {
                var appName = ConfigurationManager.AppSettings["SafetyGatewayManagementAppName"];

                if (String.IsNullOrWhiteSpace(appName))
                {
                    appName = String.Empty;
                }

                return appName;
            }
        }

        internal static string EdcAppRole
        {
            get
            {
                var roleName = ConfigurationManager.AppSettings["EdcAppRole"];

                if (String.IsNullOrWhiteSpace(roleName))
                {
                    throw new ConfigurationErrorsException("EdcAppRole");
                }

                return roleName;
            }
        }

        internal static string EdcModulesAppRole
        {
            get
            {
                var roleName = ConfigurationManager.AppSettings["EdcModulesAppRole"];

                if (String.IsNullOrWhiteSpace(roleName))
                {
                    throw new ConfigurationErrorsException("EdcModulesAppRole");
                }

                return roleName;
            }
        }

        internal static string ArchitectRoleAppRole
        {
            get
            {
                var roleName = ConfigurationManager.AppSettings["ArchitectRoleAppRole"];

                if (String.IsNullOrWhiteSpace(roleName))
                {
                    throw new ConfigurationErrorsException("ArchitectRoleAppRole");
                }

                return roleName;
            }
        }

        internal static string RaveDictionaryCoderPrefix
        {
            get
            {
                var raveDictionaryCoderPrefix = ConfigurationManager.AppSettings["RaveDictionaryCoderPrefix"];

                if (String.IsNullOrEmpty(raveDictionaryCoderPrefix)) throw new ConfigurationErrorsException("RaveDictionaryCoderPrefix");

                return raveDictionaryCoderPrefix;
            }
        }

        internal static IEnumerable<MedidataApp> GetStudyGroupApps()
        {
            var configuredStudyGroupApps = new[]
            {
                new MedidataApp
                {
                    Name = Config.ApplicationName
                },

                new MedidataApp
                {
                    Name = Config.EdcAppName,
                    Roles = new string[] { Config.EdcAppRole }
                },

                new MedidataApp
                {
                    Name = Config.EdcModulesAppName,
                    Roles = new string[] { Config.EdcModulesAppRole }
                },

                new MedidataApp
                {
                    Name = Config.ArchitectRoleAppName,
                    Roles = new string[] { Config.ArchitectRoleAppRole }
                },

                new MedidataApp
                {
                    Name = Config.SafetyGatewayManagementAppName
                },

                new MedidataApp
                {
                    Name = Config.SafetyGatewayMappingAppName
                },
            };

            return configuredStudyGroupApps;
        }

    }
}