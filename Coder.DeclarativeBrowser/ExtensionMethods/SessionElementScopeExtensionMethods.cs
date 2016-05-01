using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.Models.GridModels;
using Coder.DeclarativeBrowser.PageObjects;
using Coypu;
using NUnit.Framework.Constraints;

namespace Coder.DeclarativeBrowser.ExtensionMethods
{
    internal static class SessionElementScopeExtensions
    {
        private static readonly Options _Options = Config.GetDefaultCoypuOptions();

        internal static SessionElementScope WithSession(this ElementScope elementScope, DriverScope session)
        {
            if (ReferenceEquals(elementScope, null))            throw new ArgumentNullException("elementScope"); 
            if (ReferenceEquals(session, null))                 throw new ArgumentNullException("session"); 

            var result = new SessionElementScope(elementScope, session);
            return result;
        }

        internal static IList<SessionElementScope> WithSession(this IEnumerable<SnapshotElementScope> snapshotElementScopes, DriverScope session)
        {
            if (ReferenceEquals(snapshotElementScopes, null))   throw new ArgumentNullException("snapshotElementScopes"); 
            if (ReferenceEquals(session, null))                 throw new ArgumentNullException("session"); 

            var result = snapshotElementScopes
                .Select(snapshotElementScope => new SessionElementScope(snapshotElementScope, session))
                .ToList();

            return result;
        }

        internal static SessionElementScope FindSessionElementById(this DriverScope session, string id)
        {
            if (ReferenceEquals(session, null))                 throw new ArgumentNullException("session"); 
            if (String.IsNullOrEmpty(id))                       throw new ArgumentNullException("id");

            var elementScope = session
                .FindId(id, _Options)
                .WithSession(session);

            return elementScope;
        }

        internal static SessionElementScope FindSessionElementByXPath(this DriverScope session, string xPath)
        {
            if (ReferenceEquals(session, null))                 throw new ArgumentNullException("session"); 
            if (String.IsNullOrEmpty(xPath))                    throw new ArgumentNullException("xPath");

            var elementScope = session
                .FindXPath(xPath, _Options)
                .WithSession(session);

            return elementScope;
        }

        internal static SessionElementScope FindSessionElementByLink(this DriverScope session, string linkText)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");
            if (String.IsNullOrEmpty(linkText)) throw new ArgumentNullException("linkText");

            var elementScope = session
                .FindLink(linkText, _Options)
                .WithSession(session);

            return elementScope;
        }

        internal static SessionElementScope FindSessionElementIdEndingWith(this DriverScope session, string linkText)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session");
            if (String.IsNullOrEmpty(linkText)) throw new ArgumentNullException("linkText");

            var elementScope = session
                .FindIdEndingWith(linkText, _Options)
                .WithSession(session);

            return elementScope;
        }

        internal static IList<SessionElementScope> FindAllSessionElementsByXPath(this DriverScope session, string xPath)
        {
            if (ReferenceEquals(session, null)) throw new ArgumentNullException("session"); 
            if (String.IsNullOrEmpty(xPath))    throw new ArgumentNullException("xPath");

            var elements = session
                .FindAllXPath(xPath, options: _Options);

            var elementScopes = elements.SyncSnapshots();

            return elementScopes;
        }

        internal static SessionElementScope FindSynonymRow(this IList<SessionElementScope> synonymRows, SynonymRow synonymToSelect)
        {
            if (ReferenceEquals(synonymRows, null))     throw new ArgumentNullException("synonymRows");
            if (ReferenceEquals(synonymToSelect, null)) throw new ArgumentNullException("synonymToSelect");

            var code = synonymToSelect.SelectedTermPathRow.Code;

            foreach (var synonymRow in synonymRows)
            {
                var synonymRowColumns = synonymRow.FindAllSessionElementsByXPath("td").ToArray();
                var termPathCell = synonymRowColumns.FirstOrDefault(x => x.Text.Contains(code));

                if (ReferenceEquals(termPathCell, null))
                {
                    return null;
                }

                var rowVerbatim = synonymRowColumns[0].Text;
                var rowSelectedTerm = TermPathRowDisplay.GetSelectedCodingHistoryTermPathRow(termPathCell);

                if (rowVerbatim.Equals(synonymToSelect.Verbatim)
                    && rowSelectedTerm.Code.Equals(code))
                {
                    return synonymRow;
                }
            }

            throw new ArgumentException("No synonym row found to select");
        }

        internal static IList<SessionElementScope> SyncSnapshots(this IEnumerable<SnapshotElementScope> snapshots)
        {
            if (ReferenceEquals(snapshots,null)) throw new ArgumentNullException("snapshots");

            var synchedElements = snapshots.Select(element => element.FindSessionElementByXPath(".")).ToList();

            return synchedElements;
        }

        internal static void SetSingleListBoxOptionCriteria(this SessionElementScope sessionElementScope, string text)
        {
            if (ReferenceEquals(sessionElementScope, null)) throw new ArgumentNullException("sessionElementScope");
            if (String.IsNullOrWhiteSpace(text))            return;

            sessionElementScope.SelectSingleListBoxOption(text);
        }

        internal static void SetTextBoxSearchCriteria(this SessionElementScope sessionElementScope, string text)
        {
            if (ReferenceEquals(sessionElementScope, null)) throw new ArgumentNullException("sessionElementScope");
            if (String.IsNullOrWhiteSpace(text))            return;

            sessionElementScope.FillInWith(text);
        }

        internal static SessionElementScope FindTableRow(this SessionElementScope table, string rowContents)
        {
            if (ReferenceEquals(table, null))           throw new ArgumentNullException("table");
            if (String.IsNullOrWhiteSpace(rowContents)) throw new ArgumentNullException("rowContents");

            var tableRows = table.GetTableRows();

            SessionElementScope tableRow = null;

            RetryPolicy.FindElement.Execute(() =>
            {
                tableRow = tableRows.FirstOrDefault(x => x.Text.Contains(rowContents, StringComparison.OrdinalIgnoreCase));

                if (ReferenceEquals(tableRow, null))
                {
                    // Text in text type inputs in edit more are not included in .Text. Explicitly check for any inputs containing the row contents.
                    foreach (var targetTableRow in tableRows)
                    {
                        var inputs = targetTableRow.FindAllSessionElementsByXPath(".//input");

                        var inputsWithRowContents = inputs.Select(x => x)
                                .Where(x => x.Value.Contains(rowContents, StringComparison.OrdinalIgnoreCase));

                        if (inputsWithRowContents.Any())
                        {
                            tableRow = targetTableRow;
                            break;
                        }
                    }
                }

                if (ReferenceEquals(tableRow, null))
                {
                    throw new MissingHtmlException(String.Format("Could not find an instance of the table row with contents '{0}'", rowContents));
                }
            });

            return tableRow;
        }

        /// <summary>
        /// Finds a specific cell in a table based on the filter criteria. Limit use to locating control elements (links, inputs, etc) in dynamic tables.
        /// </summary>
        internal static SessionElementScope FindTableCell(this SessionElementScope table, string rowContents, string targetColumnHeader)
        {
            if (ReferenceEquals(table, null))             throw new ArgumentNullException("table");
            if (String.IsNullOrEmpty(rowContents))        throw new ArgumentNullException("rowContents");
            if (String.IsNullOrEmpty(targetColumnHeader)) throw new ArgumentNullException("targetColumnHeader ");

            var tableRows = table.GetTableRows();

            if (!tableRows.Any())
            {
                throw new MissingHtmlException("The table is empty.");
            }

            int columnIndex = table.GetTableColumnIndex(targetColumnHeader);

            var tableRow = table.FindTableRow(rowContents);

            var tableColumns = tableRow.FindAllSessionElementsByXPath("td");

            if (tableColumns.Count <= columnIndex)
            {
                throw new MissingHtmlException(String.Format("No table cells found for column {0} in row containing {1}", targetColumnHeader, rowContents));
            }

            var tableCell = tableColumns[columnIndex];

            return tableCell;
        }

        /// <summary>
        /// Finds a specific cell in a table based on the filter criteria. Limit use to locating control elements (links, inputs, etc) in dynamic tables.
        /// </summary>
        internal static SessionElementScope FindTableCell(this SessionElementScope table, string rowFilterHeader, string rowFilterValue, string targetColumnHeader)
        {
            if (ReferenceEquals(table, null))             throw new ArgumentNullException("table");
            if (String.IsNullOrEmpty(rowFilterHeader))    throw new ArgumentNullException("rowFilterHeader");
            if (String.IsNullOrEmpty(rowFilterValue))     throw new ArgumentNullException("rowFilterValue");
            if (String.IsNullOrEmpty(targetColumnHeader)) throw new ArgumentNullException("targetColumnHeader");

            var tableRows = table.GetTableRows();

            if (!tableRows.Any())
            {
                throw new MissingHtmlException("The table is empty.");
            }

            int filterIndex = table.GetTableColumnIndex(rowFilterHeader);
            int columnIndex = table.GetTableColumnIndex(targetColumnHeader);

            var tableCell =
                (
                    from   tableRow in tableRows
                    select tableRow.FindAllSessionElementsByXPath("td")
                    into   columns
                    where  columns[filterIndex].Text.EqualsIgnoreCase(rowFilterValue)
                    select columns[columnIndex]
                ).FirstOrDefault();

            if (ReferenceEquals(tableCell, null))
            {
                throw new MissingHtmlException(String.Format("No cells found for column {0} where {1} is {2}", targetColumnHeader, rowFilterHeader, rowFilterValue));
            }

            return tableCell;
        }

        internal static IList<SessionElementScope> GetRowColumns(this SessionElementScope row)
        {
            var columns = row.FindAllSessionElementsByXPath(".//td");

            return columns;
        }

        internal static int GetTableColumnIndex(this SessionElementScope table, string columnName)
        {
            if (ReferenceEquals(table, null))     throw new ArgumentNullException("table");
            if (String.IsNullOrEmpty(columnName)) throw new ArgumentNullException("columnName");

            var tableRows = table.GetTableRows();

            if (!tableRows.Any())
            {
                throw new MissingHtmlException("The table is empty.");
            }

            var headerRow = tableRows.First();

            var headers   = headerRow.FindAllSessionElementsByXPath("td").ToList();

            var header    = headers.SingleOrDefault(x => x.Text.EqualsIgnoreCase(columnName));

            if (ReferenceEquals(header, null))
            {
                throw new MissingHtmlException(String.Format("Column {0} could not be found.", columnName));
            }

            int columnIndex = headers.IndexOf(header);

            return columnIndex;
        }

        internal static IEnumerable<SessionElementScope> GetTableRows(this SessionElementScope table)
        {
            if (ReferenceEquals(table, null)) throw new ArgumentNullException("table");

            var tableRows = table.FindAllSessionElementsByXPath(".//tr");

            return tableRows;
        }

    }
}
