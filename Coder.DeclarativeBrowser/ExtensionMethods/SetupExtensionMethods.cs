﻿using System;
using System.IO;
using System.Text;
using Coder.DeclarativeBrowser.Helpers;
using Coder.DeclarativeBrowser.Models;

namespace Coder.DeclarativeBrowser.ExtensionMethods
{
    public static class SetupExtensionMethods
    {
        public static void SetupStudyWithEmptySynonymList(
            this CoderDeclarativeBrowser browser,
            StepContext stepContext,
            string setupType, 
            SynonymList synonymList)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (ReferenceEquals(stepContext, null))             throw new ArgumentNullException("stepContext");
            if (String.IsNullOrEmpty(setupType))                throw new ArgumentNullException("setupType");
            if (ReferenceEquals(synonymList, null))             throw new ArgumentNullException("synonymList");

            browser.SetupCoderConfiguration(stepContext, setupType);

            stepContext.SetupType = setupType;

            browser.CleanUpCodingTasks();

            browser.CreateSynonymList(synonymList);
        }

        public static void SetupStudyWithRegisteredSynonymList(
            this CoderDeclarativeBrowser browser,
            StepContext stepContext,
            string setupType,
            SynonymList synonymList,
            string delimitedSynonym)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (ReferenceEquals(stepContext, null))             throw new ArgumentNullException("stepContext");
            if (String.IsNullOrEmpty(setupType))                throw new ArgumentNullException("setupType");
            if (ReferenceEquals(synonymList, null))             throw new ArgumentNullException("synonymList");

            browser.SetupCoderConfiguration(stepContext, setupType);

            stepContext.SetupType = setupType;

            browser.CleanUpCodingTasks();

            CoderDatabaseAccess.RegisterProject(
                project:                    stepContext.Project,
                segment:                    stepContext.Segment,
                dictionary:                 synonymList.Dictionary,
                dictionaryVersion:          synonymList.Version,
                locale:                     synonymList.Locale,
                synonymListName:            synonymList.SynonymListName,
                registrationName:           synonymList.Dictionary // TODO : enhance this to test registration name);
                );

            if (String.IsNullOrEmpty(delimitedSynonym))
            {
                return;
            }

            var synonymFilePath = CreateSynonymListUploadFile(delimitedSynonym, stepContext.DownloadDirectory);

            browser.UploadSynonymFile(synonymList, synonymFilePath);
        }

        public static void CreateUnactivatedSynonymList(
            this CoderDeclarativeBrowser browser,
            StepContext stepContext,
            SynonymList synonymList)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (ReferenceEquals(stepContext, null))             throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(synonymList, null))             throw new ArgumentNullException("synonymList");

            CoderDatabaseAccess.CreateSynonymList(
                segment:                    stepContext.Segment,
                dictionary:                 synonymList.Dictionary,
                dictionaryVersion:          synonymList.Version,
                locale:                     synonymList.Locale,
                synonymListName:            synonymList.SynonymListName
                );
        }

        public static void CreateActivatedSynonymList(
            this CoderDeclarativeBrowser browser,
            StepContext stepContext,
            SynonymList synonymList)
        {
            if (ReferenceEquals(browser, null))                 throw new ArgumentNullException("browser");
            if (ReferenceEquals(stepContext, null))             throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(synonymList, null))             throw new ArgumentNullException("synonymList");

            browser.CreateUnactivatedSynonymList(stepContext, synonymList);

            var adminSynonymPage = browser.Session.OpenAdminSynonymPage();

            adminSynonymPage.SelectSynonymList(synonymList);
            adminSynonymPage.GetUpgradeSynonymListLinkByListName(synonymList.SynonymListName).Click();
            adminSynonymPage.GetStartNewSynonymListButton().Click();
        }

        public static void CreateActivatedSynonymListWithSynonyms(
            this CoderDeclarativeBrowser browser,
            StepContext stepContext,
            SynonymList synonymList,
            string delimitedSynonym)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");
            if (ReferenceEquals(stepContext, null)) throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(synonymList, null)) throw new ArgumentNullException("synonymList");

            browser.CreateUnactivatedSynonymList(stepContext, synonymList);

            var adminSynonymPage = browser.Session.OpenAdminSynonymPage();

            adminSynonymPage.SelectSynonymList(synonymList);
            adminSynonymPage.GetUpgradeSynonymListLinkByListName(synonymList.SynonymListName).Click();
            adminSynonymPage.GetStartNewSynonymListButton().Click();
            
            if (!String.IsNullOrEmpty(delimitedSynonym))
            {
                var synonymFilePath = CreateSynonymListUploadFile(delimitedSynonym, stepContext.DownloadDirectory);

                browser.UploadSynonymFile(synonymList, synonymFilePath);
            }
        }

        public static void SetupCoderConfiguration(
            this CoderDeclarativeBrowser browser, 
            StepContext stepContext, 
            string configurationType)
        {
            if (ReferenceEquals(browser, null))          throw new ArgumentNullException("browser");
            if (ReferenceEquals(stepContext, null))      throw new ArgumentNullException("stepContext");   
            if (String.IsNullOrEmpty(configurationType)) throw new ArgumentNullException("configurationType");

            var coderTestContext   = browser.Session.GetCoderTestContext();
            var coderConfiguration = coderTestContext.GetCoderConfiguration(configurationType);

            coderTestContext.Set(
                coderConfiguration   : coderConfiguration,
                segment              : stepContext.Segment,
                dictionary           : stepContext.Dictionary,
                version              : stepContext.Version);

            stepContext.SetOdmTermApprovalContext(
                isAutoApproval    : coderConfiguration.IsTermAutoApproval,
                isApprovalRequired: coderConfiguration.IsTermApprovalRequired);
        }

        public static void SetupCodingTaskGroup(
            this CoderDeclarativeBrowser browser, 
            StepContext stepContext,
            string verbatim, 
            string dictionaryLevel, 
            int numberOfTasks)
        {
            if (ReferenceEquals(browser, null))             throw new ArgumentNullException("browser");
            if (ReferenceEquals(stepContext, null))         throw new ArgumentNullException("stepContext");
            if (String.IsNullOrWhiteSpace(verbatim))        throw new ArgumentNullException("verbatim");
            if (String.IsNullOrWhiteSpace(dictionaryLevel)) throw new ArgumentNullException("dictionaryLevel");
            if (numberOfTasks <= 0)                         throw new ArgumentOutOfRangeException("numberOfTasks");

            var study = stepContext.SegmentUnderTest.ProdStudy;

            for (var i = 0; i < numberOfTasks; i++)
            {
                BrowserUtility.CreateNewTask(stepContext, verbatim, dictionaryLevel);
            }

            var taskPage = browser.Session.GetCodingTaskPage();

            taskPage.GoTo();
            taskPage.WaitFormTaskGroupToFinishLoading(verbatim, numberOfTasks);
        }

        private static string CreateSynonymListUploadFile(string delimitedSynonym, string downloadDirectory)
        {
            if (String.IsNullOrEmpty(delimitedSynonym)) throw new ArgumentNullException("delimitedSynonym");
            if (String.IsNullOrEmpty(downloadDirectory)) throw new ArgumentNullException("downloadDirectory");

            var synonyms = delimitedSynonym.Split('~');

            var header              = Config.SynonymListTemplate;
            var fullFileName        = string.Format("{0}.txt", "SynonymUpload".AppendRandomString());
            var filePath            = Path.Combine(downloadDirectory, fullFileName);
            var uploadFileConents   = new StringBuilder();

            uploadFileConents.Append(header);
            uploadFileConents.AppendLine();

            foreach (var synonym in synonyms)
            {
                uploadFileConents.Append(synonym);
                uploadFileConents.AppendLine();
            }

            File.WriteAllText(filePath, uploadFileConents.ToString());

            return filePath;
        }
    }
}
