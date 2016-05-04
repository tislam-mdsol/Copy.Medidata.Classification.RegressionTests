using Medidata;
using Medidata.Classification;


namespace Coder.DeclarativeBrowser.ClassificationClient
{
    class ClassificationClient
    {
        public void BroadcastingAutomatedCodingRequestSection(AutomatedCodingRequestSection data)
        {
            data.Broadcast();
        }
    }
}
