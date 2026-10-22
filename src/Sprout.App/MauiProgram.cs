using System.Reflection;
using Microsoft.Extensions.Logging;
using Sprout.Core;

namespace Sprout.App;

public static class MauiProgram
{
	public static MauiApp CreateMauiApp()
	{
		var builder = MauiApp.CreateBuilder();
		builder
			.UseMauiApp<App>()
			.ConfigureFonts(fonts =>
			{
				fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
				fonts.AddFont("OpenSans-Semibold.ttf", "OpenSansSemibold");
			});

		// The environment is baked in at build time (-p:SproutEnv=...), never read from user-editable settings.
		var envName = typeof(App).Assembly.GetCustomAttributes<AssemblyMetadataAttribute>()
			.First(a => a.Key == "SproutEnv").Value;
		builder.Services.AddSingleton(SproutEnvironments.Get(envName));

#if DEBUG
		builder.Logging.AddDebug();
#endif

		return builder.Build();
	}
}
