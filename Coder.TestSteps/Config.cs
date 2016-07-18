using System;
using System.Configuration;
using System.IO;

namespace Coder.TestSteps
{
    internal static class Config
    {
        internal static string CoderDbConnectionString
        {
            get
            {
                var coderConnectionStringSettings = ConfigurationManager.ConnectionStrings["coder"];

                if (ReferenceEquals(coderConnectionStringSettings, null))                  throw new ConfigurationErrorsException("coder");
                if (String.IsNullOrEmpty(coderConnectionStringSettings.ConnectionString))  throw new ConfigurationErrorsException("ConnectionString"); 

                return coderConnectionStringSettings.ConnectionString;
            }
        }

        internal static string ParentDumpDirectory 
        {
            get
            {
                var dumpDirectory = ConfigurationManager.AppSettings["DumpDirectory"];

                if (String.IsNullOrEmpty(dumpDirectory)) throw new ConfigurationErrorsException("DumpDirectory");

                return dumpDirectory;
            }
        }

        internal static string ParentDownloadDirectory
        {
            get
            {
                var downloadDirectory = ConfigurationManager.AppSettings["DownloadDirectory"];

                if (String.IsNullOrEmpty(downloadDirectory)) throw new ConfigurationErrorsException("DownloadDirectory");

                return downloadDirectory;
            }
        }

        internal static string Login
        {
            get
            {
                var configuredLogin = ConfigurationManager.AppSettings["Login"];

                if (String.IsNullOrWhiteSpace(configuredLogin))
                {
                    throw new ConfigurationErrorsException("Login");
                }

                return configuredLogin;
            }
        }

        internal static string AdminLogin
        {
            get
            {
                var adminLogin = ConfigurationManager.AppSettings["AdminLogin"];

                if (String.IsNullOrWhiteSpace(adminLogin))
                {
                    throw new ConfigurationErrorsException("AdminLogin");
                }

                return adminLogin;
            }
        }

        internal static string RaveAdminLogin
        {
            get
            {
                var raveAdminLogin = ConfigurationManager.AppSettings["RaveAdminLogin"];

                if (String.IsNullOrWhiteSpace(raveAdminLogin))
                {
                    throw new ConfigurationErrorsException("RaveAdminLogin");
                }

                return raveAdminLogin;
            }
        }

        internal static string NewGeneratedSegment
        {
            get
            {
                var newSegment = ConfigurationManager.AppSettings["NewGeneratedSegment"];

                if (String.IsNullOrWhiteSpace(newSegment))
                {
                    throw new ConfigurationErrorsException("NewGeneratedSegment");
                }

                return newSegment;
            }
        }

        internal static string Password
        {
            get
            {
                var configuredPassword = ConfigurationManager.AppSettings["Password"];

                if (String.IsNullOrWhiteSpace(configuredPassword))
                {
                    throw new ConfigurationErrorsException("Password");
                }

                return configuredPassword;
            }
        }

        internal static string AdminPassword
        {
            get
            {
                var configuredPassword = ConfigurationManager.AppSettings["AdminLoginPassword"];

                if (String.IsNullOrWhiteSpace(configuredPassword))
                {
                    throw new ConfigurationErrorsException("AdminLoginPassword");
                }

                return configuredPassword;
            }
        }

        internal static string RaveAdminPassword
        {
            get
            {
                var raveAdminPassword = ConfigurationManager.AppSettings["RaveAdminPassword"];

                if (String.IsNullOrWhiteSpace(raveAdminPassword))
                {
                    throw new ConfigurationErrorsException("RaveAdminPassword");
                }

                return raveAdminPassword;
            }
        }

        internal static string ApplicationName
        {
            get
            {
                var applicationName = ConfigurationManager.AppSettings["ApplicationName"];

                if (String.IsNullOrEmpty(applicationName)) throw new ConfigurationErrorsException("ApplicationName");

                return applicationName;
            }
        }

        internal static string CoderRole
        {
            get
            {
                var coderRole = ConfigurationManager.AppSettings["CoderRole"];

                if (String.IsNullOrEmpty(coderRole)) throw new ConfigurationErrorsException("CoderRole");

                return coderRole;
            }
        }

        internal static string ApplicationCsvFolder
        {
            get
            {
                var applicationFolder = ApplicationName.Replace(" ", string.Empty) + "\\";

                return applicationFolder;
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

        internal static string StudyNamePrefix 
        {
            get
            {
                var studyNamePrefix = ConfigurationManager.AppSettings["StudyNamePrefix"];
                
                if (String.IsNullOrWhiteSpace(studyNamePrefix)) throw new ConfigurationErrorsException("StudyNamePrefix");

                return studyNamePrefix;
            }
        }

        internal static string StudyName
        {
            get
            {
                var studyName = ConfigurationManager.AppSettings["StudyName"];

                if (String.IsNullOrWhiteSpace(studyName)) throw new ConfigurationErrorsException("StudyName");

                return studyName;
            }
        }

        internal static string Site
        {
            get
            {
                var site = ConfigurationManager.AppSettings["Site"];

                if (String.IsNullOrWhiteSpace(site)) throw new ConfigurationErrorsException("Site");

                return site;
            }
        }

        internal static int TimeStampHoursDiff
        {
            get
            {
                var timeStampHoursDiffConfig = ConfigurationManager.AppSettings["TimeStampHoursDiff"];

                var timeStampHoursDiff = 0;

                if (String.IsNullOrWhiteSpace(timeStampHoursDiffConfig))
                    timeStampHoursDiff = 24;

                var canParse = Int32.TryParse(timeStampHoursDiffConfig, out timeStampHoursDiff);

                if (!canParse)
                {
                    throw new ConfigurationErrorsException(String.Format("Cannot parse {0} into integer", timeStampHoursDiffConfig));
                }
                
                return timeStampHoursDiff;
            }
        }

        internal static string MedDra15DdmFileName
        {
            get
            {
                return "MedDRA_15_0_ENG_DDM_Terms.json";
            }
        }

        internal static string WhoDrugTermsFileName
        {
            get
            {
                return "WhoDrug_Terms.json";
            }
        }

        internal static string MevDownloadFailuresFileName
        {
            get
            {
                return "Mev_Download_Failures.json";
            }
        }

        internal static string CRFDraftDownloadFailureFileName
        {
            get
            {
                return "ErrorGeneratingCRFDraft.xls";
            }
        }

        internal static string StaticContentFolder
        {
            get
            {
                var baseDirectory = AppDomain.CurrentDomain.BaseDirectory;

                if (string.IsNullOrWhiteSpace(baseDirectory)) throw new NullReferenceException("baseDirectory");

                var staticContentFolder = Path.Combine(baseDirectory, "StaticContent");

                return staticContentFolder;
            }
        }

        internal static string DefaultReclassficationComment
        {
            get
            {
                return "Reclassify Task Test Comment";
            }
        }

        internal static string Segment
        {
            get
            {
                var configuredSegment = ConfigurationManager.AppSettings["Segment"];

                if (String.IsNullOrWhiteSpace(configuredSegment))
                {
                    throw new ConfigurationErrorsException("Segment");
                }

                return configuredSegment;
            }
        }

        internal static string SetupSegment
        {
            get
            {
                var setupSegment = ConfigurationManager.AppSettings["SetupSegment"];

                if (String.IsNullOrEmpty(setupSegment)) throw new ConfigurationErrorsException("SetupSegment");

                return setupSegment;
            }
        }

        internal static string ETESetupSuffix
        {
            get
            {
                var setupSuffix = ConfigurationManager.AppSettings["ETESetupSuffix"];

                if (String.IsNullOrEmpty(setupSuffix)) throw new ConfigurationErrorsException("ETESetupSuffix");

                return setupSuffix;
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

        internal static string RaveEDC
        {
            get
            {
                var raveEDC = ConfigurationManager.AppSettings["RaveEDC"];

                if (String.IsNullOrEmpty(raveEDC)) throw new ConfigurationErrorsException("RaveEDC");

                return raveEDC;
            }
        }

        internal static string RaveEDCAppRole
        {
            get
            {
                var raveEDCAppRole = ConfigurationManager.AppSettings["EDCAppRole"];

                if (String.IsNullOrEmpty(raveEDCAppRole)) throw new ConfigurationErrorsException("EdcAppRole");

                return raveEDCAppRole;
            }
        }

        internal static string RaveModules
        {
            get
            {
                var raveModules = ConfigurationManager.AppSettings["RaveModules"];

                if (String.IsNullOrEmpty(raveModules)) throw new ConfigurationErrorsException("RaveModules");

                return raveModules;
            }
        }

        internal static string RaveModulesAppRole
        {
            get
            {
                var raveModulesAppRole = ConfigurationManager.AppSettings["EdcModulesAppRole"];

                if (String.IsNullOrEmpty(raveModulesAppRole)) throw new ConfigurationErrorsException("EdcModulesAppRole");

                return raveModulesAppRole;
            }
        }

        internal static string RaveArchitectRole
        {
            get
            {
                var raveArchitectRole = ConfigurationManager.AppSettings["RaveArchitectRoleApp"];

                if (String.IsNullOrEmpty(raveArchitectRole)) throw new ConfigurationErrorsException("RaveArchitectRoleApp");

                return raveArchitectRole;
            }
        }

        internal static string RaveArchitectRoleAppRole
        {
            get
            {
                var raveArchitectRoleAppRole = ConfigurationManager.AppSettings["ArchitectRoleAppRole"];

                if (String.IsNullOrEmpty(raveArchitectRoleAppRole)) throw new ConfigurationErrorsException("RaveArchitectRoleAppRole");

                return raveArchitectRoleAppRole;
            }
        }
    }
}