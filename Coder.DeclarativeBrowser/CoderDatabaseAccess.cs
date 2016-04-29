using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Coder.DeclarativeBrowser.Db;

namespace Coder.DeclarativeBrowser
{
    public class CoderDatabaseAccess
    {
        private static readonly IDictionary<string, string> LocaleConversion = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
           {"eng", "English" },
           {"jpn", "Japanese"},
           {"kor", "Korean"  }, 
           {"chn", "Chinese" }
        };

        private static ICoderDbConnectionFactory _CoderDbFactory;

        private static ICoderDbConnectionFactory CoderDbFactory
        {
            get
            {
                if (!ReferenceEquals(_CoderDbFactory, null)) { return _CoderDbFactory; }

                _CoderDbFactory = new CoderDbConnectionFactory(Config.CoderDbConnectionString);

                return _CoderDbFactory;
            }
        }

        public static SourceSystemApplicationData GetSourceSystemApplicationData(string applicationName)
        {
            if (String.IsNullOrEmpty(applicationName))  throw new ArgumentNullException("applicationName"); 

            using (var db = CoderDbFactory.Build())
            {
                var commandResponse = db.Execute.spGetSourceSystemApplicationData(applicationName);
                var responseData    = commandResponse.Data[0];

                var applicationData = new SourceSystemApplicationData
                {
                    SourceSystem            = responseData.SourceSystem,
                    SourceSystemLocale      = responseData.SourceSystemLocale,
                    ConnectionUri           = responseData.ConnectionURI
                };

                return applicationData;
            }
        }

        public static CurrentCodingElementData GetCurrentCodingElementData(string segment)
        {
            if (String.IsNullOrEmpty(segment)) throw new ArgumentNullException("segment"); 

            using (var db = CoderDbFactory.Build())
            {
                var commandResponse = db.Execute.spGetCurrentCodingElement(segment);
                var responseData    = commandResponse.Data[0];

                var codingElementData = new CurrentCodingElementData
                {
                    CreationDate = responseData.Created.ToString(),
                    AutoCodeDate = responseData.AutoCodeDate.ToString()
                };

                return codingElementData;
            }
        }

        public static SegmentSetupData GetSegmentSetupDataByUserName(string userName, bool isProductionStudy)
        {
            if (String.IsNullOrEmpty(userName)) throw new ArgumentNullException("userName"); 

            using (var db = CoderDbFactory.Build())
            {
                var commandResponse = db.Execute.spGetSegmentSetupDataByUserName(userName, isProductionStudy);
                var responseData    = commandResponse.Data[0];

                var setupData = new SegmentSetupData
                {
                    SegmentName                     = responseData.SegmentName,
                    Studies = new StudySetupData[]
                    {
                        new StudySetupData()
                        {
                            StudyName = responseData.SourceSystemStudyName, //responseData.ProjectName
                            StudyUuid = responseData.StudyOid,
                            ProtocolNumber = responseData.ProtocolNumber
                        }
                    }
                };

                return setupData;
            }
        }

        public static string GetUserNameByLogin(string login)
        {
            if (String.IsNullOrEmpty(login)) throw new ArgumentNullException("login"); 

            using (var db = CoderDbFactory.Build())
            {
                var commandResponse         = db.Execute.spGetUserNameByLogin(login);
                var responseData            = commandResponse.Data[0];
                
                return responseData.UserName;
            }
        }
        
        private static string GetVersionLocaleKey(string dictionary, string dictionaryVersion, string locale)
        {
            if (String.IsNullOrEmpty(dictionary))            throw new ArgumentNullException("dictionary");         
            if (String.IsNullOrEmpty(dictionaryVersion))     throw new ArgumentNullException("dictionaryVersion");  
            if (String.IsNullOrEmpty(locale))                throw new ArgumentNullException("locale");

            string localeKey;
            
            if (!LocaleConversion.TryGetValue(locale, out localeKey))
            {
                throw new ArgumentOutOfRangeException("locale", "not recognized");
            }
            
            var versionKey = dictionaryVersion.Replace('.', '_');

            var versionLocaleKey = String.Format("{0}-{1}-{2}",dictionary, versionKey, localeKey);

            return versionLocaleKey;
        }

        private static string GetDictionaryKey(string dictionary, string dictionaryVersion)
        {
            if (String.IsNullOrEmpty(dictionary))            throw new ArgumentNullException("dictionary");          
            if (String.IsNullOrEmpty(dictionaryVersion))     throw new ArgumentNullException("dictionaryVersion"); 

            using (var db = CoderDbFactory.Build())
            {
                var commandResponse = db.Execute.spGetDictionaryAndVersions();
                
                var responseData = commandResponse
                    .Data
                    .Where(row => row.dictionaryOid.Equals(dictionary, StringComparison.OrdinalIgnoreCase)
                        && row.versionOid.Equals(dictionaryVersion, StringComparison.OrdinalIgnoreCase))
                    .ToList();

                Debug.Assert(responseData.Count().Equals(1), "Multiple dictionary keys exist for this dictionary version, should be only one");

                var dictionaryKey = responseData.First().dictionaryKey;

                if (String.IsNullOrEmpty(dictionaryKey))  throw new NullReferenceException("dictionaryKey"); 

                return dictionaryKey;
            }
        }

        public static void DeleteWorkFlowRole(
            string roleName,
            string segmentName)
        {
            if (ReferenceEquals(roleName, null)) throw new ArgumentNullException("roleName");
            if (ReferenceEquals(segmentName, null)) throw new ArgumentNullException("segmentName");
            using (var db = CoderDbFactory.Build())
            {
                db.Execute.spDeleteWorkFlowRole(roleName, segmentName);
            }
        }

        public static void DeleteGeneralRole(
           string roleName,
           string segmentName)
        {
            if (ReferenceEquals(roleName, null)) throw new ArgumentNullException("roleName");
            if (ReferenceEquals(segmentName, null)) throw new ArgumentNullException("segmentName");
            using (var db = CoderDbFactory.Build())
            {
                db.Execute.spDeleteGeneralRole(roleName, segmentName);
            }
        }

        public static void CreateWorkFlowRole(
            string roleName,
            string segmentName)
        {
            if (ReferenceEquals(roleName, null)) throw new ArgumentNullException("roleName");
            if (ReferenceEquals(segmentName, null)) throw new ArgumentNullException("segmentName");
            using (var db = CoderDbFactory.Build())
            {
                db.Execute.spCreateWorkFlowRole(roleName, segmentName);
            }
        }

        public static void RegisterProject(
            string protocolNumber,
            string segment,
            string dictionary,
            string dictionaryVersion,
            string locale,
            string synonymListName,
            string registrationName)
        {
            if (String.IsNullOrEmpty(protocolNumber))        throw new ArgumentNullException("protocolNumber");           
            if (String.IsNullOrEmpty(segment))               throw new ArgumentNullException("segment");           
            if (String.IsNullOrEmpty(dictionary))            throw new ArgumentNullException("dictionary");        
            if (String.IsNullOrEmpty(dictionaryVersion))     throw new ArgumentNullException("dictionaryVersion"); 
            if (String.IsNullOrEmpty(locale))                throw new ArgumentNullException("locale");            
            if (String.IsNullOrEmpty(synonymListName))       throw new ArgumentNullException("synonymListName");   
            if (String.IsNullOrEmpty(registrationName))      throw new ArgumentNullException("registrationName");  

            var dictionaryKey = GetDictionaryKey(dictionary, dictionaryVersion);

            using (var db = CoderDbFactory.Build())
            {
                var versionLocaleKey = GetVersionLocaleKey(dictionaryKey, dictionaryVersion, locale);
                db.Execute.spCreateSynonymList(segment, versionLocaleKey, synonymListName);
                db.Execute.spActivateSynonymListForDictionaryVersionLocaleSegment(versionLocaleKey, segment, synonymListName);
                db.Execute.spDoProjectRegistration(protocolNumber, segment, versionLocaleKey, synonymListName, registrationName);
            }
        }

        public static void CreateSynonymList(
            string segment,
            string dictionary,
            string dictionaryVersion,
            string locale,
            string synonymListName)
        {
            if (String.IsNullOrEmpty(segment))              throw new ArgumentNullException("segment");
            if (String.IsNullOrEmpty(dictionary))           throw new ArgumentNullException("dictionary");
            if (String.IsNullOrEmpty(dictionaryVersion))    throw new ArgumentNullException("dictionaryVersion");
            if (String.IsNullOrEmpty(locale))               throw new ArgumentNullException("locale");
            if (String.IsNullOrEmpty(synonymListName))      throw new ArgumentNullException("synonymListName");

            var dictionaryKey = GetDictionaryKey(dictionary, dictionaryVersion);

            using (var db = CoderDbFactory.Build())
            {
                var versionLocaleKey = GetVersionLocaleKey(dictionaryKey, dictionaryVersion, locale);

                db.Execute.spCreateSynonymList(segment, versionLocaleKey, synonymListName);
            }
        }

        public static void CreateAndActivateSynonymList(
            string segment,
            string dictionary,
            string dictionaryVersion,
            string locale,
            string synonymListName)
        {
            if (String.IsNullOrEmpty(segment))           throw new ArgumentNullException("segment");
            if (String.IsNullOrEmpty(dictionary))        throw new ArgumentNullException("dictionary");
            if (String.IsNullOrEmpty(dictionaryVersion)) throw new ArgumentNullException("dictionaryVersion");
            if (String.IsNullOrEmpty(locale))            throw new ArgumentNullException("locale");
            if (String.IsNullOrEmpty(synonymListName))   throw new ArgumentNullException("synonymListName");

            var dictionaryKey = GetDictionaryKey(dictionary, dictionaryVersion);

            using (var db = CoderDbFactory.Build())
            {
                var versionLocaleKey = GetVersionLocaleKey(dictionaryKey, dictionaryVersion, locale);
                db.Execute.spCreateSynonymList(segment, versionLocaleKey, synonymListName);
                db.Execute.spActivateSynonymListForDictionaryVersionLocaleSegment(versionLocaleKey, segment, synonymListName);
            }
        }

        public static void UpdateCoderConfiguration(
            string segment,
            string dictionary,
            string version,
            string defaultLocale,
            string codingTaskPageSize,
            string forcePrimaryPathSelection,
            string searchLimitReclassificationResult,
            string synonymCreationPolicyFlag,
            string bypassReconsiderUponReclassifyFlag,
            string isAutoAddSynonym,
            string isAutoApproval,
            string maxNumberofSearchResults
            )
        {
            if (String.IsNullOrEmpty(segment))                               throw new ArgumentNullException("segment");                               
            if (String.IsNullOrEmpty(dictionary))                            throw new ArgumentNullException("dictionary");
            if (String.IsNullOrEmpty(version))                               throw new ArgumentNullException("version");
            if (String.IsNullOrEmpty(defaultLocale))                         throw new ArgumentNullException("defaultLocale");                         
            if (String.IsNullOrEmpty(codingTaskPageSize))                    throw new ArgumentNullException("codingTaskPageSize");                    
            if (String.IsNullOrEmpty(forcePrimaryPathSelection))             throw new ArgumentNullException("forcePrimaryPathSelection");             
            if (String.IsNullOrEmpty(searchLimitReclassificationResult))     throw new ArgumentNullException("searchLimitReclassificationResult");     
            if (String.IsNullOrEmpty(synonymCreationPolicyFlag))             throw new ArgumentNullException("synonymCreationPolicyFlag");             
            if (String.IsNullOrEmpty(bypassReconsiderUponReclassifyFlag))    throw new ArgumentNullException("bypassReconsiderUponReclassifyFlag");    
            if (String.IsNullOrEmpty(isAutoAddSynonym))                      throw new ArgumentNullException("isAutoAddSynonym");                      
            if (String.IsNullOrEmpty(isAutoApproval))                        throw new ArgumentNullException("isAutoApproval");                        
            if (String.IsNullOrEmpty(maxNumberofSearchResults))              throw new ArgumentNullException("maxNumberofSearchResults");


            var dictOid = GetDictionaryKey(dictionary, version);

            using (var db = CoderDbFactory.Build())
            {
                db.Execute.spSetupGranularDefaultConfiguration(
                    segment,
                    defaultLocale,
                    codingTaskPageSize,
                    forcePrimaryPathSelection,
                    searchLimitReclassificationResult,
                    synonymCreationPolicyFlag,
                    bypassReconsiderUponReclassifyFlag,
                    dictOid,
                    isAutoAddSynonym,
                    isAutoApproval,
                    maxNumberofSearchResults
                    );
            }
        }

        internal static void CleanupDoNotAutoCodeTermsBySegment(string segmentName, string dictionaryList)
        {
            if (String.IsNullOrWhiteSpace(segmentName))    throw new ArgumentNullException("segmentName");
            if (String.IsNullOrWhiteSpace(dictionaryList)) throw new ArgumentNullException("dictionaryList"); 

            using (var db = CoderDbFactory.Build())
            {
                db.Execute.spDeleteDoNotAutoCodeTerms(
                    pSegmentName   : segmentName,
                    pDictionaryList: dictionaryList);
            }
        }

        internal static void InsertDoNotAutoCode(string segmentName, string dictionaryList, string verbatimTerm, string dictionary, string level, string login)
        {
            if (String.IsNullOrWhiteSpace(segmentName))    throw new ArgumentNullException("segmentName");
            if (String.IsNullOrWhiteSpace(dictionaryList)) throw new ArgumentNullException("dictionaryList");
            if (String.IsNullOrWhiteSpace(verbatimTerm))   throw new ArgumentNullException("verbatimTerm");
            if (String.IsNullOrWhiteSpace(dictionary))     throw new ArgumentNullException("dictionary");
            if (String.IsNullOrWhiteSpace(level))          throw new ArgumentNullException("level");
            if (String.IsNullOrWhiteSpace(login))          throw new ArgumentNullException("login");

            using (var db = CoderDbFactory.Build())
            {
                db.Execute.spInsertDoNotAutoCodeTerms(
                    pSegmentName   : segmentName,
                    pDictionaryList: dictionaryList,
                    pTerm          : verbatimTerm,
                    pDictionary    : dictionary,
                    pLevel         : level,
                    pLogin         : login);
            }
        }

        public static IMedidataStudy GetStudyDataByProjectName(string segmentName, string projectName)
        {
            if (String.IsNullOrWhiteSpace(segmentName)) throw new ArgumentNullException("segmentName");
            if (String.IsNullOrWhiteSpace(projectName)) throw new ArgumentNullException("projectName");

            using (var db = CoderDbFactory.Build())
            {
                var responseData = Config.StoredProcRetryPolicy.Execute(
                    () => GetStudyByProjectCommandResponse(db, segmentName, projectName));

                var studyAttributes = new IMedidataStudy()
                {
                    Name = responseData.SourceSystemStudyName,
                    ObjectID = responseData.StudyOid,
                    ProtocolNumber = responseData.ProtocolNumber
                };

                return studyAttributes;
            }
        }

        private static spGetStudyDataByProjectCommandResponseData GetStudyByProjectCommandResponse(
            ICoderDbConnection db, 
            string segmentName, 
            string projectName)
        {
            if (String.IsNullOrWhiteSpace(segmentName)) throw new ArgumentNullException("segmentName");
            if (String.IsNullOrWhiteSpace(projectName)) throw new ArgumentNullException("projectName");

            var commandResponse = db.Execute.spGetStudyDataByProject(segmentName, projectName);
            var responseData    = commandResponse.Data.FirstOrDefault();

            if (ReferenceEquals(responseData, null)) throw new ArgumentException(
                     String.Format("Study with combination of segment {0} and project {1} not found", segmentName, projectName));

            if (String.IsNullOrWhiteSpace(responseData.StudyOid)) throw new InvalidOperationException("IMedidata Sync not finished");

            return responseData;
        }

        internal static void FakeStudyMigration(
            string loginName, 
            string segment, 
            string studyName, 
            SynonymList sourceSynonymList, 
            SynonymList targetSynonymList)
        {
            if (String.IsNullOrWhiteSpace(loginName))     throw new ArgumentNullException("loginName");
            if (String.IsNullOrWhiteSpace(segment))       throw new ArgumentNullException("segment");
            if (String.IsNullOrWhiteSpace(studyName))     throw new ArgumentNullException("studyName");
            if (ReferenceEquals(sourceSynonymList, null)) throw new ArgumentNullException("sourceSynonymList");
            if (ReferenceEquals(targetSynonymList, null)) throw new ArgumentNullException("targetSynonymList");

            var sourceDictionaryVersion = sourceSynonymList.Version;
            var sourceDictionaryLocale  = sourceSynonymList.Locale;
            var sourceSynonymListName   = sourceSynonymList.SynonymListName;
            var sourceDictionaryKey     = GetDictionaryKey(sourceSynonymList.Dictionary, sourceDictionaryVersion);

            var targetDictionaryVersion = targetSynonymList.Version;
            var targetDictionaryLocale  = targetSynonymList.Locale;
            var targetSynonymListName   = targetSynonymList.SynonymListName;
            var targetDictionaryKey     = GetDictionaryKey(targetSynonymList.Dictionary, targetDictionaryVersion);

            using (var db = CoderDbFactory.Build())
            {
                var sourceDictionaryVersionLocaleKey = GetVersionLocaleKey(sourceDictionaryKey, sourceDictionaryVersion, sourceDictionaryLocale);
                var targetDictionaryVersionLocaleKey = GetVersionLocaleKey(targetDictionaryKey, targetDictionaryVersion, targetDictionaryLocale);

                db.Execute.spFakeStudyMigrationFailure(
                    pUserLogin                            : loginName,
                    pSegmentName                          : segment,
                    pStudyName                            : studyName,
                    pFromSynonymListName                  : sourceSynonymListName,
                    pToSynonymListName                    : targetSynonymListName,
                    pFromMedicalDictionaryVersionLocaleKey: sourceDictionaryVersionLocaleKey,
                    pToMedicalDictionaryVersionLocaleKey  : targetDictionaryVersionLocaleKey);
            }
        }

        public static string GetTaskQueryUUID(string taskUuid)
        {
            if (String.IsNullOrEmpty(taskUuid)) throw new ArgumentNullException("taskUuid");

            using (var db = CoderDbFactory.Build())
            {
                var commandResponse = db.Execute.spGetQueryUUIDByCodingElementUUID(taskUuid);
                var responseData = commandResponse.Data[0];

                return responseData.QueryUUID;
            }
        }

        public static void AgeTask(string taskUuid, int hoursToAge)
        {
            if (String.IsNullOrEmpty(taskUuid)) throw new ArgumentNullException("taskUuid");

            using (var db = CoderDbFactory.Build())
            {
                db.Execute.spCreationDateAgingByCodingElementUUID(taskUuid, hoursToAge);
            }
        }

        public static void AgeSynonym(string segment, string verbatim, int hoursToAge, bool ageCreatedOnly = false)
        {
            if (String.IsNullOrEmpty(segment))  throw new ArgumentNullException("segment");
            if (String.IsNullOrEmpty(verbatim)) throw new ArgumentNullException("verbatim");

            using (var db = CoderDbFactory.Build())
            {
                db.Execute.spAgeSynonymCreationDate(segment, verbatim, hoursToAge, ageCreatedOnly);
            }
        }
    }
}
