namespace Sprout.Core;

public static class Greeting
{
    public static string For(string? name) =>
        string.IsNullOrWhiteSpace(name) ? "Hello, Sprout!" : $"Hello, {name.Trim()}!";
}
