using System;
using System.Linq;
using Coder.DeclarativeBrowser.Models.ETEModels;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Coder.DeclarativeBrowser.OdmBuilder;

namespace Coder.DeclarativeBrowser.Models
{
    public enum StudyType { Production, Development, UserAcceptanceTesting }

    public class StepContext
    {
        // Application Monitoring
        public string AdverseEventText              { get; set; }
        
        // Task Details
        public string AutoCodeDate                  { get; set; }
        public string ConnectionUri                 { get; set; }
        public string CreationDate                  { get; set; }
        public string SourceSystem                  { get; set; }

        // Task Generation
        public string FileOid                       { get; set; }
        public string CodingTermUuid                { get; set; }
        public string IsApprovalRequired            { get; set; }
        public string IsAutoApproval                { get; set; }
        
        // Dictionary
        public string Dictionary                    { get; set; }
        public string Locale                        { get; set; }
        public string Version                       { get; set; }
        public SynonymList SourceSynonymList        { get; set; }
        public SynonymList TargetSynonymList        { get; set; }
        
        // Rave Source
        public string DraftName                     { get; set; }
        public string SourceDraftVersionName        { get; set; }
        public string TargetDraftVersionName        { get; set; }
        public bool UseRaveX                        { get; set; }
        public SegmentSetupData SegmentUnderTest    { get; set; }
        public StudyType ActiveStudyType            { get; set; }

        // Test Execution
        public string DownloadDirectory             { get; set; }
        public string DumpDirectory                 { get; set; }
        public CoderDeclarativeBrowser Browser      { get; set; }
        public OdmManager OdmManager                { get; set; }
        
        // Users
        public MedidataUser RaveAdminUser           { get; set; }
        public MedidataUser CoderAdminUser          { get; set; }
        public MedidataUser CoderTestUser           { get; set; }
        public MedidataUser CoderSystemuser         { get; set; }

        public string GetUser()
        {
            if (ReferenceEquals(CoderTestUser, null)) return String.Empty;

            var user = CoderTestUser;

            return user.Username;
        }

        public string GetUserDisplayName()
        {
            if (ReferenceEquals(CoderTestUser, null)) throw new ArgumentNullException("CoderTestUser");
            
            var userDisplayName = CoderTestUser.GetDisplayName();

            return userDisplayName;
        }

        public string GetSystemUser()
        {
            if (ReferenceEquals(CoderSystemuser, null)) return String.Empty;

            var user = CoderSystemuser;

            return user.Username;
        }

        public string GetSegment()
        {
            if (ReferenceEquals(SegmentUnderTest, null))             throw new InvalidOperationException("SegmentUnderTest property not set");

            return SegmentUnderTest.SegmentName;
        }
        
        public StudySetupData GetActiveStudy()
        {
            StudySetupData study;

            switch (ActiveStudyType)
            {
                case StudyType.Production:
                {
                    study = SegmentUnderTest.ProdStudy;
                    break;
                }
                case StudyType.Development:
                {
                    study = SegmentUnderTest.DevStudy;
                    break;
                }
                case StudyType.UserAcceptanceTesting:
                {
                    study = SegmentUnderTest.UatStudy;
                    break;
                }
                default:
                {
                    throw new InvalidOperationException("ActiveStudyType is not a valid study type.");
                }
            }

            if (ReferenceEquals(study, null)) throw new InvalidOperationException("study property not set");

            return study;
        }

        public string GetStudyUuid()
        {
            if (ReferenceEquals(SegmentUnderTest, null))             throw new InvalidOperationException("SegmentUnderTest property not set");

            var study = GetActiveStudy();

            return study.StudyUuid;
        }
        
        public string GetUatStudyUuid()
        {
            if (ReferenceEquals(SegmentUnderTest, null))             throw new InvalidOperationException("SegmentUnderTest property not set");
            if (ReferenceEquals(SegmentUnderTest.UatStudy, null))    throw new InvalidOperationException("SegmentUnderTest.UatStudy property not set");

            var study = SegmentUnderTest.UatStudy;

            return study.StudyUuid;
        }
        
        public string GetDevStudyUuid()
        {
            if (ReferenceEquals(SegmentUnderTest, null))             throw new InvalidOperationException("SegmentUnderTest property not set");
            if (ReferenceEquals(SegmentUnderTest.DevStudy, null))    throw new InvalidOperationException("SegmentUnderTest.DevStudy property not set");

            var study = SegmentUnderTest.DevStudy;

            return study.StudyUuid;
        }

        public string GetStudyDisplayName()
        {
            var studyName      = GetStudyName();
            var protocolNumber = GetProtocolNumber();

            var sourceSystemStudyDisplayName = String.Format("{0} - {1}", studyName, protocolNumber);

            return sourceSystemStudyDisplayName;
        }
      
        public string GetStudyName()
        {
            if (ReferenceEquals(SegmentUnderTest, null))             throw new InvalidOperationException("SegmentUnderTest property not set");

            var study = GetActiveStudy();

            return study.StudyName;
        }

        public string GetUatStudyName()
        {
            if (ReferenceEquals(SegmentUnderTest, null))             throw new InvalidOperationException("SegmentUnderTest property not set");
            if (ReferenceEquals(SegmentUnderTest.UatStudy, null))    throw new InvalidOperationException("SegmentUnderTest.UatStudy property not set");

            var study = SegmentUnderTest.UatStudy;

            return study.StudyName;
        }

        public string GetDevStudyName()
        {
            if (ReferenceEquals(SegmentUnderTest, null))             throw new InvalidOperationException("SegmentUnderTest property not set");
            if (ReferenceEquals(SegmentUnderTest.DevStudy, null))    throw new InvalidOperationException("SegmentUnderTest.DevStudy property not set");

            var study = SegmentUnderTest.DevStudy;

            return study.StudyName;
        }

        public SiteSetupData GetFirstSite()
        {
            if (ReferenceEquals(SegmentUnderTest, null))             throw new InvalidOperationException("SegmentUnderTest property not set");

            var study = GetActiveStudy();
            var sites = study.Sites;

            if (ReferenceEquals(sites, null) || !sites.Any())
            {
                throw new InvalidOperationException(String.Format("No sites for segment {0} study {1}", SegmentUnderTest.SegmentName, study.StudyName));
            }

            var site = sites.First();

            return site;
        }

        public string GetSite()
        {
            var site  = GetFirstSite();

            return site.SiteName;
        }

        public string GetSubjectId()
        {
            var site = GetFirstSite();

            var subjects = site.Subjects;

            if (ReferenceEquals(subjects, null) || !subjects.Any())
            {
                throw new InvalidOperationException(String.Format("No subjects for segment {0} site {1}", SegmentUnderTest.SegmentName, site.SiteName));
            }

            var subject = subjects.First();

            return subject.SubjectId;
        }

        public string GetProtocolNumber()
        {
            if (ReferenceEquals(SegmentUnderTest, null))             throw new InvalidOperationException("SegmentUnderTest property not set");

            var study = GetActiveStudy();

            return study.ProtocolNumber;
        }

        public DateTime GetTimeStamp()
        {
            var currentDateTime = DateTime.Now;

            return currentDateTime;
        }

        public RaveNavigationTarget GetRaveNavigationTarget()
        {
            var raveNavigationTarget = new RaveNavigationTarget
            {
                StudyName = GetStudyName(),
                SiteName  = GetSite(),
                SubjectId = GetSubjectId()
            };

            return raveNavigationTarget;
        }

        public RaveArchitectRecordTarget GetRaveArchitectRecordTarget()
        {
            var raveArchitectRecordTarget = new RaveArchitectRecordTarget
            {
                StudyName = GetStudyName(),
                DraftName = DraftName
            };

            return raveArchitectRecordTarget;
        }
    }
}
