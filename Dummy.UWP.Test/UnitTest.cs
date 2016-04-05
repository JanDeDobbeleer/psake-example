using System;
using Microsoft.VisualStudio.TestPlatform.UnitTestFramework;

namespace Dummy.UWP.Test
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void FalseShouldBeFalse()
        {
            Assert.IsFalse(false);
        }

        [TestMethod]
        public void TrueShouldBeTrue()
        {
            Assert.IsTrue(true);
        }
    }
}
