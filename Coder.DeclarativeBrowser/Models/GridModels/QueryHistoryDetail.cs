using Coder.DeclarativeBrowser.ExtensionMethods;
using System;

namespace Coder.DeclarativeBrowser.Models.GridModels
{
    public class QueryHistoryDetail
    {
        public string User          { get; set; }
        public string VerbatimTerm  { get; set; }
        public string QueryStatus   { get; set; }
        public string QueryText     { get; set; }
        public string QueryResponse { get; set; }
        public string OpenTo        { get; set; }
        public string QueryNotes    { get; set; }
        public string TimeStamp     { get; set; }

        public bool Equals(QueryHistoryDetail expected)
        {
            if (ReferenceEquals(expected, null)) throw new ArgumentNullException("expected");
         
            var result = expected.User .Contains                ( User, StringComparison.OrdinalIgnoreCase)
                      && VerbatimTerm  .IsNullOrEqualsIfRequired( expected.VerbatimTerm                   )
                      && QueryStatus   .IsNullOrEqualsIfRequired( expected.QueryStatus                    )
                      && QueryText     .IsNullOrEqualsIfRequired( expected.QueryText                      )
                      && QueryResponse .IsNullOrEqualsIfRequired( expected.QueryResponse                  )
                      && OpenTo        .IsNullOrEqualsIfRequired( expected.OpenTo                         )
                      && QueryNotes    .IsNullOrEqualsIfRequired( expected.QueryNotes                     );

            return result;
        }

        public string ToString()
        {
            var response = String.Format("User: {0}, VerbatimTerm: {1}, QueryStatus: {2}, QueryText: {3}, QueryResponse: {4}, OpenTo: {5}, QueryNotes {6}, TimeStamp {7}",
                User, VerbatimTerm, QueryStatus, QueryText, QueryResponse, OpenTo, QueryNotes, TimeStamp);

            return response;
        }
    }
}
