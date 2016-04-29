using System;
using System.Linq;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Coypu;
using FluentAssertions;

namespace Coder.DeclarativeBrowser.ExtensionMethods
{
    public static class StepContextExtensionMethods
    {
        public static void SetSegmentSetupDataContext(this StepContext stepContext, bool isProductionStudy)
        { 
            if (ReferenceEquals(stepContext, null)) throw new ArgumentNullException("stepContext");

            var segmentSetupData = CoderDatabaseAccess.GetSegmentSetupDataByUserName(stepContext.User, isProductionStudy);

            stepContext.Project                      = segmentSetupData.Project;
            stepContext.SourceSystemStudyName        = segmentSetupData.SourceSystemStudyName;
            stepContext.SourceSystemStudyDisplayName = segmentSetupData.SourceSystemStudyDisplayName;
            stepContext.StudyOid                     = segmentSetupData.StudyOid;
            stepContext.ProtocolNumber               = segmentSetupData.ProtocolNumber;
            stepContext.Segment                      = segmentSetupData.SegmentName;
        }

        public static void SetProjectRegistrationContext(this StepContext stepContext, string dictionaryLocaleVersion)
        {
            if (ReferenceEquals(stepContext, null))              throw new ArgumentNullException("stepContext");                
            if (String.IsNullOrEmpty(dictionaryLocaleVersion))   throw new ArgumentNullException("dictionaryLocaleVersion");   

            var registrationValues              = dictionaryLocaleVersion.Split(' ');

            stepContext.Dictionary              = registrationValues[0].Trim();
            stepContext.Locale                  = registrationValues[1].Trim();
            stepContext.Version                 = registrationValues[2].Trim();
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

            var applicationData                 = CoderDatabaseAccess.GetSourceSystemApplicationData(Config.ApplicationName);

            stepContext.SourceSystem            = applicationData.SourceSystem;
            stepContext.SourceSystemLocale      = applicationData.SourceSystemLocale;
            stepContext.ConnectionUri           = applicationData.ConnectionUri;
        }

        public static void SetCurrentCodingElementContext(this StepContext stepContext)
        {
            if (ReferenceEquals(stepContext, null))  throw new ArgumentNullException("stepContext");

            var codingElementData = CoderDatabaseAccess.GetCurrentCodingElementData(stepContext.Segment);

            stepContext.CreationDate            = codingElementData.CreationDate;
            stepContext.AutoCodeDate            = codingElementData.AutoCodeDate;
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
                project          : stepContext.Project,
                segment          : stepContext.Segment,
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
                project          : stepContext.Project,
                segment          : stepContext.Segment,
                dictionary       : synonymList.Dictionary,
                dictionaryVersion: synonymList.Version,
                locale:            synonymList.Locale,
                synonymListName:   synonymList.SynonymListName,
                registrationName:  synonymList.Dictionary
                );
            }
        }

        public static void SetStudyDataContextByProjectName(this StepContext stepContext)
        {
            if (ReferenceEquals(stepContext,null))      throw new ArgumentNullException("stepContext");

            var studyAttributes = CoderDatabaseAccess.GetStudyDataByProjectName(stepContext.Segment, stepContext.Project);

            stepContext.ProtocolNumber               = studyAttributes.ProtocolNumber;
            stepContext.StudyOid                     = studyAttributes.ObjectID;
            stepContext.SourceSystemStudyDisplayName = String.Concat(stepContext.Project, " - ", stepContext.ProtocolNumber);
        }

        public static void SetContextFromGeneratedUser(this StepContext stepContext, bool isProductionStudy)
        {
            if (ReferenceEquals(stepContext,null)) throw new ArgumentNullException("stepContext");

            StudySetupData primaryStudy;

            if (isProductionStudy)
            {
                primaryStudy        = stepContext.SegmentUnderTest.ProdStudy;
                stepContext.Project = primaryStudy.StudyName;
            }
            else
            {
                primaryStudy        = stepContext.SegmentUnderTest.DevStudy;
                stepContext.Project = primaryStudy.StudyName.Substring(0, primaryStudy.StudyName.IndexOf(' '));
            }

            stepContext.User                         = stepContext.CoderTestUser.Username;
            stepContext.Segment                      = stepContext.SegmentUnderTest.SegmentName;
            stepContext.SourceSystemStudyName        = primaryStudy.StudyName;
            stepContext.ProtocolNumber               = primaryStudy.ExternalOid;
            stepContext.SourceSystemStudyDisplayName = String.Concat(primaryStudy.StudyName, " - ", stepContext.ProtocolNumber);
            stepContext.StudyOid                     = primaryStudy.StudyUuid;
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
    }
}
