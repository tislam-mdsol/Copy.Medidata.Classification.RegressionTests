
namespace Coder.DeclarativeBrowser.Models.GridModels
{
    public class UploadedCodingTask
    {
        public string FileName       { get; set; }
        public string Uploaded       { get; set; }
        public string User           { get; set; }
        public string Status         { get; set; }
        public string Succeeded      { get; set; }
        public string Failed         { get; set; }
        public string DownloadFailed { get; set; }
    }
}