using System;

namespace Coder.DeclarativeBrowser.Models
{
    public class OdmQueryParameters
    {
        public string QueryUuid       { get; private set; }
        public string Recipient       { get; private set; }
        public string QueryRepeatKey  { get; private set; }
        public string Status          { get; private set; }
        public string Value           { get; private set; }
        public string Response        { get; private set; }
        public string Username        { get; private set; }
        public string DateTime        { get; private set; }

        public OdmQueryParameters(
            string queryUuid, 
            string recipient,
            string queryRepeatKey,
            string status,        
            string value,         
            string response)
        {

            QueryUuid      = queryUuid      ?? String.Empty;
            Recipient      = recipient      ?? String.Empty;
            QueryRepeatKey = queryRepeatKey ?? String.Empty;
            Status         = status         ?? String.Empty;
            Value          = value          ?? String.Empty;
            Response       = response       ?? String.Empty;
            Username       = "System User";
            DateTime       = System.DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ss");
        }
    }
}
