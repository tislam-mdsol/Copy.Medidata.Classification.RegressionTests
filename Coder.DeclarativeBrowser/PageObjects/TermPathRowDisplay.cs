using System;
using System.IO;
using System.Linq;
using Coder.DeclarativeBrowser.Models;

namespace Coder.DeclarativeBrowser.PageObjects
{
    internal static class TermPathRowDisplay
    {
        private const string TermPathXPath = ".//ul[contains(@class,'on')]/li";

        internal static TermPathRow GetSelectedCodingHistoryTermPathRow(SessionElementScope termPathCell)
        {
            if (ReferenceEquals(termPathCell, null))          throw new ArgumentNullException("termPathCell");
            if (String.IsNullOrWhiteSpace(termPathCell.Text)) 
                return null;

            var selectedTermPathRow = termPathCell
                .FindSessionElementByXPath(TermPathXPath);

            var selectedTermPath    = BuildTermPathRow(selectedTermPathRow);

            return selectedTermPath;
        }

        internal static TermPathRow[] GetExpandedCodingHistoryTermPathRows(SessionElementScope termPathCell)
        {
            if (ReferenceEquals(termPathCell, null)) throw new ArgumentNullException("termPathCell"); 
            if (String.IsNullOrWhiteSpace(termPathCell.Text)) return null;

            var divToExpand      = termPathCell.FindSessionElementByXPath("div");
            divToExpand.Click();

            var fullTermPaths = RetryPolicy.SyncStaleElement.Execute(
                () =>
                {
                    var fullTermPathRows = divToExpand
                        .FindAllSessionElementsByXPath(TermPathXPath)
                        .ToList();

                    return (from fullTermPath in fullTermPathRows
                        select BuildTermPathRow(fullTermPath))
                        .ToArray();
                });

            return fullTermPaths;
        }

        private static TermPathRow BuildTermPathRow(SessionElementScope termPathCell)
        {
            if (ReferenceEquals(termPathCell, null)) throw new ArgumentNullException("termPathCell");

            var termPathRow = new TermPathRow
            {
                TermPath    = termPathCell.Text.Trim(),
                Code        = ExtractTermCode(termPathCell.Text).Trim(),
                Level       = GetTermLevelFromStyleAttribute(termPathCell.GetAttribute("style")).Trim()
            };

            return termPathRow;
        }

        private static string ExtractTermCode(string termPath)
        {
            if (String.IsNullOrWhiteSpace(termPath)) throw new ArgumentNullException("termPath");

            return termPath.Substring(termPath.IndexOf(':') + 1);
        }

        private static string GetTermLevelFromStyleAttribute(string termPathRowImageStyle)
        {
            if (ReferenceEquals(termPathRowImageStyle, null)) { throw new ArgumentNullException("termPathRowImageStyle"); }

            string[] fileNameUrl     = termPathRowImageStyle.Split('(', ')');

            if (fileNameUrl.Count() > 1)
            {
                var fileUrl          = new Uri(fileNameUrl[1].Replace("\"", String.Empty));
                var fileName         = Path.GetFileName(fileUrl.GetLeftPart((UriPartial.Path)));
                var termImageToLevel = Config.TermLevelFromStyleAttribute;

                return termImageToLevel[fileName];
            }
            else
            {
                return String.Empty;
            }
        }
    }
}
