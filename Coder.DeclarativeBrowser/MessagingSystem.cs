using System;
using Medidata;
using Medidata.Messaging.Archon;
using Medidata.MessagingBridge;

namespace Coder.DeclarativeBrowser
{
    public static class MessagingSystem
    {
        private static Boolean _IsInitialized;
        private static Object _Sync = new Object();

        public static void Initialize()
        {
            if (_IsInitialized)
            {
                return;
            }

            lock (_Sync)
            {
                if (_IsInitialized)
                {
                    return;
                    
                }

                _IsInitialized = true;

                Factory.Register<IMessagePublisher>(() => new ArchonCommunicationHubAdapter());
                var adapter = new ArchonCommunicationHubAdapter();
                adapter.Init();
            }

        }
    }
}