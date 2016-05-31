
namespace Coder.DeclarativeBrowser.IMedidataApi.Models
{
    public class IMedidataAPIStudy
    {
        public string name           { get; set; }
        public string oid            { get; set; }
        public string UUID           { get; set; }
        public string mcc_study_uuid { get; set; }
        public string status         { get; set; }
        public string phase          { get; set; }
        public string indication     { get; set; }
        public bool is_production    { get; set; }
    }
}
