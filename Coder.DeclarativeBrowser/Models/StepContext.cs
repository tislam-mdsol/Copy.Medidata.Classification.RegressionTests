using System;
using Coder.DeclarativeBrowser.Models.ETEModels;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Coder.DeclarativeBrowser.OdmBuilder;

namespace Coder.DeclarativeBrowser.Models
{
    public class StepContext
    {
        public string AdverseEventText              { get; set; }
        public string AutoCodeDate                  { get; set; }
        public string CodingTermUuid                { get; set; }
        public string ConnectionUri                 { get; set; }
        public string CreationDate                  { get; set; }
        public string Dictionary                    { get; set; }
        public string FileOid                       { get; set; }
        public string IsApprovalRequired            { get; set; }
        public string IsAutoApproval                { get; set; }
        public string Locale                        { get; set; }
        public string Project                       { get; set; }
        public string ProtocolNumber                { get; set; }
        public string Segment                       { get; set; }
        public string NewGeneratedSegment           { get; set; }
        public string SetupType                     { get; set; }
        public string SourceSystem                  { get; set; }
        public string SourceSystemLocale            { get; set; }
        public string SourceSystemStudyName         { get; set; }
        public string SourceSystemStudyDisplayName  { get; set; }
        public string SubjectId                     { get; set; }
        public string StudyOid                      { get; set; }
        public string SystemUser                    { get; set; }
        public string User                          { get; set; }
        public string UserDisplayName               { get; set; }
        public string Version                       { get; set; }
        public string DownloadDirectory             { get; set; }
        public string DumpDirectory                 { get; set; }

        public SynonymList SourceSynonymList        { get; set; }
        public SynonymList TargetSynonymList        { get; set; }

        public MedidataUser RaveAdminUser           { get; set; }
        public MedidataUser CoderAdminUser          { get; set; }
        public MedidataUser CoderTestUser           { get; set; }
        public SegmentSetupData SegmentUnderTest    { get; set; }

        public CoderDeclarativeBrowser Browser      { get; set; }
        public OdmManager OdmManager                { get; set; }

        public string Uuid
        {
            get
            {
                var study = SegmentUnderTest.ProdStudy;

                return study.StudyUuid;
            }
        }

        public string UatUuid
        {
            get
            {
                var study = SegmentUnderTest.UatStudy;

                return study.StudyUuid;
            }
        }

        public string DevUuid
        {
            get
            {
                var study = SegmentUnderTest.DevStudy;

                return study.StudyUuid;
            }
        }

        public string DevStudyName
        {
            get
            {
                var study = SegmentUnderTest.DevStudy;

                return study.StudyName;
            }
        }

        public DateTime GetTimeStamp()
        {
            var currentDateTime = DateTime.Now;

            return currentDateTime;
        }
    }
}
