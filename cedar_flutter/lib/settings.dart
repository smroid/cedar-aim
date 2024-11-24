// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:math';

import 'package:cedar_flutter/cedar.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:sprintf/sprintf.dart';
import 'google/protobuf/duration.pb.dart' as proto_duration;
import 'get_cedar_client.dart'
    if (dart.library.js_interop) 'get_cedar_client_for_web.dart';

// Determines if 'prev' and 'curr' have any different fields. Fields that
// are the same are cleared from 'curr'.
bool diffPreferences(Preferences prev, Preferences curr) {
  bool hasDiff = false;
  if (curr.celestialCoordFormat != prev.celestialCoordFormat) {
    hasDiff = true;
  } else {
    curr.clearCelestialCoordFormat();
  }
  if (curr.mountType != prev.mountType) {
    hasDiff = true;
  } else {
    curr.clearMountType();
  }
  if (curr.eyepieceFov != prev.eyepieceFov) {
    hasDiff = true;
  } else {
    curr.clearEyepieceFov();
  }
  if (curr.nightVisionTheme != prev.nightVisionTheme) {
    hasDiff = true;
  } else {
    curr.clearNightVisionTheme();
  }
  if (curr.hideAppBar != prev.hideAppBar) {
    hasDiff = true;
  } else {
    curr.clearHideAppBar();
  }
  if (curr.advanced != prev.advanced) {
    hasDiff = true;
  } else {
    curr.clearAdvanced();
  }
  if (curr.textSizeIndex != prev.textSizeIndex) {
    hasDiff = true;
  } else {
    curr.clearTextSizeIndex();
  }
  if (curr.rightHanded != prev.rightHanded) {
    hasDiff = true;
  } else {
    curr.clearRightHanded();
  }
  return hasDiff;
}

// Determines if 'prev' and 'curr' have any different fields. Fields that
// are the same are cleared from 'curr'. Only 'update_interval',
// 'invert_camera', 'dwell_update_interval', and 'log_dwelled_position' are
// considered; all other fields are cleared in 'curr'.
bool diffOperationSettings(OperationSettings prev, OperationSettings curr) {
  // We don't consider these fields.
  curr.clearOperatingMode();
  curr.clearDaylightMode();
  curr.clearFocusAssistMode();
  curr.clearCatalogEntryMatch();
  curr.clearDemoImageFilename();

  bool hasDiff = false;
  if (curr.updateInterval != prev.updateInterval) {
    hasDiff = true;
  } else {
    curr.clearUpdateInterval();
  }
  if (curr.dwellUpdateInterval != prev.dwellUpdateInterval) {
    hasDiff = true;
  } else {
    curr.clearDwellUpdateInterval();
  }
  if (curr.logDwelledPositions != prev.logDwelledPositions) {
    hasDiff = true;
  } else {
    curr.clearLogDwelledPositions();
  }
  if (curr.invertCamera != prev.invertCamera) {
    hasDiff = true;
  } else {
    curr.clearInvertCamera();
  }
  return hasDiff;
}

class SettingsModel extends ChangeNotifier {
  Preferences preferencesProto = Preferences();
  OperationSettings opSettingsProto = OperationSettings();
  bool isDIY = false;
  bool isBasic = false;
  bool isPlus = false;

  SettingsModel() {
    preferencesProto.eyepieceFov = 1.0;
  }

  void updateCelestialCoordFormat(CelestialCoordFormat format) {
    preferencesProto.celestialCoordFormat = format;
    notifyListeners();
  }

  void updateMountType(MountType mt) {
    preferencesProto.mountType = mt;
    notifyListeners();
  }

  void updateSlewBullseyeSize(double size) {
    preferencesProto.eyepieceFov = size;
    notifyListeners();
  }

  void updateNightVisionEnabled(bool enabled) {
    preferencesProto.nightVisionTheme = enabled;
    notifyListeners();
  }

  void updateHideAppBar(bool hide) {
    preferencesProto.hideAppBar = hide;
    notifyListeners();
  }

  void updateUpdateInterval(int intervalMs) {
    opSettingsProto.updateInterval = durationFromMs(intervalMs);
    notifyListeners();
  }

  void updateTextSize(int textSizeIndex) {
    preferencesProto.textSizeIndex = textSizeIndex;
    notifyListeners();
  }

  void updateInvertCamera(bool ic) {
    opSettingsProto.invertCamera = ic;
    notifyListeners();
  }

  void updateRightHanded(bool rh) {
    preferencesProto.rightHanded = rh;
    notifyListeners();
  }
}

proto_duration.Duration durationFromMs(int intervalMs) {
  proto_duration.Duration duration = proto_duration.Duration();
  duration.seconds = Int64(intervalMs ~/ 1000);
  intervalMs -= duration.seconds.toInt() * 1000;
  duration.nanos = intervalMs * 1000000;
  return duration;
}

int durationToMs(proto_duration.Duration duration) {
  return (duration.seconds * 1000 + duration.nanos ~/ 1000000).toInt();
}

double textScaleFactor(BuildContext context) {
  final provider = Provider.of<SettingsModel>(context, listen: false);
  switch (provider.preferencesProto.textSizeIndex) {
    case -1:
      return 1.0;
    case 0:
      return 1.25;
    case 1:
      return 1.5;
  }
  return 1.25;
}

TextScaler textScaler(BuildContext context) {
  return TextScaler.linear(textScaleFactor(context));
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    Text scaledText(String str) {
      return Text(str, textScaler: textScaler(context));
    }

    final provider = Provider.of<SettingsModel>(context, listen: false);
    final prefsProto = provider.preferencesProto;
    final opSettingsProto = provider.opSettingsProto;
    final advanced = provider.preferencesProto.advanced;
    final isBasic = provider.isBasic;
    final isPlus = provider.isPlus;
    final updateIntervalMs = durationToMs(opSettingsProto.updateInterval);
    final rightHanded = prefsProto.rightHanded;

    int updateMax = 6; // DIY: Unlimited.
    if (isBasic) {
      updateMax = 4; // 5Hz.
    } else if (isPlus) {
      updateMax = 5; // 10Hz.
    }
    // Need to inset the switches to match the slider.
    const switchInset = 16.0;

    const backButton =
        BackButton(style: ButtonStyle(iconSize: WidgetStatePropertyAll(30)));

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: rightHanded ? null : backButton,
          title: const Text(
            'Preferences',
          ),
          actions: [rightHanded ? backButton : Container()],
        ),
        body: DefaultTextStyle.merge(
          style: const TextStyle(fontFamilyFallback: ['Roboto']),
          child: SettingsList(
            darkTheme: prefsProto.nightVisionTheme
                ? const SettingsThemeData(
                    titleTextColor: Colors.red,
                    settingsTileTextColor: Colors.red,
                    leadingIconsColor: Colors.red)
                : const SettingsThemeData(),
            sections: [
              SettingsSection(
                  title: SizedBox(
                      child: Text(
                    textHeightBehavior: const TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: true,
                    ),
                    style: const TextStyle(height: 2),
                    'Appearance',
                    textScaler: textScaler(context),
                  )),
                  tiles: [
                    // settings_ui has a bug on Web where the 'trailing' element
                    // is not visible. We work around this by putting the important
                    // element (the control) in the 'leading' position.
                    SettingsTile(
                      leading: SizedBox(
                          width: 140,
                          height: 40,
                          child: Slider(
                            min: -1,
                            max: 1,
                            divisions: 2,
                            value: provider.preferencesProto.textSizeIndex
                                .toDouble(),
                            onChanged: (double value) {
                              setState(() {
                                provider.updateTextSize(value.toInt());
                              });
                            },
                          )),
                      title: scaledText('Text size'),
                    ),
                    SettingsTile(
                      leading: Row(children: <Widget>[
                        const SizedBox(width: switchInset, height: 10),
                        Switch(
                            value: prefsProto.hideAppBar,
                            onChanged: (bool value) {
                              setState(() {
                                provider.updateHideAppBar(value);
                                if (value) {
                                  goFullScreen();
                                } else {
                                  cancelFullScreen();
                                }
                              });
                            })
                      ]),
                      title: scaledText('Full screen'),
                    ),
                    if (advanced)
                      SettingsTile(
                        leading: Row(children: <Widget>[
                          const SizedBox(width: switchInset, height: 10),
                          Switch(
                              value: prefsProto.celestialCoordFormat ==
                                  CelestialCoordFormat.HMS_DMS,
                              onChanged: (bool value) {
                                setState(() {
                                  provider.updateCelestialCoordFormat(value
                                      ? CelestialCoordFormat.HMS_DMS
                                      : CelestialCoordFormat.DECIMAL);
                                });
                              })
                        ]),
                        title: scaledText(prefsProto.celestialCoordFormat ==
                                CelestialCoordFormat.HMS_DMS
                            ? 'RA/Dec format H:M:S/D:M:S'
                            : 'RA/Dec format D.DD/D.DD'),
                      ),
                    SettingsTile(
                      leading: Row(children: <Widget>[
                        const SizedBox(width: switchInset, height: 10),
                        Switch(
                            value: prefsProto.nightVisionTheme,
                            onChanged: (bool value) {
                              setState(() {
                                provider.updateNightVisionEnabled(value);
                              });
                            })
                      ]),
                      title: scaledText('Night vision'),
                    ),
                    SettingsTile(
                      leading: Row(children: <Widget>[
                        const SizedBox(width: switchInset, height: 10),
                        Switch(
                            value: prefsProto.rightHanded,
                            onChanged: (bool value) {
                              setState(() {
                                provider.updateRightHanded(value);
                              });
                            })
                      ]),
                      title: scaledText(
                          rightHanded ? 'Right handed' : 'Left handed'),
                    ),
                  ]),
              if (advanced)
                SettingsSection(
                    title: SizedBox(
                        child: Text(
                      textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false,
                        applyHeightToLastDescent: true,
                      ),
                      style: const TextStyle(height: 2),
                      'Operation',
                      textScaler: textScaler(context),
                    )),
                    tiles: [
                      SettingsTile(
                        leading: SizedBox(
                            width: 140,
                            height: 40,
                            child: Slider(
                              // Slider positions represent:
                              // 1000ms (1Hz), 500ms (2Hz), 333ms (3Hz),
                              // 200ms (5Hz), 100ms (10Hz), and 0ms (fast as
                              // possible).
                              min: 1,
                              max: updateMax.toDouble(),
                              divisions: updateMax - 1,
                              value: min(
                                  updateMax.toDouble(),
                                  switch (updateIntervalMs) {
                                    1000 => 1,
                                    500 => 2,
                                    333 => 3,
                                    200 => 4,
                                    100 => 5,
                                    0 => 6,
                                    _ => 6,
                                  }),
                              onChanged: (double value) {
                                int intervalMs = switch (value.toInt()) {
                                  1 => 1000,
                                  2 => 500,
                                  3 => 333,
                                  4 => 200,
                                  5 => 100,
                                  6 => 0,
                                  _ => 0,
                                };
                                setState(() {
                                  provider.updateUpdateInterval(intervalMs);
                                });
                              },
                            )),
                        title: scaledText(sprintf('Update frequency %s', [
                          switch (updateIntervalMs) {
                            1000 => "1Hz",
                            500 => "2Hz",
                            333 => "3Hz",
                            200 => "5Hz",
                            100 => "10Hz",
                            0 => "unlimited",
                            _ => "unknown $updateIntervalMs",
                          },
                        ])),
                      ),
                    ]),
              SettingsSection(
                  title: SizedBox(
                      child: Text(
                    textHeightBehavior: const TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: true,
                    ),
                    style: const TextStyle(height: 2),
                    'Telescope',
                    textScaler: textScaler(context),
                  )),
                  tiles: [
                    SettingsTile(
                      leading: SizedBox(
                          width: 140,
                          height: 40,
                          child: Slider(
                            min: 0.1,
                            max: 2.0,
                            divisions: 19,
                            value: min(prefsProto.eyepieceFov, 2.0),
                            onChanged: (double value) {
                              setState(() {
                                provider.updateSlewBullseyeSize(value);
                              });
                            },
                          )),
                      title: scaledText(sprintf(
                          'Eyepiece FOV %.1f°', [prefsProto.eyepieceFov])),
                    ),
                    if (advanced && isPlus)
                      SettingsTile(
                        leading: Row(children: <Widget>[
                          const SizedBox(width: switchInset, height: 10),
                          Switch(
                              value:
                                  prefsProto.mountType == MountType.EQUATORIAL,
                              onChanged: (bool value) {
                                setState(() {
                                  provider.updateMountType(value
                                      ? MountType.EQUATORIAL
                                      : MountType.ALT_AZ);
                                });
                              })
                        ]),
                        title: scaledText(
                            prefsProto.mountType == MountType.EQUATORIAL
                                ? 'Equatorial mount'
                                : 'Alt/Az mount'),
                      ),
                    if (advanced)
                      SettingsTile(
                        leading: Row(children: <Widget>[
                          const SizedBox(width: switchInset, height: 10),
                          Switch(
                              value: opSettingsProto.invertCamera,
                              onChanged: (bool value) {
                                setState(() {
                                  provider.updateInvertCamera(value);
                                });
                              })
                        ]),
                        title: scaledText(opSettingsProto.invertCamera
                            ? 'Inverted'
                            : 'Upright'),
                      ),
                  ]),
            ])));
  }
}
