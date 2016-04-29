using System;
using System.Drawing.Imaging;
using System.IO;
using Coder.DeclarativeBrowser.Helpers;
using Coypu;

namespace Coder.DeclarativeBrowser.ExtensionMethods
{
    public static class ScreenshotExtensionMethods
    {
        public static void SaveScreenshot(this CoderDeclarativeBrowser browser, string fileName)
        {
            if (ReferenceEquals(browser, null))     throw new ArgumentNullException("browser");
            if (String.IsNullOrEmpty(fileName))     throw new ArgumentNullException("fileName");          

            var fullFileName                = String.Format("{0}.jpg", fileName.AppendRandomString());
            var screenshotDirectory         = BrowserUtility.GetScreenshotDirectory();
            var filePath                    = Path.Combine(screenshotDirectory, fullFileName);
            var screenshotRelativePath      = String.Format("./{0}/{1}", Config.ScreenshotDirectoryName, fullFileName);

            browser.Session.SaveScreenshot(filePath, ImageFormat.Jpeg);
            Console.WriteLine("<img src=\"{0}\"/>", new Uri(screenshotRelativePath, UriKind.Relative));
        }
    }
}
