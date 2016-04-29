using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using NUnit.Framework.Constraints;

namespace Coder.DeclarativeBrowser.Helpers
{
    public static class TaskAttempt
    {
        public static void TryAction(Action action, TimeSpan timeOut)
        {
            if (ReferenceEquals(action, null))  throw new ArgumentNullException("action");
            
            var tokenSource = new CancellationTokenSource();
            CancellationToken token = tokenSource.Token;

            var task = Task.Factory.StartNew(action, token);

            if (!task.Wait(Convert.ToInt32(timeOut.TotalMilliseconds), token))
                Console.WriteLine(String.Format("The task {0} timed out", action.Method.Name));
        }
    }
}
