import 'package:cedar_flutter/cedar.pb.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:sprintf/sprintf.dart';

// Determines if 'prev' and 'curr' have any different fields. Fields that
// are the same are cleared from 'curr'.
bool diffPreferences(Preferences prev, Preferences curr) {
  bool hasDiff = false;
  if (curr.celestialCoordFormat != prev.celestialCoordFormat) {
    hasDiff = true;
  } else {
    curr.clearCelestialCoordFormat();
  }
  if (curr.slewBullseyeSize != prev.slewBullseyeSize) {
    hasDiff = true;
  } else {
    curr.clearSlewBullseyeSize();
  }
  if (curr.nightVisionTheme != prev.nightVisionTheme) {
    hasDiff = true;
  } else {
    curr.clearNightVisionTheme();
  }
  if (curr.showPerfStats != prev.showPerfStats) {
    hasDiff = true;
  } else {
    curr.clearShowPerfStats();
  }
  return hasDiff;
}

class SettingsModel extends ChangeNotifier {
  Preferences preferencesProto = Preferences(slewBullseyeSize: 1);

  void updateCelestialCoordFormat(CelestialCoordFormat format) {
    preferencesProto.celestialCoordFormat = format;
    notifyListeners();
  }

  void updateSlewBullseyeSize(double size) {
    preferencesProto.slewBullseyeSize = size;
    notifyListeners();
  }

  void updateNightVisionEnabled(bool enabled) {
    preferencesProto.nightVisionTheme = enabled;
    notifyListeners();
  }

  void updateShowPerfStats(bool enabled) {
    preferencesProto.showPerfStats = enabled;
    notifyListeners();
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsModel>(context, listen: false);
    final prefsProto = provider.preferencesProto;
    return Scaffold(
        appBar: AppBar(title: const Text('Preferences')),
        body: SettingsList(
            darkTheme: prefsProto.nightVisionTheme
                ? const SettingsThemeData(
                    titleTextColor: Colors.red,
                    settingsTileTextColor: Colors.red,
                    leadingIconsColor: Colors.red)
                : const SettingsThemeData(),
            sections: [
              SettingsSection(title: const Text('Display'), tiles: [
                SettingsTile(
                  leading: const Icon(Icons.numbers),
                  title: Text(prefsProto.celestialCoordFormat ==
                          CelestialCoordFormat.HMS_DMS
                      ? 'RA/Dec format H.M.S/D.M.S'
                      : 'RA/Dec format D.DD/D.DD'),
                  trailing: Switch(
                      value: prefsProto.celestialCoordFormat ==
                          CelestialCoordFormat.HMS_DMS,
                      onChanged: (bool value) {
                        setState(() {
                          provider.updateCelestialCoordFormat(value
                              ? CelestialCoordFormat.HMS_DMS
                              : CelestialCoordFormat.DECIMAL);
                        });
                      }),
                ),
                SettingsTile(
                  leading: const Icon(Icons.visibility, color: Colors.red),
                  title: const Text('Night vision theme'),
                  trailing: Switch(
                      value: prefsProto.nightVisionTheme,
                      onChanged: (bool value) {
                        setState(() {
                          provider.updateNightVisionEnabled(value);
                        });
                      }),
                ),
                SettingsTile(
                  leading: const Icon(Icons.timer),
                  title: const Text('Show performance stats'),
                  trailing: Switch(
                      value: prefsProto.showPerfStats,
                      onChanged: (bool value) {
                        setState(() {
                          provider.updateShowPerfStats(value);
                        });
                      }),
                ),
                SettingsTile(
                  leading: const Icon(Icons.circle_outlined),
                  trailing: Slider(
                    min: 0.1,
                    max: 2.0,
                    divisions: 19,
                    value: prefsProto.slewBullseyeSize,
                    onChanged: (double value) {
                      setState(() {
                        provider.updateSlewBullseyeSize(value);
                      });
                    },
                  ),
                  title: Text(sprintf(
                      'Telescope FOV  %.1f°', [prefsProto.slewBullseyeSize])),
                ),
              ])
            ]));
  }
}
