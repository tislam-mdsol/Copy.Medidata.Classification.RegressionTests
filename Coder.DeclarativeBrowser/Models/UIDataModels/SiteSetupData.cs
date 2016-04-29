using System.Collections.Generic;

namespace Coder.DeclarativeBrowser.Models.UIDataModels
{
    public class SiteSetupData
    {
        public string SiteName                  { get; set; }
        public string SiteNumber                { get; set; }
        public IList<SubjectSetupData> Subjects { get; set; }

        public SiteSetupData()
        {
            Subjects = new List<SubjectSetupData>();
        }

        public void AddSubject(string initials = "", string number = "", string id = "")
        {
            Subjects.Add(
                new SubjectSetupData
                {
                    SubjectInitials = initials,
                    SubjectNumber   = number,
                    SubjectId       = id
                });
        }
    }
}
