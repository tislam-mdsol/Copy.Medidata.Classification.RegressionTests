using System;
using Medidata;
using Medidata.Classification;
using Medidata.Messaging.Archon;
using Medidata.MessagingBridge;


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
