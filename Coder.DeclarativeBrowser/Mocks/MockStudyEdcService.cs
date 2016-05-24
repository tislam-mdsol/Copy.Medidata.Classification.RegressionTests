using System.Collections.Generic;
using System.Linq;
using Medidata;
using Medidata.Classification;

namespace Coder.DeclarativeBrowser.Mocks
{
    public class MockStudyEdcService : IStudyEdcService
    {
        private static readonly List<CodingDecision> _CodingDecisions;

        static MockStudyEdcService()
        {
            _CodingDecisions = new List<CodingDecision>();
        }

        public void OnGetCodingStatus(CodingStatusRequest request)
        {
            throw new System.NotImplementedException();
        }

        public void OnStartAutomatedCodingRequest(StartAutomatedCodingRequest request)
        {
            var codingRequests = _CodingDecisions.Where(cd => cd.CodingRequest.StudyOid == request.StudyUuid).Select(cd => cd.CodingRequest).ToArray();
            var result = new ReclassificationRequestSection
            {
                Request = request,
                Items = codingRequests
            };

            result.Broadcast(this);
        }

        public void OnCodingDecisions(ApprovedCodingDecisions decisions)
        {
            _CodingDecisions.AddRange(decisions.Items);
        }
    }
}