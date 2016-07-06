using System;
using Medidata;
using Medidata.Hosting;
using Medidata.Messaging.AWS;
using Medidata.MessagingBridge;

namespace Coder.DeclarativeBrowser
{
    public class MessagingSystem
    {
        public static void Start()
        {
            FactoryInitializationHelper.SetEntryAssemblyFromType<CoderDeclarativeBrowser>();
            var messageHostInitializer = Factory.Build<IMessageHostingInitializer>();
            messageHostInitializer.Initialize();
        }
    }
}