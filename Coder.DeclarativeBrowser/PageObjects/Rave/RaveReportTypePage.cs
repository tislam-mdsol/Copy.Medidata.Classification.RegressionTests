//@auuthor:smalik
using Coder.DeclarativeBrowser.ExtensionMethods;
using System;
using Coypu;
using System.Collections.Generic;
using System.Linq;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class RaveReportTypePage
    {
        private readonly BrowserSession _Browser;
   
         internal RaveReportTypePage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            _Browser = browser;
        }

         private SessionElementScope GetStudyArrowButton()
         {
             var studyArrowButton = _Browser.FindSessionElementById("PromptsBox_st_ShowHideBtn");

             return studyArrowButton;
         }

         private SessionElementScope GetStudySearchBox()
         {
             var studySearchBox = _Browser.FindSessionElementById("PromptsBox_st_SearchTxt");

             return studySearchBox;
         }

         private SessionElementScope GetStudySearchButton()
         {
             var studySearchButton = _Browser.FindSessionElementById("PromptsBox_st_SearchBtn");

             return studySearchButton;
         }

         private SessionElementScope GetSelectCheckBoxOfSearchedStudy(string project)
         {
             GetStudySearchBox()   .FillInWith(project);
             GetStudySearchButton().Click();

             if (GetStudyRowsWithCheckBoxes().Count != 1)
             {
                 throw new MissingHtmlException("Greater than or less than 1 Study found For search");
             }
             var checkBox = _Browser.FindSessionElementById("PromptsBox_st_FrontEndCBList_0");

             return checkBox;
         }

         private SessionElementScope GetStudyRowGrid()
         {
             var studyRowGrid = _Browser.FindSessionElementById("PromptsBox_st_FrontEndCBList");

             return studyRowGrid;
         }

         private IList<SessionElementScope> GetStudyRowsWithCheckBoxes()
         {
             var rowsWithCheckBoxes = GetStudyRowGrid().FindAllSessionElementsByXPath(".//tr//input");

             return rowsWithCheckBoxes;
         }

         private SessionElementScope GetSubmitReportButton()
         {
             var submitReportButton = _Browser.FindSessionElementById("RunTheReport");

             return submitReportButton;
         }

         internal void GenerateReportForProject(string project)
         {
             if (String.IsNullOrWhiteSpace(project)) throw new ArgumentNullException("project");

             GetStudyArrowButton()                    .Click();
             GetSelectCheckBoxOfSearchedStudy(project).Check();
             GetSubmitReportButton()                  .Click();
         }

    }
}
