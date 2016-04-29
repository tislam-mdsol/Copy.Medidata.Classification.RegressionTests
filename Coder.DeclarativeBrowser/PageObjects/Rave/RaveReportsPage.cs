//@auuthor:smalik
using Coder.DeclarativeBrowser.ExtensionMethods;
using System;
using Coypu;
using System.Collections.Generic;
using System.Linq;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
   internal sealed  class RaveReportsPage
    {
         private readonly BrowserSession _Browser;
         private const string _NameHeaderText = "Name";

         internal RaveReportsPage(BrowserSession browser)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");

            _Browser = browser;
        }

         private SessionElementScope GetReportGrid()
         {
             var reportGrid = _Browser.FindSessionElementById("MyReportGrid");

             return reportGrid;
         }

         private SessionElementScope GetReportTypeLinkByRowContents(string rowContents)
         {
             var reportLinkCell = GetReportGrid().FindTableCell(rowContents,_NameHeaderText);

             var reportLink     = reportLinkCell .FindSessionElementByXPath(".//a");
            
             return reportLink;
         }

         internal void ChooseReport(string reportType)
         {
             GetReportTypeLinkByRowContents(reportType).Click();
         }

    }
}
