using System;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.PageObjects;

namespace Coder.DeclarativeBrowser.ExtensionMethods
{
    internal static class DictionarySearchExtensionMethods
    {
        internal static void CodeTaskWithTerm(
            this CoderDeclarativeBrowser browser, 
            DictionarySearchPanel searchPanel,
            TermPathRow termPathRow, 
            bool createSynonym)
        {
            if (ReferenceEquals(browser, null))     throw new ArgumentNullException("browser");
            if (ReferenceEquals(termPathRow, null)) throw new ArgumentNullException("termPathRow");
            if (ReferenceEquals(searchPanel, null)) throw new ArgumentNullException("searchPanel");

            searchPanel.SelectDictionarySearchResult(termPathRow);

            var selectedSearchResultInformation = browser.Session.GetDictionarySearchSelection();
            selectedSearchResultInformation.CodeSelectedTerm(createSynonym);
        }

        internal static void CodeTaskWithTermAndNext(
            this CoderDeclarativeBrowser browser,
            DictionarySearchPanel searchPanel,
            TermPathRow termPathRow,  
            bool createSynonym)
        {
            if (ReferenceEquals(browser, null)) throw new ArgumentNullException("browser");
            if (ReferenceEquals(termPathRow, null)) throw new ArgumentNullException("termPathRow");
            if (ReferenceEquals(searchPanel, null)) throw new ArgumentNullException("searchPanel");

            searchPanel.SelectDictionarySearchResult(termPathRow);

            var selectedSearchResultInformation = browser.Session.GetDictionarySearchSelection();
            selectedSearchResultInformation.CodeSelectedTermAndNext(createSynonym);
        }




    }
}
