using System;

namespace Coder.DeclarativeBrowser.Models.GridModels
{
    public class ReclassificationSearch
    {
        private string _study;
        private string _subject;
        private string _verbatim;
        private string _term;
        private string _code;
        private string _priority;
        private string _form;    

        public string Study      { get { return _study    ?? String.Empty; } set {  _study    = value; } }
        public string Subject    { get { return _subject  ?? String.Empty; } set {  _subject  = value; } }
        public string Verbatim   { get { return _verbatim ?? String.Empty; } set {  _verbatim = value; } }
        public string Term       { get { return _term     ?? String.Empty; } set {  _term     = value; } }
        public string Code       { get { return _code     ?? String.Empty; } set {  _code     = value; } }
        public string Priority   { get { return _priority ?? String.Empty; } set {  _priority = value; } }
        public string Form       { get { return _form     ?? String.Empty; } set {  _form     = value; } }
    }
}
