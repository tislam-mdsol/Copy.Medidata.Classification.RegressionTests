using System;
using Coypu;

namespace Coder.DeclarativeBrowser.ExtensionMethods
{
    internal static class ElementScopeExtensionMethods
    {
        private static readonly Options _DefaultOptions = new Options
        {
            RetryInterval       = TimeSpan.FromSeconds(1), 
            Timeout             = TimeSpan.FromSeconds(60)
        };

        internal static ElementScope FillInWithOptions(
            this ElementScope sourceElement,
            DriverScope driverScope,
            string value)
        {
            if (ReferenceEquals(sourceElement, null))   throw new ArgumentNullException("sourceElement");
            if (ReferenceEquals(driverScope, null))     throw new ArgumentNullException("driverScope"); 
            if (String.IsNullOrEmpty(value))            throw new ArgumentNullException("value");

            driverScope.TryUntil(
                () => sourceElement.FillInWith(value),
                () => !sourceElement.Value.Equals(String.Empty),
                _DefaultOptions.RetryInterval,
                _DefaultOptions);

            return sourceElement;
        }
    }
}
