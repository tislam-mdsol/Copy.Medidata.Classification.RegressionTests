using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coder.DeclarativeBrowser.IMedidataApi.Models;
using Coder.DeclarativeBrowser.Models;
using Coder.DeclarativeBrowser.Models.ETEModels;
using Coder.DeclarativeBrowser.Models.UIDataModels;
using Newtonsoft.Json;
using Medidata.MAuth;
using Newtonsoft.Json.Linq;

namespace Coder.DeclarativeBrowser.IMedidataApi
{
    internal class IMedidataClient : IDisposable
    {
        private readonly Uri _IMedidataHost;
        private readonly HttpClient _HttpClient;
        private readonly JsonSerializerSettings _JsonSerializerSettings;

        private const string _ApiPathRoot           = @"/api/v2/";
        private const string _UsersPath             = @"users.json";
        private const string _StudiesPath           = @"studies/{0}.json";
        private const string _StudyGroupStudiesPath = @"study_groups/{0}/studies.json";
        private const string _StudyGroupPath        = @"study_groups/{0}.json";
        private const string _StudySitesPath        = @"studies/{0}/study_sites.json";
        private const string _ActivateUserPath      = @"created_users/{0}/activate.json";
        private const string _InviteUserPath        = @"studies/{0}/assign_or_invite.json";
        private const string _StudyGroupAppsPath    = @"study_groups/{0}/apps.json";
        private const string _RolesPath             = @"study_groups/{0}/apps/{1}/roles.json";

        internal IMedidataClient()
        {
            _IMedidataHost = new Uri(Config.IMedidataHost);

            _HttpClient = new HttpClient(
                new MAuthMessageHandler(
                    new MAuthMessageHandlerOptions
                    {
                        ClientAppUuid = new Guid(Config.IMedidataCoderAppId),
                        PrivateKey    = File.ReadAllText(Config.IMedidataPrivateKeyPath)
                    }
                )
            );

            _JsonSerializerSettings = new JsonSerializerSettings
            {
                NullValueHandling = NullValueHandling.Ignore
            };
        }

        private void GetStudyGroupAttributes(string studyGroupUuid)
        {
            if (String.IsNullOrWhiteSpace(studyGroupUuid)) throw new ArgumentNullException("studyGroupUuid");
            
            var requestPath = String.Format(_ApiPathRoot + _StudyGroupPath, studyGroupUuid);
            var requestUri  = new Uri(_IMedidataHost, requestPath);

            var responseStudies = GetResponseObject(
                () => _HttpClient.GetAsync(requestUri),
                JsonConvert.DeserializeObject<dynamic>);
        }

        internal void AddStudiesToIMedidata(SegmentSetupData segmentInput)
        {
            if (ReferenceEquals(segmentInput, null)) throw new ArgumentNullException("segmentInput");

            var studyGroupUuid = segmentInput.SegmentUuid;
            if (String.IsNullOrWhiteSpace(studyGroupUuid)) throw new ArgumentNullException("segmentInput.StudyGroupUUID");

            RetryPolicy.HttpRequest.Execute(() => GetStudyGroupAttributes(studyGroupUuid));

            var requestPath = String.Format(_ApiPathRoot + _StudyGroupStudiesPath, studyGroupUuid);
            var requestUri  = new Uri(_IMedidataHost, requestPath);

            foreach (var study in segmentInput.Studies)
            {
                var postData    = GetNewStudyPostBody(study);
                var postContent = new StringContent(postData, Encoding.UTF8, "application/json");

                var responseStudy = GetResponseObject(
                    () => _HttpClient.PostAsync(requestUri, postContent),GetStudyFromJson);

                study.StudyUuid = responseStudy.UUID;
            }
        }

        internal void CreateStudySite(SegmentSetupData segmentInput)
        {
            if (ReferenceEquals(segmentInput, null))    throw new ArgumentNullException("segmentInput");
            
            foreach (var study in segmentInput.Studies)
            {
                var studyUuid = study.StudyUuid;

                if (String.IsNullOrWhiteSpace(studyUuid))
                {
                    throw new ArgumentNullException("segmentInput.ProdStudy.StudyUuid");
                }
                
                var siteInputs = study.Sites;

                if (ReferenceEquals(siteInputs, null))
                {
                    throw new ArgumentNullException("segmentInput.ProdStudy.Sites");
                }

                foreach (var siteInput in siteInputs)
                {
                    var createStudySitePath     = String.Format(_ApiPathRoot + _StudySitesPath, studyUuid);
                    var createStudySiteUri      = new Uri(_IMedidataHost, createStudySitePath);
                    var createStudySiteData     = GetStudySitePostBody(siteInput);
                    var createStudySiteContent  = new StringContent(createStudySiteData, Encoding.UTF8,"application/json");

                    var createStudySiteResponse = GetResponseObject(
                        ()                      => _HttpClient.PostAsync(createStudySiteUri, createStudySiteContent),
                        GetStudySiteFromJson);
                }
            }
        }

        internal MedidataUser CreateStudyOwner(SegmentSetupData segmentInput, string userName, bool inviteNewUserWhenCreated = true)
        {
            if (ReferenceEquals(segmentInput, null))       throw new ArgumentNullException("segmentInput");
            if (String.IsNullOrWhiteSpace(userName))       throw new ArgumentNullException("userName");

            var studyGroupUuid = segmentInput.SegmentUuid;
            if (String.IsNullOrWhiteSpace(studyGroupUuid)) throw new ArgumentNullException("segmentInput.StudyGroupUUID");
            
            var studyGroupName = segmentInput.SegmentName;
            if (String.IsNullOrWhiteSpace(studyGroupName)) throw new ArgumentNullException("segmentInput.SegmentName");

            var studyInputs = segmentInput.Studies;
            if (ReferenceEquals(studyInputs, null)) throw new ArgumentNullException("segmentInput.Studies");
            
            var createUserRequestPath = String.Concat(_ApiPathRoot, _UsersPath);
            var createUserUri         = new Uri(_IMedidataHost, createUserRequestPath);
            var createUserData        = GetNewUserPostBody(userName);
            var createUserContent     = new StringContent(createUserData, Encoding.UTF8, "application/json");

            var responseUser           = GetResponseObject(
                ()=> _HttpClient.PostAsync(createUserUri, createUserContent),
                GetUserFromJson);
            
            var newUser = new MedidataUser
            {
                Username   = responseUser.email,
                Password   = Config.ActiveUserPassword,
                Email      = responseUser.email,
                MedidataId = responseUser.uuid,
                FirstName  = responseUser.first_name
            };

            var activateUserPath     = String.Format(String.Concat(_ApiPathRoot, _ActivateUserPath), responseUser.activation_code);
            var activateUserUri      = new Uri(_IMedidataHost, activateUserPath);
            var activateUserData     = GetActivateUserData();
            var activateUserContent  = new StringContent(activateUserData, Encoding.UTF8, "application/json");

            var activateUserResponse = GetResponseObject(
                ()                   => _HttpClient.PutAsync(activateUserUri, activateUserContent),
                GetUserFromJson);

            if (inviteNewUserWhenCreated)
            {
                foreach (var studyInput in studyInputs)
                {
                    var studyUuid = studyInput.StudyUuid;
                    if (String.IsNullOrWhiteSpace(studyUuid))
                    {
                        throw new ArgumentNullException("segmentInput.ProdStudy.StudyUuid");
                    }

                    var inviteUserPath     = String.Format(String.Concat(_ApiPathRoot, _InviteUserPath), studyUuid);
                    var inviteUserUri      = new Uri(_IMedidataHost, inviteUserPath);
                    var inviteUserData     = GetInviteUserPostBody(newUser.Email, studyGroupUuid, segmentInput.StudyGroupApps);
                    var inviteUserContent  = new StringContent(inviteUserData, Encoding.UTF8, "application/json");

                    var inviteUserResponse = GetResponseObject(
                        ()                 => _HttpClient.PostAsync(inviteUserUri, inviteUserContent),
                        GetInviteFromJson);
                }
            }

            return newUser;
        }

        internal void UpdateStudyName(StudySetupData currentStudy, string newName)
        {
            if (ReferenceEquals(currentStudy, null))               throw new ArgumentNullException("currentStudy");
            if (String.IsNullOrWhiteSpace(currentStudy.StudyUuid)) throw new ArgumentNullException("currentStudy.StudyUuid");
            if (String.IsNullOrWhiteSpace(newName))                throw new ArgumentNullException("newName");

            currentStudy.StudyName = newName;

            var requestPath   = String.Format(_ApiPathRoot + _StudiesPath, currentStudy.StudyUuid);
            var requestUri    = new Uri(_IMedidataHost, requestPath);

            var postData      = GetNewStudyPostBody(currentStudy);
            var postContent   = new StringContent(postData, Encoding.UTF8, "application/json");

            var responseStudy = GetResponseObject(
                ()            => _HttpClient.PutAsync(requestUri, postContent), GetStudyFromJson);
        }

        private string GetNewStudyPostBody(StudySetupData studyInput)
        {
            if (ReferenceEquals(studyInput, null)) throw new ArgumentNullException("studyInput");
            
            var postObject = new IMedidataAPIStudy
            {
                name          = studyInput.StudyName,
                oid           = studyInput.ExternalOid,
                UUID =  studyInput.StudyUuid,
                status = "active",
                is_production = studyInput.IsProduction,
                phase         = "None",
                indication    = "001.9: Cholera, Unspecified"
            };

            var postBody = JsonConvert.SerializeObject(postObject);

            return postBody;
        }

        private string GetNewUserPostBody(string userName)
        {
            if (String.IsNullOrWhiteSpace(userName)) throw new ArgumentNullException("userName");

            var postObject = new IMedidataAPIUser
            {
                login             = Guid.NewGuid().GetFirstSection(),
                email             = userName.CreateUserEmail(),
                password          = Config.NewUserPassword,
                locale            = Config.NewUserLocale,
                time_zone         = Config.NewUserTimeZone,
                first_name        = Config.NewUserFirstName,
                last_name         = Config.NewUserLastName,
                telephone         = Config.NewUserTelephone,
                activation_status = IMedidataAPIUser.ActiveStatus
            };

            var postBody = JsonConvert.SerializeObject(postObject, _JsonSerializerSettings);

            return postBody;
        }

        private string GetActivateUserData()
        {
            var postObject = new IMedidataAPIActivateUser
            {
                password = Config.ActiveUserPassword,
                user_security_question = new IMedidataAPISecurityQuestion
                {
                    security_question_id = "3",
                    answer               = "foot"
                },
                eula_agreed_to = true
            };

            var postBody = JsonConvert.SerializeObject(postObject, _JsonSerializerSettings);

            return postBody;
        }
        
        private string GetStudySitePostBody(SiteSetupData siteInput)
        {
            if (ReferenceEquals(siteInput, null))                throw new ArgumentNullException("siteInput");
            if (String.IsNullOrWhiteSpace(siteInput.SiteName))   throw new ArgumentNullException("siteInput.SiteName");
            if (String.IsNullOrWhiteSpace(siteInput.SiteNumber)) throw new ArgumentNullException("siteInput.SiteNumber");

            var postObject = new IMedidataAPIStudySite
            {
                name   = siteInput.SiteName,
                number = siteInput.SiteNumber
            };

            var postBody = JsonConvert.SerializeObject(postObject, _JsonSerializerSettings);

            return postBody;
        }

        private string GetInviteUserPostBody(string userEmail, string studyGroupUuid, IEnumerable<MedidataApp> appsToAssign)
        {
            if (String.IsNullOrWhiteSpace(userEmail))      throw new ArgumentNullException("userEmail");
            if (String.IsNullOrWhiteSpace(studyGroupUuid)) throw new ArgumentNullException("studyGroupUuid");
            if (ReferenceEquals(appsToAssign, null))       throw new ArgumentNullException("apps");

            appsToAssign = appsToAssign.ToArray();

            var appsPath = String.Format(String.Concat(_ApiPathRoot, _StudyGroupAppsPath), studyGroupUuid);
            var appsUri  = new Uri(_IMedidataHost, appsPath);

            var appsResponse = GetResponseObject(
                () => _HttpClient.GetAsync(appsUri),
                GetAppsFromJson).ToArray();

            foreach (var app in appsResponse)
            {
                if (!app.role_required)
                {
                    continue;
                }

                var appRolesPath = String.Format(String.Concat(_ApiPathRoot, _RolesPath), studyGroupUuid, app.uuid);
                var appRolesUri  = new Uri(_IMedidataHost, appRolesPath);

                var appRolesResponse = GetResponseObject(() => _HttpClient.GetAsync(appRolesUri), GetRolesFromJson).ToArray();

                var matchingAppInput = appsToAssign.FirstOrDefault(
                    x => x.Name.Contains(app.name, StringComparison.OrdinalIgnoreCase)
                    && !ReferenceEquals(x.Roles, null));
                
                if (ReferenceEquals(matchingAppInput, null))
                {
                    throw new ArgumentException(String.Format("No matching app input provided for app {0}", app.name));
                }

                var rolesToAssign = new List<IMedidataAPIRole>();

                foreach (var role in matchingAppInput.Roles)
                {
                    var appRoles = appRolesResponse.Where(x => x.name.Equals(role, StringComparison.OrdinalIgnoreCase));

                    rolesToAssign.AddRange(appRoles);
                }

                if (!rolesToAssign.Any())
                {
                    throw new ArgumentException(String.Format("No matching roles provided for app {0}", app.name));
                }

                app.roles = rolesToAssign;
            }

            var postObject = new IMedidataAPIInvite
            {
                as_owner = true,
                email    = userEmail,
                apps     = appsResponse
            };

            var postBody = JsonConvert.SerializeObject(postObject, _JsonSerializerSettings);

            return postBody;
        }
        
        private T GetResponseObject<T>(Func<Task<HttpResponseMessage>> httpResponse, Func<string, T> parseJson)
        {
            if (ReferenceEquals(httpResponse, null)) throw new ArgumentNullException("postAction");
            if (ReferenceEquals(parseJson, null))    throw new ArgumentNullException("parseJson");

            var response     = httpResponse().Result;
            var responseBody = response.Content.ReadAsStringAsync().Result;

            if (!response.IsSuccessStatusCode)
            {
                throw new HttpRequestException(String.Format("Http Request Failed. {0}; {1}", responseBody, response));
            }

            var responseObject = parseJson(responseBody);

            return responseObject;
        }

        private IMedidataAPIStudy GetStudyFromJson(string json)
        {
            if (String.IsNullOrWhiteSpace(json)) throw new ArgumentNullException("json");

            var jsonObject  = JObject.Parse(json);
            var jsonToParse = jsonObject.GetValue("study");

            var responseObject = JsonConvert.DeserializeObject<IMedidataAPIStudy>(jsonToParse.ToString());
            
            return responseObject;
        }

        private IMedidataAPIUser GetUserFromJson(string json)
        {
            if (String.IsNullOrWhiteSpace(json)) throw new ArgumentNullException("json");

            var jsonObject  = JObject.Parse(json);
            var jsonToParse = jsonObject.GetValue("user");

            var responseObject = JsonConvert.DeserializeObject<IMedidataAPIUser>(jsonToParse.ToString());

            return responseObject;
        }

        private IMedidataAPIStudySite GetStudySiteFromJson(string json)
        {
            if (String.IsNullOrWhiteSpace(json)) throw new ArgumentNullException("json");

            var jsonObject  = JObject.Parse(json);
            var jsonToParse = jsonObject.GetValue("study_site");

            var responseObject = JsonConvert.DeserializeObject<IMedidataAPIStudySite>(jsonToParse.ToString());

            return responseObject;
        }

        private IMedidataAPIInvite GetInviteFromJson(string json)
        {
            if (String.IsNullOrWhiteSpace(json)) throw new ArgumentNullException("json");

            var responseObject = JsonConvert.DeserializeObject<IMedidataAPIInvite>(json);

            return responseObject;
        }

        private IEnumerable<IMedidataAPIApp> GetAppsFromJson(string json)
        {
            if (String.IsNullOrWhiteSpace(json)) throw new ArgumentNullException("json");

            var jsonObject  = JObject.Parse(json);
            var jsonToParse = jsonObject.GetValue("apps");

            var responseObject = JsonConvert.DeserializeObject<IEnumerable<IMedidataAPIApp>>(jsonToParse.ToString());

            return responseObject;
        }

        private IEnumerable<IMedidataAPIRole> GetRolesFromJson(string json)
        {
            if (String.IsNullOrWhiteSpace(json)) throw new ArgumentNullException("json");

            var jsonObject = JObject.Parse(json);
            var jsonToParse = jsonObject.GetValue("roles");

            var responseObject = JsonConvert.DeserializeObject<IEnumerable<IMedidataAPIRole>>(jsonToParse.ToString());

            return responseObject;
        }

        public void Dispose()
        {
            _HttpClient.Dispose();
        }
    }
}