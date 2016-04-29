using System.Collections.Generic;
using Coder.DeclarativeBrowser.Models;
using System;

namespace Coder.DeclarativeBrowser.OdmBuilder
{
    public class OdmManager
    {
        private  Dictionary<string,OdmParameters> _SentOdmParameters;

        public OdmManager()
        {
            _SentOdmParameters = new Dictionary<string, OdmParameters>();
        }

        public void AddSentOdmParameters(OdmParameters odmParameters)
        {
            if (ReferenceEquals(odmParameters, null)) throw new ArgumentNullException("odmParameters");  
            
            //TODO:: For now, only keep the latest task for a specific verbatim.
            if (_SentOdmParameters.ContainsKey(odmParameters.VerbatimTerm))
            {
                _SentOdmParameters.Remove(odmParameters.VerbatimTerm);
            }

            _SentOdmParameters.Add(odmParameters.VerbatimTerm, odmParameters);
        }
        
        public OdmParameters GetPreviouslySentOdmParameters(string verbatim)
        {
            if (String.IsNullOrEmpty(verbatim))            throw new ArgumentNullException("verbatim");
            if (!_SentOdmParameters.ContainsKey(verbatim)) throw new ArgumentNullException("No task exists for verbatim");

            // ALways generate a new the File OID to avoid ODM upload issues
            _SentOdmParameters[verbatim].FileOid = Guid.NewGuid().ToString();

            return _SentOdmParameters[verbatim];
        }

        public void ChangeVerbatimOfPreviouslySentOdmParameters(string  currentVerbatim, string newVerbatim)
        {
            if (String.IsNullOrEmpty(currentVerbatim))            throw new ArgumentNullException("currentVerbatim");
            if (String.IsNullOrEmpty(newVerbatim))                throw new ArgumentNullException("newVerbatim");
            if (!_SentOdmParameters.ContainsKey(currentVerbatim)) throw new ArgumentNullException("No task exists for verbatim");
            
            OdmParameters odmParameters = _SentOdmParameters[currentVerbatim];
            odmParameters.VerbatimTerm = newVerbatim;

            _SentOdmParameters.Remove(currentVerbatim);

            AddSentOdmParameters(odmParameters);
        }
    }
}
