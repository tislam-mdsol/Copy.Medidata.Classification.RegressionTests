using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class RaveArchitectCopyDraftWizardPage
    {
        private readonly BrowserSession _Session;

        private readonly string[] excludedContentTabs = {"Labs"};

        internal RaveArchitectCopyDraftWizardPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }

        private SessionElementScope GetNextButton()
        {
            var nextButton = _Session.FindSessionElementById("ButtonNext");

            return nextButton;
        }

        private SessionElementScope GetCancelButton()
        {
            var cancelButton = _Session.FindSessionElementById("ButtonCancel");

            return cancelButton;
        }

        private SessionElementScope GetDraftSearchTextbox()
        {
            var draftSearchTextbox = _Session.FindSessionElementById("_ctl0_Content_SearchFilterTxt");

            return draftSearchTextbox;
        }

        private SessionElementScope GetSearchButton()
        {
            var searchButton = _Session.FindSessionElementById("_ctl0_Content_StartSearchBtn");

            return searchButton;
        }

        private SessionElementScope GetProjectsTree()
        {
            var projectsTree = _Session.FindSessionElementById("StartTreeDiv");

            return projectsTree;
        }

        private IEnumerable<SessionElementScope> GetProjectsTreeDraftBranch()
        {
            var projectsTree = GetProjectsTree();

            var projectsTreeDraftBranches = projectsTree.FindAllSessionElementsByXPath("//div[contains(@id, '_Drafts')]");

            return projectsTreeDraftBranches;
        }

        private IEnumerable<SessionElementScope> GetIncludedContentTabs()
        {
            var contentTabs = _Session.FindAllSessionElementsByXPath("//td[contains(@id, '_ctl0_Content_Tabs_tab')]");

            var includedTabs = contentTabs.Select(x => x).Where(x => !excludedContentTabs.Contains(x.Text));

            return includedTabs;
        }

        private SessionElementScope GetContentsTree()
        {
            var contentsTree = _Session.FindSessionElementById("_ctl0_Content_Tabs_Content");

            return contentsTree;
        }

        private SessionElementScope GetContentsTreeCheckBox(string contentLabel)
        {
            if (String.IsNullOrWhiteSpace(contentLabel)) throw new ArgumentNullException("contentLabel");

            var cleanContentLabel = contentLabel.RemoveNonAlphanumeric();

            var contentsTree = GetContentsTree();

            var inputs = contentsTree.FindAllSessionElementsByXPath(".//input");

            var contentsTreeCheckBox =
                inputs.FirstOrDefault(x =>x.Type.Equals("checkbox", StringComparison.OrdinalIgnoreCase) && x.Id.Contains(cleanContentLabel));

            if (ReferenceEquals(contentsTreeCheckBox, null))
            {
                throw new MissingHtmlException(String.Format("Could not find a checkbox for label {0}", contentLabel));
            }

            return contentsTreeCheckBox;
        }
        
        private void Continue()
        {
            _Session.WaitUntilElementIsActive(GetNextButton);

            GetNextButton().Click();

            WaitForActionToComplete();
        }

        private void WaitForActionToComplete()
        {
            // The final action will complete the copy and close the wizard, opening a new page. No wait is required.
            if (GetCancelButton().Exists())
            {
                _Session.WaitUntilElementIsActive(GetCancelButton);
            }
        }
        
        private void SelectSourceDraft(string sourceDraftName)
        {
            if (String.IsNullOrWhiteSpace(sourceDraftName)) throw new ArgumentNullException("sourceDraftName");
            
            GetDraftSearchTextbox().FillInWith(sourceDraftName);
            GetSearchButton().Click();

            RetryPolicy.FindElementShort.Execute(() =>
            {
                var draftBranch = GetProjectsTreeDraftBranch().SingleOrDefault(x => x.Text.Contains(sourceDraftName, StringComparison.OrdinalIgnoreCase));

                if (ReferenceEquals(draftBranch, null))
                {
                    throw new MissingHtmlException(String.Format("Could not find a draft named {0}", sourceDraftName));
                }

                var sourceDraftCheckBox = draftBranch.FindSessionElementByXPath(".//input");

                if (ReferenceEquals(sourceDraftCheckBox, null))
                {
                    throw new MissingHtmlException(String.Format("Could not find a checkbox for a draft named {0}", sourceDraftName));
                }

                sourceDraftCheckBox.SetCheckBoxState(true);
            });

            Continue();
        }

        private void SelectContentToCopy()
        {
            var contentTabs = GetIncludedContentTabs();

            foreach (var contentTab in contentTabs)
            {
                contentTab.Click();

                RetryPolicy.FindElement.Execute(() =>
                {
                    if (contentTab.Class.Equals("Tab_Inactive", StringComparison.OrdinalIgnoreCase))
                    {
                        throw new MissingHtmlException(String.Format("Tab {0} has not finished loading.", contentTab.Text));
                    }

                    var contentsTreeCheckBox = GetContentsTreeCheckBox(contentTab.Text);

                    contentsTreeCheckBox.SetCheckBoxState(true);

                    WaitForActionToComplete();
                });
            }

            Continue();
        }

        private void CompleteCopy()
        {
            Continue();
        }

        internal void CopyDraft(string sourceDraftName)
        {
            if (String.IsNullOrWhiteSpace(sourceDraftName)) throw new ArgumentNullException("sourceDraftName");

            SelectSourceDraft(sourceDraftName);

            SelectContentToCopy();

            CompleteCopy();
        }
    }
}
