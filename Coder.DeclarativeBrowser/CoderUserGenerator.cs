using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Coder.DeclarativeBrowser.Db;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.Models.ETEModels;

namespace Coder.DeclarativeBrowser
{
    public static class CoderUserGenerator
    {
        private const string _LicenseCode          = "abc123";
        private const string _WorkflowRoleName     = "WorkflowRole";
        private const string _LockKeyPrefix        = "SegmentRoleLock|";
        private const string _TimeZone             = "Eastern Standard Time";
        private const string _FirstName            = "Coder";
        private const string _UserLocale           = "eng";
        private const string _UserEmailTemplate    = "medidatacoder+{0}@gmail.com";
        private const int    _UserObjectTypeId     = 17;
        private const int    _LockDuration         = 600;
        private const int    _AdminUserId          = 2;
        private const int    _AllStudiesWorkflow   = -105;
        private const int    _SegmentConfigCloneId = 1;
        private const int    _MaxSearchResults     = 70;

        private static readonly IEnumerable<int> _WorkflowActionIds     = Enumerable.Range(1, 15);
        private static readonly DateTime         _LicenseStart          = new DateTime(2000, 1, 1);
        private static readonly DateTime         _LicenseEnd            = new DateTime(2055, 1, 1);
        private static readonly string[,]        _CoderDictionaries     = Config.CoderDictionaries;
        private static readonly string[]         _StudySuffixes         = { "", " (UAT)", " (Dev)" };

        private static readonly Tuple<int, string, int[]>[] _GeneralRoles      = Config.CoderGeneralRoles;

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


        public static void DeleteGeneratedUser(MedidataUser user, SegmentSetupData segment)
        {
            if (ReferenceEquals(user, null)) throw new ArgumentNullException("user");

            RetryPolicy.DatabaseRetry.Execute(
                () =>
                {
                    using (var db = CoderDbFactory.Build())
                    {
                        db.Execute.spDeleteGeneratedUser(segment.SegmentId, user.Username);
                    }
                });
        }

        public static GeneratedUser GenerateUser(string segmentNamePrefix)
        {
            if (String.IsNullOrWhiteSpace(segmentNamePrefix)) throw new ArgumentNullException("segmentNamePrefix");

            GeneratedUser generatedUser = new GeneratedUser();

            RetryPolicy.DatabaseRetry.Execute(
                () =>
                {
                    Guid iMedidataSegmentGuid = Guid.NewGuid();

                    using (var db = CoderDbFactory.Build())
                    {
                        var newSegment     = CreateNewSegment(db, iMedidataSegmentGuid, segmentNamePrefix);
                        int segmentId      = newSegment.Item1;
                        string segmentName = newSegment.Item2;
                        string lockKey     = String.Concat(_LockKeyPrefix, segmentId);

                        db.Execute.spRuntimeLockInsert(lockKey, _LockDuration, true);

                        Guid iMedidataUserGuid = Guid.NewGuid();
                        var user               = InsertUser(db, iMedidataSegmentGuid, iMedidataUserGuid);
                        int userId             = user.Item1;
                        string userName        = user.Item2;

                        InsertSegmentConfigurations(db, segmentId, userId);
                        CreateAndAssignCoderRoles(db, segmentId, userId);

                        string protocolName = String.Concat(segmentName, "Protocol");
                        string[] studyNames = BuildStudyNames(segmentName, _StudySuffixes);

                        var createdStudies = CreateTrackableObjects(db, iMedidataSegmentGuid, segmentId, segmentName,
                            protocolName, studyNames);

                        db.Execute.spObjectSegmentInsert(userId, _UserObjectTypeId, segmentId, false, true, false, 0,
                            DateTime.Now, DateTime.Now);

                        LicenseDictionaries(db, segmentId, _CoderDictionaries, DateTime.Now);

                        db.Execute.spRuntimeLockDelete(lockKey);

                        generatedUser.User = new MedidataUser
                        {
                            Id        = userId,
                            Username  = userName,
                            FirstName = Config.NewUserFirstName
                        };

                        generatedUser.Segment= new SegmentSetupData
                        {
                            SegmentId      = segmentId,
                            SegmentName    = segmentName,
                            Studies        = createdStudies
                        };
                    }
                });

            return generatedUser;
        }

        public static void AssignCoderRolesByIMedidataId(string segmentImedidataId, string userImedidataId)
        {
            if (String.IsNullOrWhiteSpace(segmentImedidataId)) throw new ArgumentNullException("segmentImedidataId");
            if (String.IsNullOrWhiteSpace(userImedidataId))    throw new ArgumentNullException("userImedidataId");

            using (var db = CoderDbFactory.Build())
            {
                var segmentId = GetSegmentIdByIMedidataId(db, segmentImedidataId);
                var userId    = GetUserIdByIMedidataId(db, userImedidataId);

                CreateAndAssignCoderRoles(db, segmentId, userId);
            }
        }

        private static void CreateAndAssignCoderRoles(ICoderDbConnection db, int segmentId, int userId)
        {
            if (ReferenceEquals(db, null)) throw new ArgumentNullException("db");

            CreateAndAssignGeneralRoles(db, _GeneralRoles, segmentId, userId);
            CreateAndAssignWorkflowRole(db, _WorkflowRoleName, segmentId, userId, _WorkflowActionIds);
        }

        private static Tuple<int,string> CreateNewSegment(ICoderDbConnection db, Guid iMedidataIdGuid, string segmentNamePrefix)
        {
            if (ReferenceEquals(db, null))                    throw new ArgumentNullException("db");
            if (String.IsNullOrWhiteSpace(segmentNamePrefix)) throw new ArgumentNullException("segmentNamePrefix");

            var iMedidataString = iMedidataIdGuid.ToString();
            var segmentSuffix   = iMedidataIdGuid.GetFirstSection();
            var segmentName     = String.Concat(segmentNamePrefix, segmentSuffix);
            int segmentId       = 0;

            var currentDate = DateTime.Now;

            var insertedSegment = db.Execute.spSegmentInsert(segmentName.ToUpper(), false, true, segmentName, false,
                iMedidataString, currentDate, currentDate, segmentId);

            segmentId = insertedSegment.SegmentID.GetValueOrDefault();

            if (segmentId == 0)
            {
                throw new InvalidOperationException(String.Format("Insert failed for segment {0}", segmentName));
            }

            var newSegment = Tuple.Create(segmentId, segmentName);

            return newSegment;
        }

        private static void InsertSegmentConfigurations(ICoderDbConnection db, int segmentId, int userId)
        {
            if (ReferenceEquals(db,null)) throw new ArgumentNullException("db");

            db.Execute.spConfigurationClone(segmentId, _SegmentConfigCloneId);

            var dictionaryCount = _CoderDictionaries.GetLength(0);
            var medicalDictionaryKeys = new string[dictionaryCount];

            for (int i = 0; i < dictionaryCount; i++)
            {
                medicalDictionaryKeys[i] = _CoderDictionaries[i, 0];
            }

            foreach (var key in medicalDictionaryKeys.Distinct())
            {
                db.Execute.spDictionarySegmentConfigurationInsert(segmentId, key, userId, _MaxSearchResults, true, false, DateTime.Now, DateTime.Now, 0);
            }
        }

        private static void CreateAndAssignGeneralRoles(ICoderDbConnection db, Tuple<int, string, int[]>[] generalRoles, int segmentId, int userId)
        {
            if (ReferenceEquals(db,null)) throw new ArgumentNullException("db");
            if (ReferenceEquals(generalRoles, null)) throw new ArgumentNullException("generalRoles");

            foreach (var generalRole in generalRoles)
            {
                int roleId = 0;
                var insertedRole = db.Execute.spRoleInsert(true, generalRole.Item2, generalRole.Item1, segmentId, roleId);
                roleId = insertedRole.RoleID.GetValueOrDefault();

                if (roleId == 0)
                {
                    throw new InvalidOperationException(String.Format("Insert failed for general role {0}", generalRole.Item2));
                }

                foreach (var actionId in generalRole.Item3)
                {
                    db.Execute.spRoleActionInsert(roleId, actionId, segmentId, 0);
                }

                db.Execute.spUserObjectRoleInsert(userId, "0", roleId, true, false, segmentId, 0);
            }
        }

        private static Tuple<int,string> InsertUser(ICoderDbConnection db, Guid iMedidataSegmentGuid, Guid iMedidataUserGuid)
        {
            if (ReferenceEquals(db, null)) throw new ArgumentNullException("db");

            var segmentSuffix   = iMedidataSegmentGuid.GetFirstSection();
            var imedidataUserId = iMedidataUserGuid.ToString();
            var lastName        = segmentSuffix;
            var login           = String.Concat(_FirstName, lastName);
            var email           = String.Format(_UserEmailTemplate, login);
            int userId          = 0;

            var insertedUser = db.Execute.spUserInsert(_FirstName, lastName, email, login, _TimeZone, imedidataUserId, _UserLocale, true, userId);
            userId = insertedUser.UserID.GetValueOrDefault();

            if (userId == 0)
            {
                throw new InvalidOperationException(String.Format("Insert failed for iMedidataUserId {0} on segmentSuffix {1}", imedidataUserId, segmentSuffix));
            }
            
            var newUser = Tuple.Create(userId, login);

            return newUser;
        }

        private static void CreateAndAssignWorkflowRole(ICoderDbConnection db, string roleName, int segmentId, int userId, IEnumerable<int> workflowRoleActionIds)
        {
            if (ReferenceEquals(db,null))                  throw new ArgumentNullException("db");
            if (String.IsNullOrWhiteSpace(roleName))       throw new ArgumentNullException("roleName");
            if (ReferenceEquals(workflowRoleActionIds,null)) throw new ArgumentNullException("workflowRoleActionIds");

            int workflowRoleId = 0;

            var insertedRole = db.Execute.spWorkflowRoleInsert(roleName, 1, true, workflowRoleId, DateTime.Now, DateTime.Now, segmentId);
            workflowRoleId = insertedRole.WorkflowRoleID.GetValueOrDefault();

            if (workflowRoleId == 0)
            {
                throw new InvalidOperationException(String.Format("Insert failed for workflow role {0}", roleName));
            }

            foreach (int actionId in workflowRoleActionIds)
            {
                db.Execute.spWorkflowRoleActionInsert(workflowRoleId, actionId, segmentId, 0, DateTime.Now, DateTime.Now);
            }

            db.Execute.spUserObjectWorkflowRoleInsert(userId, _AllStudiesWorkflow, workflowRoleId, true, false, 0, segmentId);
        }
        
        private static StudySetupData[] CreateTrackableObjects(ICoderDbConnection db, Guid iMedidataSegmentGuid, int segmentId, string segmentName, string protocolNumber, string[] studyNames)
        {
            if (ReferenceEquals(db, null))                 throw new ArgumentNullException("db");
            if (ReferenceEquals(studyNames, null))         throw new ArgumentNullException("studyNames");
            if (String.IsNullOrWhiteSpace(protocolNumber)) throw new ArgumentNullException("protocolNumber");
            if (String.IsNullOrWhiteSpace(segmentName))    throw new ArgumentNullException("segmentName");

            long trackableObjectId = 0;
            var currentDate        = DateTime.Now;
            string segmentIdString = iMedidataSegmentGuid.ToString();
            var studyCount         = studyNames.Length;
            var studies            = new StudySetupData[studyCount];
            var prodStudyName      = studyNames.FirstOrDefault(x => !x.EndsWith(_StudySuffixes[1]) && !x.EndsWith(_StudySuffixes[2]));

            var studyProjectId = InsertStudyProject(db, prodStudyName, segmentId);

            for (int i = 0; i < studyCount; i++)
            {
                var studyIdString = Guid.NewGuid().ToString();
                var studyName     = studyNames[i];
                var externalOid = studyName.Replace(" ", String.Empty).Replace("(", String.Empty).Replace(")", String.Empty);


                var trackableObjectDbResponse = db.Execute.spTrackableObjectInsert(trackableObjectId, 1, studyIdString, externalOid,
                    studyName, String.Empty, currentDate, currentDate, 0, 0, false, studyProjectId, segmentIdString, currentDate,
                    segmentId);

                if (ReferenceEquals(trackableObjectDbResponse, null))
                {
                    throw new InvalidOperationException(String.Format("Insert failed for trackable object id {0}",
                        studyIdString));
                }

                trackableObjectId = trackableObjectDbResponse.TrackableObjectID.GetValueOrDefault();

                if (trackableObjectId == 0)
                {
                    throw new InvalidOperationException(String.Format("Insert failed for trackable object id {0}",
                        studyIdString));
                }

                var insertedData = db.Execute.spGetStudyDataByProject(segmentName, studyName).Data.FirstOrDefault();

                if (ReferenceEquals(insertedData, null))
                {
                    throw new InvalidOperationException(String.Format("No trackable object found for segment {0} and study {1}", segmentName, studyName));
                }

                studies[i] = new StudySetupData
                {
                    StudyId        = trackableObjectId,
                    StudyName      = studyName,
                    StudyUuid      = insertedData.StudyOid,
                    ExternalOid    = externalOid,
                    ProtocolNumber = prodStudyName
                };
            }

            return studies;
        }
        
        private static int InsertStudyProject(ICoderDbConnection db, string studyName, int segmentId)
        {
            if (ReferenceEquals(db, null))            throw new ArgumentNullException("db");
            if (String.IsNullOrWhiteSpace(studyName)) throw new ArgumentNullException("studyName");

            long studyProjectId = 0;
            var currentDate = DateTime.Now;
            
            var dbResponse = db.Execute.spStudyProjectInsert(studyProjectId, studyName, String.Empty, segmentId,
                currentDate, currentDate);

            if (ReferenceEquals(dbResponse, null))
            {
                throw new InvalidOperationException(String.Format("Insert failed for study project for study {0}",
                    studyName));
            }

            studyProjectId = dbResponse.StudyProjectId.GetValueOrDefault();

            if (studyProjectId == 0)
            {
                throw new InvalidOperationException(String.Format("Insert failed for study project for study {0}",
                    studyName));
            }
            
            return (int)studyProjectId;
        }

        public static void LicenseDictionariesByIMedidataId(string segmentImedidataId, string[,] coderDictionaries, DateTime currentDate)
        {
            if (String.IsNullOrWhiteSpace(segmentImedidataId)) throw new ArgumentNullException("segmentImedidataId");
            if (ReferenceEquals(coderDictionaries, null)) throw new ArgumentNullException("coderDictionaries");

            using (var db = CoderDbFactory.Build())
            {
                var segmentId = GetSegmentIdByIMedidataId(db, segmentImedidataId);

                LicenseDictionaries(db, segmentId, coderDictionaries, currentDate);
            }
        }

        private static void LicenseDictionaries(ICoderDbConnection db, int segmentId, string[,] coderDictionaries, DateTime currentDate)
        {
            if (ReferenceEquals(db,null))                throw new ArgumentNullException("db");
            if (ReferenceEquals(coderDictionaries,null)) throw new ArgumentNullException("coderDictionaries");

            for (int i = 0; i < coderDictionaries.GetLength(0); i++)
            {
                db.Execute.spDictionaryLicenceInformationInsert(
                    false, 
                    _AdminUserId, 
                    _LicenseStart, 
                    _LicenseEnd,
                    _LicenseCode,
                    coderDictionaries[i, 1],
                    segmentId, 
                    coderDictionaries[i, 0], 
                    currentDate, 
                    currentDate, 
                    0);
            }
        }

        private static string[] BuildStudyNames(string segmentName, string[] studySuffixes)
        {
            if (ReferenceEquals(studySuffixes, null))   throw new ArgumentNullException("studySuffixes");
            if (String.IsNullOrWhiteSpace(segmentName)) throw new ArgumentNullException("segmentName");

            var studyCount = studySuffixes.Length;
            string[] studies = new string[studyCount];

            for (int i = 0; i < studyCount; i++)
            {
                studies[i] = String.Concat(segmentName, "_Study", studySuffixes[i]);
            }

            return studies;
        }

        private static int GetSegmentIdByIMedidataId(ICoderDbConnection db, string segmentImedidataId)
        {
            if (ReferenceEquals(db, null))                     throw new ArgumentNullException("db");
            if (String.IsNullOrWhiteSpace(segmentImedidataId)) throw new ArgumentNullException("segmentImedidataId");
            
            var segmentData = db.Execute.spSegmentGetByIMedidataId(segmentImedidataId).Data.FirstOrDefault();

            if (ReferenceEquals(segmentData, null))
            {
                throw new ArgumentException(String.Format("Cannot find segment data for {0}", segmentImedidataId));
            }

            var segmentId = segmentData.SegmentId.Value;

            return segmentId;
        }

        private static int GetUserIdByIMedidataId(ICoderDbConnection db, string userImedidataId)
        {
            if (ReferenceEquals(db, null))                  throw new ArgumentNullException("db");
            if (String.IsNullOrWhiteSpace(userImedidataId)) throw new ArgumentNullException("userImedidataId");
            
            var userData = db.Execute.spUserGetByIMedidataId(userImedidataId).Data.FirstOrDefault();

            if (ReferenceEquals(userData, null))
            {
                throw new ArgumentException(String.Format("Cannot find userData data for {0}", userImedidataId));
            }
            
            var userId = userData.UserID.Value;

            return userId;
        }
    }
}
