using System;

namespace Coder.DeclarativeBrowser.Models.UIDataModels
{
    public class DictionarySearchCriteria
    {
        public string DictionaryName                        { get; set; }
        public bool UsingSynonymList                        { get; set; }
        public string SynonymList                           { get; set; }
        public string Template                              { get; set; }
        public string TextTarget                            { get; set; }
        public string SearchText                            { get; set; }
        public bool PrimaryPathOnly                         { get; set; }
        public bool ExactMatchOnly                          { get; set; }
        public string[] Levels                              { get; set; }
        public DictionarySearchFilter[] AttributeFilters    { get; set; }
        public DictionarySearchFilter[] HigherLevelFilters  { get; set; }
    }

    public class DictionarySearchFilter
    {
        public string Operator  { get; set; }
        public string Attribute { get; set; }
        public string Text      { get; set; }
    }
}
