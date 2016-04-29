using Coypu;
using System;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;

namespace Coder.DeclarativeBrowser.PageObjects.Rave
{
    internal sealed class RaveArchitectCopySourcesPage
    {
        private readonly BrowserSession _Session;

        private const string _AddNewCopySourceIdSuffix     = "_LnkBtnInsert";
        private const string _CopySourceTypeSelectIdSuffix = "_DdlProjectTypes";
        private const string _StudyNameSelectIdSuffix      = "_DdlProjects";
        private const string _DraftNameSelectIdSuffix      = "_DdlCrfVersions";

        private const string _UpdateButtonText             = "Update";

        internal RaveArchitectCopySourcesPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }

        private SessionElementScope GetAddNewCopySourceLink()
        {
            var links = _Session.FindAllSessionElementsByXPath("//a");

            var addNewCopySourceLink = links.FirstOrDefault(x => x.Id.Contains(_AddNewCopySourceIdSuffix, StringComparison.OrdinalIgnoreCase));

            return addNewCopySourceLink;
        }

        private SessionElementScope GetCopySourceTypeSelectList()
        {
            var selectLists = _Session.FindAllSessionElementsByXPath("//select");

            var copySourceTypeSelectList = selectLists.FirstOrDefault(x => x.Id.Contains(_CopySourceTypeSelectIdSuffix, StringComparison.OrdinalIgnoreCase));

            return copySourceTypeSelectList;
        }

        private SessionElementScope GetStudyNameSelectList()
        {
            var selectLists = _Session.FindAllSessionElementsByXPath("//select");

            var studyNameSelectList = selectLists.FirstOrDefault(x => x.Id.Contains(_StudyNameSelectIdSuffix, StringComparison.OrdinalIgnoreCase));

            return studyNameSelectList;
        }

        private SessionElementScope GetDraftNameSelectList()
        {
            var selectLists = _Session.FindAllSessionElementsByXPath("//select");

            var draftNameSelectList = selectLists.FirstOrDefault(x => x.Id.Contains(_DraftNameSelectIdSuffix, StringComparison.OrdinalIgnoreCase));

            return draftNameSelectList;
        }

        private SessionElementScope GetUpdateLink()
        {
            var links = _Session.FindAllSessionElementsByXPath("//a");

            var updateLink = links.FirstOrDefault(x => x.Text.Contains(_UpdateButtonText, StringComparison.OrdinalIgnoreCase));

            return updateLink;
        }

        public void AddCopySource(string copySourceType, string studyName, string draftName)
        {
            if (String.IsNullOrWhiteSpace(copySourceType)) throw new ArgumentNullException("copySourceType");
            if (String.IsNullOrWhiteSpace(studyName))      throw new ArgumentNullException("studyName");
            if (String.IsNullOrWhiteSpace(draftName))      throw new ArgumentNullException("draftName");

            GetAddNewCopySourceLink().Click();

            _Session.WaitUntilElementExists(GetCopySourceTypeSelectList);

            GetCopySourceTypeSelectList().SelectOptionAlphanumericOnly(copySourceType);
            GetStudyNameSelectList     ().SelectOptionAlphanumericOnly(studyName     );
            GetDraftNameSelectList     ().SelectOptionAlphanumericOnly(draftName     );

            GetUpdateLink().Click();
        }
    }
}
