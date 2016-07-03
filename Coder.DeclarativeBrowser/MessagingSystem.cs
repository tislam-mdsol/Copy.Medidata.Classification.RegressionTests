using System;
using Medidata;
using Medidata.Hosting;
using Medidata.Messaging.AWS;
using Medidata.MessagingBridge;

namespace Coder.DeclarativeBrowser
{
    public class MessagingSystem : IMessageHostingInitializer
    {
        private static Boolean _IsInitialized;
        private static Object _Sync = new Object();

        public static void Start()
        {
            var messagingSystem = new MessagingSystem();
            messagingSystem.Initialize();
        }

        public void Initialize()
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
                FactoryInitializationHelper.SetEntryAssemblyFromType<CoderDeclarativeBrowser>();
                var messageHostInitializer = Factory.Build<IMessageHostingInitializer>();
                messageHostInitializer.Initialize();
            }
        }
    }
}