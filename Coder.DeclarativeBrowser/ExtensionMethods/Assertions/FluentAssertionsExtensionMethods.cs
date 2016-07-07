using FluentAssertions.Execution;
using FluentAssertions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Coder.DeclarativeBrowser.ExtensionMethods.Assertions
{
    public static class FluentAssertionsExtensionMethods
    {
        public static void ShouldNotBeEquivalentTo(this object actual, object expected, string because = "", params object[] args)
        {
            bool hasMismatches = false;
            using (var scope = new AssertionScope())
            {
                actual.ShouldBeEquivalentTo(expected);
                hasMismatches = scope.Discard().Any();
            }

            Execute.Assertion.ForCondition(hasMismatches).BecauseOf(because, args).FailWith("Expected object not to be equivalent to actual, but they are");
        }

    }
}
