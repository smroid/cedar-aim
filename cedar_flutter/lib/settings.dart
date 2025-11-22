// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:math';

import 'package:cedar_flutter/cedar.pb.dart';
import 'package:cedar_flutter/client_main.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:sprintf/sprintf.dart';
import 'google/protobuf/duration.pb.dart' as proto_duration;

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
  if (curr.screenAlwaysOn != prev.screenAlwaysOn) {
    hasDiff = true;
  } else {
    curr.clearScreenAlwaysOn();
  }
  if (curr.useLx200Wifi != prev.useLx200Wifi) {
    hasDiff = true;
  } else {
    curr.clearUseLx200Wifi();
  }
  if (curr.useLx200Bt != prev.useLx200Bt) {
    hasDiff = true;
  } else {
    curr.clearUseLx200Bt();
  }
  return hasDiff;
}

// Determines if 'prev' and 'curr' have any different fields. Fields that
// are the same are cleared from 'curr'. Only 'log_dwelled_position' and
// 'use_imu' are considered; all other fields are cleared in 'curr'.
bool diffOperationSettings(OperationSettings prev, OperationSettings curr) {
  // We don't consider these fields.
  curr.clearOperatingMode();
  curr.clearDaylightMode();
  curr.clearFocusAssistMode();
  curr.clearCatalogEntryMatch();
  curr.clearDemoImageFilename();

  bool hasDiff = false;
  if (curr.logDwelledPositions != prev.logDwelledPositions) {
    hasDiff = true;
  } else {
    curr.clearLogDwelledPositions();
  }
  if (curr.useImu != prev.useImu) {
    hasDiff = true;
  } else {
    curr.clearUseImu();
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

  void updateTextSize(int textSizeIndex) {
    preferencesProto.textSizeIndex = textSizeIndex;
    notifyListeners();
  }

  void updateRightHanded(bool rh) {
    preferencesProto.rightHanded = rh;
    notifyListeners();
  }

  void updateScreenAlwaysOn(bool alwaysOn) {
    preferencesProto.screenAlwaysOn = alwaysOn;
    notifyListeners();
  }

  void updateUseLx200Wifi(bool enable) {
    preferencesProto.useLx200Wifi = enable;
    notifyListeners();
  }

  void updateUseLx200Bt(bool enable) {
    preferencesProto.useLx200Bt = enable;
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
      return 1.25;
    case 0:
      return 1.5;
    case 1:
      return 1.75;
  }
  return 1.5;
}

TextScaler textScaler(BuildContext context) {
  return TextScaler.linear(textScaleFactor(context));
}

class SettingsScreen extends StatefulWidget {
  final MyHomePageState _homePageState;
  const SettingsScreen(this._homePageState, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<SettingsScreen> createState() => _SettingsScreenState(_homePageState);
}

class _SettingsScreenState extends State<SettingsScreen> {
  final MyHomePageState _homePageState;

  _SettingsScreenState(this._homePageState);
  @override
  Widget build(BuildContext context) {
    Text scaledText(String str) {
      return Text(
        str,
        textScaler: textScaler(context),
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      );
    }

    final provider = Provider.of<SettingsModel>(context, listen: false);
    final prefsProto = provider.preferencesProto;
    // final opSettingsProto = provider.opSettingsProto;
    final advanced = provider.preferencesProto.advanced;
    // final isBasic = provider.isBasic;
    final isPlus = provider.isPlus;
    final isDIY = provider.isDIY;
    final rightHanded = prefsProto.rightHanded;

    final backButton = BackButton(
      style: const ButtonStyle(iconSize: WidgetStatePropertyAll(30)),
      onPressed: () {
        Navigator.pop(context);
        _homePageState.closeDrawer();
      },
    );
    const sliderThemeData = SliderThemeData(
      overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: rightHanded ? null : backButton,
        title: Text(
          'Preferences',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        actions: [rightHanded ? backButton : Container()],
      ),
      body: DefaultTextStyle.merge(
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontFamilyFallback: ['Roboto'],
        ),
        child: SettingsList(
          darkTheme: prefsProto.nightVisionTheme
              ? const SettingsThemeData(
                  titleTextColor: Colors.red,
                  settingsTileTextColor: Colors.red,
                  leadingIconsColor: Colors.red,
                )
              : const SettingsThemeData(),
          sections: [
            SettingsSection(
              title: scaledText('Appearance'),
              tiles: [
                // settings_ui has a bug on Web where the 'trailing' element
                // is not visible. We work around this by putting the important
                // element (the control) in the 'leading' position.
                SettingsTile(
                  leading: SizedBox(
                    width: 100,
                    child: SliderTheme(
                      data: sliderThemeData,
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
                      ),
                    ),
                  ),
                  title: scaledText('Text size'),
                ),
                SettingsTile(
                  leading: Row(
                    children: <Widget>[
                      Switch(
                        value: prefsProto.hideAppBar,
                        onChanged: (bool value) {
                          setState(() {
                            provider.updateHideAppBar(value);
                          });
                        },
                      ),
                    ],
                  ),
                  title: scaledText('Full screen'),
                ),
                if (advanced)
                  SettingsTile(
                    leading: Row(
                      children: <Widget>[
                        Switch(
                          value:
                              prefsProto.celestialCoordFormat ==
                              CelestialCoordFormat.HMS_DMS,
                          onChanged: (bool value) {
                            setState(() {
                              provider.updateCelestialCoordFormat(
                                value
                                    ? CelestialCoordFormat.HMS_DMS
                                    : CelestialCoordFormat.DECIMAL,
                              );
                            });
                          },
                        ),
                      ],
                    ),
                    title: scaledText(
                      prefsProto.celestialCoordFormat ==
                              CelestialCoordFormat.HMS_DMS
                          ? 'RA/Dec format H:M:S/D:M:S'
                          : 'RA/Dec format D.DD/D.DD',
                    ),
                  ),
                SettingsTile(
                  leading: Row(
                    children: <Widget>[
                      Switch(
                        value: prefsProto.nightVisionTheme,
                        onChanged: (bool value) {
                          setState(() {
                            provider.updateNightVisionEnabled(value);
                          });
                        },
                      ),
                    ],
                  ),
                  title: scaledText('Night vision'),
                ),
              ],
            ),
            SettingsSection(
              title: scaledText('Operation'),
              tiles: [
                SettingsTile(
                  leading: Row(
                    children: <Widget>[
                      Switch(
                        value: prefsProto.screenAlwaysOn,
                        onChanged: (bool value) {
                          setState(() {
                            provider.updateScreenAlwaysOn(value);
                          });
                        },
                      ),
                    ],
                  ),
                  title: scaledText('Keep screen on'),
                ),
                SettingsTile(
                  leading: Row(
                    children: <Widget>[
                      Switch(
                        value: prefsProto.rightHanded,
                        onChanged: (bool value) {
                          setState(() {
                            provider.updateRightHanded(value);
                          });
                        },
                      ),
                    ],
                  ),
                  title: scaledText(
                    rightHanded ? 'Right handed' : 'Left handed',
                  ),
                ),
              ],
            ),
            SettingsSection(
              title: scaledText('Telescope'),
              tiles: [
                SettingsTile(
                  leading: SizedBox(
                    width: 140,
                    child: SliderTheme(
                      data: sliderThemeData,
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
                      ),
                    ),
                  ),
                  title: scaledText(
                    sprintf('Eyepiece FOV %.1f°', [prefsProto.eyepieceFov]),
                  ),
                ),
                if (advanced && (isPlus || isDIY))
                  SettingsTile(
                    leading: Row(
                      children: <Widget>[
                        Switch(
                          value: prefsProto.mountType == MountType.EQUATORIAL,
                          onChanged: (bool value) {
                            setState(() {
                              provider.updateMountType(
                                value ? MountType.EQUATORIAL : MountType.ALT_AZ,
                              );
                            });
                          },
                        ),
                      ],
                    ),
                    title: scaledText(
                      prefsProto.mountType == MountType.EQUATORIAL
                          ? 'Equatorial mount'
                          : 'Alt/Az mount',
                    ),
                  ),
              ],
            ),
            if (advanced)
              SettingsSection(
                title: scaledText('App Control (Restart Required)'),
                tiles: [
                  SettingsTile(
                    leading: Row(
                      children: <Widget>[
                        Switch(
                          value: prefsProto.useLx200Wifi,
                          onChanged: (bool value) {
                            setState(() {
                              provider.updateUseLx200Wifi(value);
                            });
                          },
                        ),
                      ],
                    ),
                    title: scaledText('LX200 WiFi control'),
                  ),
                  SettingsTile(
                    leading: Row(
                      children: <Widget>[
                        Switch(
                          value: prefsProto.useLx200Bt,
                          onChanged: (bool value) {
                            setState(() {
                              provider.updateUseLx200Bt(value);
                            });
                          },
                        ),
                      ],
                    ),
                    title: scaledText('LX200 Bluetooth control'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
