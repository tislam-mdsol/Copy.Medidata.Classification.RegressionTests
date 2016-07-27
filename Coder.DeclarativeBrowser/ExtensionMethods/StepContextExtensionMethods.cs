using System;
using System.Linq;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Coypu;
using System.Collections.Generic;

namespace Coder.DeclarativeBrowser.ExtensionMethods
{
    public static class StepContextExtensionMethods
    {
        public static void SetProjectRegistrationContext(this StepContext stepContext, string dictionaryLocaleVersion)
        {
            if (ReferenceEquals(stepContext, null))              throw new ArgumentNullException("stepContext");                
            if (String.IsNullOrEmpty(dictionaryLocaleVersion))   throw new ArgumentNullException("dictionaryLocaleVersion");   

            var registrationValues              = dictionaryLocaleVersion.Split(' ');

            stepContext.Dictionary              = registrationValues[0].Trim();
            stepContext.Locale                  = registrationValues[1].Trim();
            stepContext.Version                 = registrationValues[2].Trim();
        }

        public static void SetSynonymContext(this StepContext stepContext, string synonymListName)
        {
            if (ReferenceEquals(stepContext, null))    throw new ArgumentNullException("stepContext");
            if (String.IsNullOrEmpty(synonymListName)) throw new ArgumentNullException("synonymListName");

            var synonymList = new SynonymList
            {
                Dictionary       = stepContext.Dictionary,
                Locale           = stepContext.Locale,
                Version          = stepContext.Version,
                SynonymListName  = synonymListName,
                RegistrationName = stepContext.Dictionary
            };

            stepContext.SourceSynonymList = synonymList;
        }

        public static void SetDictionaryAndSynonymContext(this StepContext stepContext, string task)
        {
            if (ReferenceEquals(stepContext, null))                 throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null))         throw new ArgumentNullException("stepContext.Browser");
            if (ReferenceEquals(stepContext.Browser.Session, null)) throw new ArgumentNullException("stepContext.Browser.Session");
            if (String.IsNullOrWhiteSpace(task))                    throw new ArgumentNullException("task");
            
            var session        = stepContext.Browser.Session;
            var codingTaskPage = session.GetCodingTaskPage();

            codingTaskPage.SelectTaskGridByVerbatimName(task);
            var codingTask = codingTaskPage.GetSelectedCodingTask();
            var sourceTerm = session.GetTaskPageSourceTermTab().GetSourceTermTableValues();
            
            if (ReferenceEquals(sourceTerm, null))
            {
                throw new InvalidOperationException(String.Format("No source information was found for task {0}", task));
            }

            string taskDictionary = codingTask.Dictionary;

            var taskDictionaryComponents = taskDictionary.Split(new[] { " - " }, StringSplitOptions.RemoveEmptyEntries);

            if (taskDictionaryComponents.Count() != 3)
            {
                throw new MissingHtmlException(
                    String.Format("Could not parse the dictionary, version, and synonym list name from {0}",
                        taskDictionary));
            }

            stepContext.Dictionary = taskDictionaryComponents[0];
            stepContext.Version    = taskDictionaryComponents[1];

            stepContext.Locale     = sourceTerm.Locale;

            var synonymList = new SynonymList
            {
                Dictionary      = stepContext.Dictionary,
                Locale          = stepContext.Locale,
                Version         = stepContext.Version,
                SynonymListName = taskDictionaryComponents[2]
            };

            stepContext.SourceSynonymList = synonymList;
        }

        public static void SetSourceSystemApplicationContext(this StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null)) throw new ArgumentNullException("stepContext");                 

            var applicationData = CoderDatabaseAccess.GetSourceSystemApplicationData(Config.ApplicationName);

            stepContext.SourceSystem       = applicationData.SourceSystem;
            stepContext.ConnectionUri      = applicationData.ConnectionUri;
        }

        public static void SetCurrentCodingElementContext(this StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))  throw new ArgumentNullException("stepContext");

            var codingElementData = CoderDatabaseAccess.GetCurrentCodingElementData(stepContext.GetSegment());

            stepContext.CreationDate = codingElementData.CreationDate;
            stepContext.AutoCodeDate = codingElementData.AutoCodeDate;
        }

        public static void SetOdmTermApprovalContext(this StepContext stepContext, string isAutoApproval, string isApprovalRequired)
        {
            if (ReferenceEquals(stepContext, null))          throw new ArgumentNullException("stepContext");             
            if (String.IsNullOrEmpty(isAutoApproval))        throw new ArgumentNullException("isAutoApproval");          
            if (String.IsNullOrEmpty(isApprovalRequired))    throw new ArgumentNullException("isApprovalRequired");    

            stepContext.IsApprovalRequired      = isApprovalRequired;
            stepContext.IsAutoApproval          = isAutoApproval;
        }

        public static void CleanUpAndRegisterProject(this StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null)) throw new ArgumentNullException("stepContext");

            stepContext.Browser.CleanUpCodingTasks();

            CoderDatabaseAccess.RegisterProject(
                protocolNumber   : stepContext.GetProtocolNumber(),
                segment          : stepContext.GetSegment(),
                dictionary       : stepContext.Dictionary,
                dictionaryVersion: stepContext.Version,
                locale           : stepContext.Locale,
                synonymListName  : Config.DefaultSynonymListName,
                registrationName : stepContext.Dictionary // TODO : enhance this to test registration name);
                );

            stepContext.SourceSynonymList = new SynonymList
            {
                Dictionary      = stepContext.Dictionary,
                Locale          = stepContext.Locale,
                Version         = stepContext.Version,
                SynonymListName = Config.DefaultSynonymListName
            };
        }

        public static void CleanUpAndRegisterProject(this StepContext stepContext, SynonymList[] synonymLists)
        {
            if (ReferenceEquals(stepContext,null))   throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(synonymLists, null)) throw new ArgumentNullException("synonymLists");

            stepContext.Browser.CleanUpCodingTasks();

            foreach (var synonymList in synonymLists)
            {
                CoderDatabaseAccess.RegisterProject(
                protocolNumber   : stepContext.GetProtocolNumber(),
                segment          : stepContext.GetSegment(),
                dictionary       : synonymList.Dictionary,
                dictionaryVersion: synonymList.Version,
                locale:            synonymList.Locale,
                synonymListName:   synonymList.SynonymListName,
                registrationName:  synonymList.Dictionary
                );
            }
        }

        public static void SetWorkflowVariablesContext(this StepContext stepContext, string task)
        {
            if (ReferenceEquals(stepContext        , null))         throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(stepContext.Browser, null))         throw new ArgumentNullException("stepContext.Browser");
            if (ReferenceEquals(stepContext.Browser.Session, null)) throw new ArgumentNullException("stepContext.Browser.Session");
            if (String.IsNullOrWhiteSpace(task))                    throw new ArgumentNullException("task");

            var session        = stepContext.Browser.Session;

            session.GetCodingTaskPage().SelectTaskGridByVerbatimName(task);
            var codingHistory  = session.GetTaskPageCodingHistoryTab().GetCodingHistoryDetailValues();

            var latestWorkflowVariablesCodingHistoryDetail = codingHistory.FirstOrDefault(x => x.Comment.Contains("WorkflowVariables"));

            var workflowVariablesComment = latestWorkflowVariablesCodingHistoryDetail.Comment;

            if (workflowVariablesComment.Equals(String.Empty))
            {
                throw new InvalidOperationException(String.Format("No Workflow Variables found for task {0}", task));
            }

            string isAutoApprovalValue     = GetWorkflowVariableValue("IsAutoApproval"    , workflowVariablesComment);
            string isApprovalRequiredValue = GetWorkflowVariableValue("IsApprovalRequired", workflowVariablesComment);
            
            stepContext.SetOdmTermApprovalContext(isAutoApprovalValue, isApprovalRequiredValue);
        }

        public static string GetWorkflowVariableValue(string workflowVariable, string workflowVariablesComment)
        {
            if (String.IsNullOrWhiteSpace(workflowVariable))         throw new ArgumentNullException("workflowVariable");
            if (String.IsNullOrWhiteSpace(workflowVariablesComment)) throw new ArgumentNullException("workflowVariablesComment");
            
            int workflowVariableIndex = workflowVariablesComment.IndexOf(workflowVariable + "=");
            
            int valueStart = workflowVariablesComment.IndexOf("=", workflowVariableIndex) + 1;
            int valueEnd   = workflowVariablesComment.IndexOf(",", valueStart);

            if (valueStart < 0 || valueEnd < 0)
            {
                throw new InvalidOperationException(String.Format("Workflow Variable '{0}' not found in '{1}'", workflowVariable, workflowVariablesComment));
            }

            string workflowVariableValue = workflowVariablesComment.Substring(valueStart, valueEnd - valueStart);

            if (!workflowVariableValue.EqualsIgnoreCase("true") && !workflowVariableValue.EqualsIgnoreCase("false"))
            {
                throw new InvalidOperationException(String.Format("Workflow Variable '{0}' was read improperly as '{1}' from '{2}'",
                    workflowVariable,
                    workflowVariableValue,
                    workflowVariablesComment));
            }

            return workflowVariableValue;
        }

        public static void SetStudyGroupSetupData(this StepContext stepContext, SegmentSetupData segmentSetupData)
        {
            if (ReferenceEquals(stepContext, null))                      throw new ArgumentNullException("stepContext");
            if (ReferenceEquals(segmentSetupData, null))                 throw new ArgumentNullException("segmentSetupData");
            if (String.IsNullOrWhiteSpace(segmentSetupData.SegmentName)) throw new ArgumentNullException("segmentSetupData.SegmentName");

            segmentSetupData.Customer = Config.TestSegmentCustomer;
            segmentSetupData.UseRaveX = stepContext.UseRaveX;

            segmentSetupData.StudyGroupApps = Config.GetStudyGroupApps();           
        }
    }
}
