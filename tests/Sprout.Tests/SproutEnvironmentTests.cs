using Sprout.Core;

namespace Sprout.Tests;

public class SproutEnvironmentTests
{
    [Theory]
    [InlineData("dev")]
    [InlineData("staging")]
    [InlineData("production")]
    [InlineData("STAGING")]
    public void Get_finds_each_environment_by_name(string name) =>
        Assert.Equal(name.ToLowerInvariant(), SproutEnvironments.Get(name).Name);

    [Theory]
    [InlineData(null)]
    [InlineData("")]
    [InlineData("prod")]
    public void Get_throws_for_unknown_names_instead_of_falling_back(string? name) =>
        Assert.Throws<ArgumentException>(() => SproutEnvironments.Get(name));

    [Fact]
    public void Staging_and_production_point_at_different_backends() =>
        Assert.NotEqual(SproutEnvironments.Staging.ApiBaseUrl, SproutEnvironments.Production.ApiBaseUrl);

    [Fact]
    public void Every_environment_has_a_unique_name_and_url() =>
        Assert.Equal(SproutEnvironments.All.Count, SproutEnvironments.All.Select(e => e.ApiBaseUrl).Distinct().Count());

    [Fact]
    public void Every_url_is_https() =>
        Assert.All(SproutEnvironments.All, e => Assert.StartsWith("https://", e.ApiBaseUrl));
}
