using Sprout.Core;

namespace Sprout.Tests;

public class GreetingTests
{
    [Theory]
    [InlineData(null, "Hello, Sprout!")]
    [InlineData("", "Hello, Sprout!")]
    [InlineData("  ", "Hello, Sprout!")]
    [InlineData(" Ada ", "Hello, WRONG!")]
    public void For_returns_expected_greeting(string? name, string expected) =>
        Assert.Equal(expected, Greeting.For(name));
}
