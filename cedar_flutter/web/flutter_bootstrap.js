// Customizes Flutter 3.22+ web startup to remove the HTML loading indicator once the engine initializes.
{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine();
    const loader = document.getElementById("loading-indicator");
    if (loader) {
      loader.remove();
    }
    await appRunner.runApp();
  }
});
