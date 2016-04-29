using System;

namespace Coder.DeclarativeBrowser.CoderConfiguration
{
    public class CoderTestContext
    {
        public CoderConfiguration GetCoderConfiguration(string configurationType)
        {
            if (String.IsNullOrWhiteSpace(configurationType)) throw new ArgumentNullException("configurationType");

            var coderConfiguration = CoderConfigurationFactory.Build(configurationType);

            return coderConfiguration;
        }

        public void Set(
            CoderConfiguration coderConfiguration, 
            string segment, 
            string dictionary,
            string version)
        {
            if (ReferenceEquals(coderConfiguration, null))    throw new ArgumentNullException("coderConfiguration");
            if (String.IsNullOrWhiteSpace(segment))           throw new ArgumentNullException("segment");
            if (String.IsNullOrWhiteSpace(dictionary))        throw new ArgumentNullException("dictionary");
            if (String.IsNullOrWhiteSpace(version))           throw new ArgumentNullException("version");

            CoderConfigurationFactory.SetTestContext(
                coderConfiguration   : coderConfiguration,
                segment              : segment,
                dictionary           : dictionary,
                version              : version);
        }
    }
}
