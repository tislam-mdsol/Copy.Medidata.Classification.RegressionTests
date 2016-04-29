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
    }
}
