using System;
using System.Collections.Generic;
using System.Reflection;
using Coder.DeclarativeBrowser.Models.GridModels;
using FluentAssertions;

namespace Coder.DeclarativeBrowser.ExtensionMethods.Assertions
{
    public static class ProjectRegistrationAssertionExtensionMethods
    {
        public static void AssertThatAllStudiesForProjectAreRegisteredAndMevContentIsLoaded(
            this CoderDeclarativeBrowser browser,
            string project, 
            IList<SourceTerm> list)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");
            if (String.IsNullOrEmpty(project))  throw new ArgumentNullException("project");
            if (ReferenceEquals(list,null))     throw new ArgumentNullException("list");

            var session        = browser.Session;
            var codingTaskPage = session.GetCodingTaskPage();

            foreach (var codingTask in list)
            {
                var term = codingTask.Term;
                codingTaskPage.SelectTaskGridByVerbatimName(term);

                codingTaskPage.SelectSourceTermTab();

                var sourceTermTab = session.GetTaskPageSourceTermTab();
                var study         = codingTask.Study.Replace("<Project>", project);
                var htmlStudy     = sourceTermTab.GetSourceTermStudyNameByTerm(term);

                htmlStudy.ShouldBeEquivalentTo(study);
            }

            browser.SaveScreenshot(MethodBase.GetCurrentMethod().Name);
        }
    }
}
