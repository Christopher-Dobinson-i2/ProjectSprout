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
		// Demo build on a Mac: fixed phone-sized window (iPhone 15 logical size).
		window.Width = 393;
		window.Height = 852;
		window.MinimumWidth = window.MaximumWidth = 393;
		window.MinimumHeight = window.MaximumHeight = 852;
#endif
		return window;
	}
}