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

        internal static List<string> GetRaveXLSWorkSheetRowDataComparison(string filePath, string workSheetName)
        {
            if (String.IsNullOrWhiteSpace(filePath)) throw new ArgumentNullException(nameof(filePath));
            if (String.IsNullOrWhiteSpace(workSheetName)) throw new ArgumentNullException(nameof(workSheetName));

            XDocument workSheets = XDocument.Load(filePath + ".xls");

            List<string> listOfActualValues = null;

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
                            var actualValue = cell.Value;

                            listOfActualValues.Add(actualValue);

                            i++;
                        }
                    }
                }
            }

            return listOfActualValues;
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
