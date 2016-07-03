using System;
using Medidata;
using Medidata.Classification;

namespace Coder.DeclarativeBrowser.ClassificationClient
{
    internal class ClassificationClient
    {
        internal void BroadcastingAutomatedCodingRequestSection(AutomatedCodingRequestSection data)
        {
            data.Broadcast(this);
        }
    }
}
