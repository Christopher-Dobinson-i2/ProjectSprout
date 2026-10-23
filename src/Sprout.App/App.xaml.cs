using Microsoft.Extensions.DependencyInjection;

namespace Sprout.App;

public partial class App : Application
{
	public App()
	{
		InitializeComponent();
	}

	protected override Window CreateWindow(IActivationState? activationState)
	{
		var window = new Window(new AppShell());
#if MACCATALYST
		// Demo build on a Mac: a fixed, phone-shaped window. Mac Catalyst draws the UI at 77% by default
		// (measured: asking for 393 x 852 gave a 303 x 657 window), so ask for the size divided by 0.77.
		// Target is an iPhone Pro Max screen, 430 x 932.
		const double catalystScale = 0.77;
		var width = Math.Round(430 / catalystScale);
		var height = Math.Round(932 / catalystScale);
		window.Width = window.MinimumWidth = window.MaximumWidth = width;
		window.Height = window.MinimumHeight = window.MaximumHeight = height;
#endif
		return window;
	}
}