namespace Sprout.Core;

/// <summary>One deployment environment. Defined here, in code, so every build of an environment agrees.</summary>
public sealed record SproutEnvironment(string Name, string ApiBaseUrl);

public static class SproutEnvironments
{
    // The hosts below use the reserved .invalid TLD: they are placeholders and cannot resolve.
    // Replace each with the real backend URL when that environment exists (issue #12).
    public static readonly SproutEnvironment Dev = new("dev", "https://api.dev.sprout.invalid");
    public static readonly SproutEnvironment Staging = new("staging", "https://api.staging.sprout.invalid");
    public static readonly SproutEnvironment Production = new("production", "https://api.sprout.invalid");

    public static IReadOnlyList<SproutEnvironment> All { get; } = [Dev, Staging, Production];

    /// <summary>Looks an environment up by name. An unknown name throws: a build must never silently fall back.</summary>
    public static SproutEnvironment Get(string? name) =>
        All.FirstOrDefault(e => string.Equals(e.Name, name, StringComparison.OrdinalIgnoreCase))
        ?? throw new ArgumentException($"Unknown environment '{name}'. Expected one of: {string.Join(", ", All.Select(e => e.Name))}.", nameof(name));
}
