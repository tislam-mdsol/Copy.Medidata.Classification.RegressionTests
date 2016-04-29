
namespace Coder.DeclarativeBrowser.Models.UIDataModels
{
    public class StudySetupData
    {
        public long   StudyId        { get; set; }
        public string StudyName      { get; set; }
        public string StudyUuid      { get; set; }
        public string ExternalOid    { get; set; }
        public string ProtocolNumber { get; set; }
        public bool IsProduction     { get; set; }
        public SiteSetupData[] Sites { get; set; }
    }
}
