using System;
using System.Collections.Generic;
using System.Linq;

namespace Coder.DeclarativeBrowser.Models.UIDataModels
{
    public class SegmentSetupData
    {
        public int    SegmentId                         { get; set; }
        public string SegmentName                       { get; set; }
        public string SegmentUuid                       { get; set; }
        public string ProtocolNumber                    { get; set; }
        public string Customer                          { get; set; }
        public bool UseRaveX                            { get; set; }
        public string NameSuffix                        { get; set; }

        public IEnumerable<MedidataApp> StudyGroupApps  { get; set; }

        public StudySetupData[] Studies                 { get; set; }

        public StudySetupData ProdStudy
        {
            get
            {
                if (ReferenceEquals(Studies, null)) throw new InvalidOperationException("Studies not established");

                var primaryStudy = Studies.FirstOrDefault(x => !x.StudyName.Contains(Config.UserAcceptanceStudySuffix) && !x.StudyName.Contains(Config.DevelopmentStudySuffix));

                return primaryStudy;
            }
        }

        public StudySetupData UatStudy
        {
            get
            {
                if (ReferenceEquals(Studies, null)) throw new InvalidOperationException("Studies not established");

                var primaryStudy = Studies.FirstOrDefault(x => x.StudyName.Contains(Config.UserAcceptanceStudySuffix));

                return primaryStudy;
            }
        }

        public StudySetupData DevStudy
        {
            get
            {
                if (ReferenceEquals(Studies, null)) throw new InvalidOperationException("Studies not established");

                var primaryStudy = Studies.FirstOrDefault(x => x.StudyName.Contains(Config.DevelopmentStudySuffix));

                return primaryStudy;
            }
        }
    }
}
