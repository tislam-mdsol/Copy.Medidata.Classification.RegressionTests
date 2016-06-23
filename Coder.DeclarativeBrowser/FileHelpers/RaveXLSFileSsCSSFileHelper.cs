using System;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Linq;
using System.Collections.Generic;
using Coder.DeclarativeBrowser.ExtensionMethods;

namespace Coder.DeclarativeBrowser.FileHelpers
{
    class RaveXLSFileSsCSSFileHelper
    {
        private static XNamespace _Css_Ss_Class = "urn:schemas-microsoft-com:office:spreadsheet";
        private static XNamespace _Css_O_Class = "urn:schemas-microsoft-com:office:office";
        private static XNamespace _Css_X_Class = "urn:schemas-microsoft-com:office:excel";

        internal static bool IsRaveXLSWorkSheetRowDataComparison(string filePath, string workSheetName, List<string> expectedSheetDataValues)
        {
            if (String.IsNullOrWhiteSpace(filePath)) throw new ArgumentNullException(nameof(filePath));
            if (String.IsNullOrWhiteSpace(workSheetName)) throw new ArgumentNullException(nameof(workSheetName));
            if (!expectedSheetDataValues.Any()) throw new ArgumentNullException("No expected values from table");

            XDocument workSheets = XDocument.Load(filePath + ".xls");

            var i = 0;

            foreach (XElement worksheet in workSheets.Descendants(_Css_Ss_Class + "Worksheet"))
            {
                if (worksheet.Attribute(_Css_Ss_Class + "Name").Value.Equals(workSheetName, StringComparison.OrdinalIgnoreCase))
                {
                    var skipFirstRow = worksheet.Descendants(_Css_Ss_Class + "Row").Skip(1);

                    foreach (XElement row in skipFirstRow)
                    {
                        foreach (XElement cell in row.Descendants(_Css_Ss_Class + "Data"))
                        {
                            var expectedValue = expectedSheetDataValues[i];
                            var actualValue = cell.Value;

                            if (!expectedValue.Equals(actualValue, StringComparison.OrdinalIgnoreCase))
                            {
                                return false;
                            }

                            i++;
                        }
                    }
                }
            }

            return true;
        }

        internal static string GetValueinSpreadSheetByRowAndColumnIndex(string filePath, string workSheetName, int rowIndex, int columnIndex)
        {
            if (String.IsNullOrWhiteSpace(filePath)) throw new ArgumentNullException(nameof(filePath));
            if (String.IsNullOrWhiteSpace(workSheetName)) throw new ArgumentNullException(nameof(workSheetName));

            XDocument workSheets = XDocument.Load(filePath + ".xls");

            var valueContent = "";

            foreach (XElement worksheet in workSheets.Descendants(_Css_Ss_Class + "Worksheet"))
            {
                if (worksheet.Attribute(_Css_Ss_Class + "Name").Value.Equals(workSheetName, StringComparison.OrdinalIgnoreCase))
                {
                    var workSheetRows = worksheet.Descendants(_Css_Ss_Class + "Row").ToArray();

                    var workSheetColumns = workSheetRows[rowIndex].Descendants(_Css_Ss_Class + "Data").ToArray();

                    valueContent = workSheetColumns[columnIndex].Value;
                }
            }

            return valueContent;
        }
    }
}
