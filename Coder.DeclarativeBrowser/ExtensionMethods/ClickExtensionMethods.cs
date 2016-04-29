using System;
using Coypu;

namespace Coder.DeclarativeBrowser.ExtensionMethods
{
    internal static class ClickExtensionMethods
    {
        private static readonly Options _DefaultTryUntilSuccessOptions = new Options
        {
            WaitBeforeClick     = TimeSpan.FromSeconds(1), 
            RetryInterval       = TimeSpan.FromSeconds(1), 
            Timeout             = TimeSpan.FromSeconds(60)
        };

        internal static void ClickWhenAvailable(
            this ElementScope sourceElement,
            DriverScope driverScope)
        {
            if (ReferenceEquals(sourceElement, null))        throw new ArgumentNullException("sourceElement"); 
            if (ReferenceEquals(driverScope, null))          throw new ArgumentNullException("driverScope");       

            sourceElement.ClickWhenAvailable(driverScope, _DefaultTryUntilSuccessOptions);
        }

        internal static void ClickWhenAvailable(
            this ElementScope sourceElement,
            DriverScope driverScope,
            Options options)
        {
            if (ReferenceEquals(sourceElement, null))        throw new ArgumentNullException("sourceElement"); 
            if (ReferenceEquals(driverScope, null))          throw new ArgumentNullException("driverScope");       
            if (ReferenceEquals(options, null))              throw new ArgumentNullException("options");       
            
            driverScope.TryUntil(
                () => sourceElement.Click(),
                () => sourceElement.Exists(),
                options.WaitBeforeClick,
                options);
        }

        internal static void ClickHelpLinkUntilIsHelpPageIsAvailable(
            this BrowserSession browserSession,
            SessionElementScope helpLink)
        {
            if (ReferenceEquals(browserSession, null))      throw new ArgumentNullException("browserSession");
            if (ReferenceEquals(helpLink, null))            throw new ArgumentNullException("helpLink");          

            var options         = new Options
            {
                RetryInterval   = TimeSpan.FromSeconds(1), 
                Timeout         = TimeSpan.FromSeconds(60)
            };

            browserSession.TryUntil(
                () => helpLink.Click(),
                () => browserSession.FindWindow(Config.ELearningLoginTitle).Exists(),
                options.WaitBeforeClick,
                options);
        }

        internal static void SetCheckBoxState(
            this ElementScope checkbox, 
            DriverScope driverScope,
            string value)
        {
            if (ReferenceEquals(checkbox, null))         throw new ArgumentNullException("checkbox");  
            if (ReferenceEquals(driverScope, null))      throw new ArgumentNullException("driverScope");  
            if (String.IsNullOrEmpty(value))             throw new ArgumentNullException("value");     

            if (value.ToUpper().Equals("CHECKED") ||
                value.ToUpper().Equals("TRUE") ||
                value.ToUpper().Equals("YES"))
            {
                if (!checkbox.Selected)
                {
                    checkbox.ClickWhenAvailable(driverScope);
                }
            }
            else
            {
                if (checkbox.Selected)
                {
                    checkbox.ClickWhenAvailable(driverScope);
                }
            }
        }
    }
}
