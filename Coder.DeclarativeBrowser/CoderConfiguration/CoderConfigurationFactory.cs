using System;
using System.Collections.Generic;

//TODO: Move to separate project to allow API, integration, browser, etc. testing to use
namespace Coder.DeclarativeBrowser.CoderConfiguration
{
    internal static class CoderConfigurationFactory
    {
        private static readonly CoderConfiguration _Approval = new CoderConfiguration
        {
            DefaultLocale                      = "eng",
            CodingTaskPageSize                 = "10",
            ForcePrimaryPathSelection          = "Yes",
            SearchLimitReclassificationResult  = "25",
            SynonymCreationPolicyFlag          = "1",
            BypassReconsiderUponReclassifyFlag = "No",
            IsAutoAddSynonym                   = "False",
            IsAutoApproval                     = "False",
            MaxNumberofSearchResults           = "70",
            IsTermAutoApproval                 = "False",
            IsTermApprovalRequired             = "False"
        };

        private static readonly CoderConfiguration _Basic = new CoderConfiguration
        {
            DefaultLocale                      = "eng",
            CodingTaskPageSize                 = "10",
            ForcePrimaryPathSelection          = "Yes",
            SearchLimitReclassificationResult  = "25",
            SynonymCreationPolicyFlag          = "1",
            BypassReconsiderUponReclassifyFlag = "Yes",
            IsAutoAddSynonym                   = "True",
            IsAutoApproval                     = "False",
            MaxNumberofSearchResults           = "70",
            IsTermAutoApproval                 = "True",
            IsTermApprovalRequired             = "True"
        };

        private static readonly CoderConfiguration _CompletedReconsider = new CoderConfiguration
        {
            DefaultLocale                      = "eng",
            CodingTaskPageSize                 = "10",
            ForcePrimaryPathSelection          = "Yes",
            SearchLimitReclassificationResult  = "25",
            SynonymCreationPolicyFlag          = "1",
            BypassReconsiderUponReclassifyFlag = "Yes",
            IsAutoAddSynonym                   = "True",
            IsAutoApproval                     = "True",
            MaxNumberofSearchResults           = "70",
            IsTermAutoApproval                 = "True",
            IsTermApprovalRequired             = "True"
        };

        private static readonly CoderConfiguration _NoApproval = new CoderConfiguration
        {
            DefaultLocale                      = "eng",
            CodingTaskPageSize                 = "10",
            ForcePrimaryPathSelection          = "Yes",
            SearchLimitReclassificationResult  = "25",
            SynonymCreationPolicyFlag          = "1",
            BypassReconsiderUponReclassifyFlag = "Yes",
            IsAutoAddSynonym                   = "True",
            IsAutoApproval                     = "False",
            MaxNumberofSearchResults           = "70",
            IsTermAutoApproval                 = "True",
            IsTermApprovalRequired             = "False"
        };

        private static readonly CoderConfiguration _NoEnforcedPrimaryPath = new CoderConfiguration
        {
            DefaultLocale                      = "eng",
            CodingTaskPageSize                 = "10",
            ForcePrimaryPathSelection          = "No",
            SearchLimitReclassificationResult  = "25",
            SynonymCreationPolicyFlag          = "1",
            BypassReconsiderUponReclassifyFlag = "Yes",
            IsAutoAddSynonym                   = "True",
            IsAutoApproval                     = "False",
            MaxNumberofSearchResults           = "70",
            IsTermAutoApproval                 = "True",
            IsTermApprovalRequired             = "True"
        };

        private static readonly CoderConfiguration _ReconsiderBypassOff = new CoderConfiguration
        {
            DefaultLocale                      = "eng",
            CodingTaskPageSize                 = "10",
            ForcePrimaryPathSelection          = "Yes",
            SearchLimitReclassificationResult  = "25",
            SynonymCreationPolicyFlag          = "1",
            BypassReconsiderUponReclassifyFlag = "No",
            IsAutoAddSynonym                   = "True",
            IsAutoApproval                     = "False",
            MaxNumberofSearchResults           = "70",
            IsTermAutoApproval                 = "True",
            IsTermApprovalRequired             = "True"
        };

        private static readonly CoderConfiguration _ReconsiderBypassOn = new CoderConfiguration
        {
            DefaultLocale                      = "eng",
            CodingTaskPageSize                 = "10",
            ForcePrimaryPathSelection          = "Yes",
            SearchLimitReclassificationResult  = "25",
            SynonymCreationPolicyFlag          = "1",
            BypassReconsiderUponReclassifyFlag = "Yes",
            IsAutoAddSynonym                   = "True",
            IsAutoApproval                     = "False",
            MaxNumberofSearchResults           = "70",
            IsTermAutoApproval                 = "True",
            IsTermApprovalRequired             = "True"
        };

        private static readonly CoderConfiguration _Reconsider = new CoderConfiguration
        {
            DefaultLocale                      = "eng",
            CodingTaskPageSize                 = "10",
            ForcePrimaryPathSelection          = "Yes",
            SearchLimitReclassificationResult  = "25",
            SynonymCreationPolicyFlag          = "1",
            BypassReconsiderUponReclassifyFlag = "No",
            IsAutoAddSynonym                   = "True",
            IsAutoApproval                     = "False",
            MaxNumberofSearchResults           = "70",
            IsTermAutoApproval                 = "True",
            IsTermApprovalRequired             = "True"
        };

        private static readonly CoderConfiguration _SynonymsNeedApproval = new CoderConfiguration
        {
            DefaultLocale                      = "eng",
            CodingTaskPageSize                 = "10",
            ForcePrimaryPathSelection          = "Yes",
            SearchLimitReclassificationResult  = "25",
            SynonymCreationPolicyFlag          = "2",
            BypassReconsiderUponReclassifyFlag = "No",
            IsAutoAddSynonym                   = "True",
            IsAutoApproval                     = "False",
            MaxNumberofSearchResults           = "70",
            IsTermAutoApproval                 = "True",
            IsTermApprovalRequired             = "False"
        };

        private static readonly CoderConfiguration _AutoCodeSynonymsNeedApproval = new CoderConfiguration
        {
            DefaultLocale                      = "eng",
            CodingTaskPageSize                 = "10",
            ForcePrimaryPathSelection          = "Yes",
            SearchLimitReclassificationResult  = "25",
            SynonymCreationPolicyFlag          = "2",
            BypassReconsiderUponReclassifyFlag = "No",
            IsAutoAddSynonym                   = "True",
            IsAutoApproval                     = "False",
            MaxNumberofSearchResults           = "70",
            IsTermAutoApproval                 = "True",
            IsTermApprovalRequired             = "True"
        };

        private static readonly CoderConfiguration _WaitingApproval = new CoderConfiguration
        {
            DefaultLocale                      = "eng",
            CodingTaskPageSize                 = "10",
            ForcePrimaryPathSelection          = "Yes",
            SearchLimitReclassificationResult  = "25",
            SynonymCreationPolicyFlag          = "1",
            BypassReconsiderUponReclassifyFlag = "No",
            IsAutoAddSynonym                   = "False",
            IsAutoApproval                     = "False",
            MaxNumberofSearchResults           = "70",
            IsTermAutoApproval                 = "False",
            IsTermApprovalRequired             = "True"
        };

        internal static CoderConfiguration Build(string configurationType)
        {
            if (String.IsNullOrWhiteSpace(configurationType)) throw new ArgumentNullException("configurationType"); 

            if (configurationType.Equals("Approval"                        , StringComparison.OrdinalIgnoreCase))    return _Approval;
            if (configurationType.Equals("Basic"                           , StringComparison.OrdinalIgnoreCase))    return _Basic;
            if (configurationType.Equals("Completed Reconsider"            , StringComparison.OrdinalIgnoreCase))    return _CompletedReconsider;
            if (configurationType.Equals("No Approval"                     , StringComparison.OrdinalIgnoreCase))    return _NoApproval;
            if (configurationType.Equals("No Enforced Primary Path"        , StringComparison.OrdinalIgnoreCase))    return _NoEnforcedPrimaryPath;
            if (configurationType.Equals("Reconsider Bypass Off"           , StringComparison.OrdinalIgnoreCase))    return _ReconsiderBypassOff;
            if (configurationType.Equals("Reconsider Bypass On"            , StringComparison.OrdinalIgnoreCase))    return _ReconsiderBypassOn;
            if (configurationType.Equals("Reconsider"                      , StringComparison.OrdinalIgnoreCase))    return _Reconsider;
            if (configurationType.Equals("Synonyms Need Approval"          , StringComparison.OrdinalIgnoreCase))    return _SynonymsNeedApproval;
            if (configurationType.Equals("Auto Code Synonyms Need Approval", StringComparison.OrdinalIgnoreCase))    return _AutoCodeSynonymsNeedApproval;
            if (configurationType.Equals("Waiting Approval"                , StringComparison.OrdinalIgnoreCase))    return _WaitingApproval;

            throw new KeyNotFoundException("configurationType");
        }

        internal static void SetTestContext(
            CoderConfiguration coderConfiguration, 
            string segment, 
            string dictionary,
            string version)
        {
            if (ReferenceEquals(coderConfiguration, null)) throw new ArgumentNullException("coderConfiguration");
            if (String.IsNullOrWhiteSpace(segment))        throw new ArgumentNullException("segment");
            if (String.IsNullOrWhiteSpace(dictionary))     throw new ArgumentNullException("dictionary");
            if (String.IsNullOrWhiteSpace(version))        throw new ArgumentNullException("version");

            CoderDatabaseAccess.UpdateCoderConfiguration(
                segment                           : segment,
                dictionary                        : dictionary,
                version                           : version,
                defaultLocale                     : coderConfiguration.DefaultLocale,
                codingTaskPageSize                : coderConfiguration.CodingTaskPageSize,
                forcePrimaryPathSelection         : coderConfiguration.ForcePrimaryPathSelection,
                searchLimitReclassificationResult : coderConfiguration.SearchLimitReclassificationResult,
                synonymCreationPolicyFlag         : coderConfiguration.SynonymCreationPolicyFlag,
                bypassReconsiderUponReclassifyFlag: coderConfiguration.BypassReconsiderUponReclassifyFlag,
                isAutoAddSynonym                  : coderConfiguration.IsAutoAddSynonym,
                isAutoApproval                    : coderConfiguration.IsAutoApproval,
                maxNumberofSearchResults          : coderConfiguration.MaxNumberofSearchResults);
        }
         
    }
}
