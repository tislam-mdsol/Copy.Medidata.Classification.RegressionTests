using Coypu;
using System;
using System.Collections.Generic;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Helpers;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal sealed class RaveArchitectEnvironmentSetupPage
    {
        private readonly BrowserSession _Session;

        internal RaveArchitectEnvironmentSetupPage(BrowserSession session)
        {
            if (ReferenceEquals(session, null))
            {
                throw new ArgumentNullException("session");
            }
            _Session = session;
        }
        
        private SessionElementScope GetAddNewEnvironmentLink()
        {
            var addNewLink = _Session.FindSessionElementByLink("Add New");

            return addNewLink;
        }

        private SessionElementScope GetNewEnvironmentNameTextBox()
        {
            var newEnvironmentNameTextBox = _Session.FindSessionElementIdEndingWith("_txtName");
 
            return newEnvironmentNameTextBox;
        }

        private SessionElementScope GetNewEnvironmentUpdateButton()
        {
            var newEnvironmentUpdateButton = _Session.FindSessionElementIdEndingWith("_imgUpdate");

            return newEnvironmentUpdateButton;
        }

        internal void SetNewEnvironmentProperties(string newEnvironmentName)
        {
            if (String.IsNullOrEmpty(newEnvironmentName)) throw new ArgumentNullException("environment");

            GetAddNewEnvironmentLink().Click();
            GetNewEnvironmentNameTextBox().FillInWith(newEnvironmentName);
            GetNewEnvironmentUpdateButton().Click();
        }


    }
}
