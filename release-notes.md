# Cedar Aim Release Notes

## 1.2.6 (build 32)

Changes since 1.2.4 (build 30).

### Drawer and connection management

- Reorganized the drawer: connection-related items (WiFi, Bluetooth pairing,
  paired devices, connection status) are now grouped under a new "Connection"
  sub-menu, below System.
- Bluetooth pairing control and paired-device management are now reached via
  a single "Bluetooth" item that opens a dialog, instead of two separate
  top-level items.
- The Bluetooth dialog now shows this device's current pairing status
  (Android only).
- Moved the "Connections" (active client count) view from the About screen
  into the Connection sub-menu, and clarified that it shows clients
  connected to the device, not this app's own connection.
- Added a connection status line (Android only) showing whether this device
  is currently connected via WiFi or Bluetooth. Tapping it opens a dialog to
  switch transports, or to pair over Bluetooth if not already paired.
  Switching to WiFi from Bluetooth re-enables the WiFi access point if
  needed, with a confirmation warning that you may need to reconnect to it
  in your mobile device's WiFi settings.

### Bluetooth reliability

- Fixed a bug where reconnecting to the same Bluetooth device (e.g. from the
  connection recovery dialog) could reset the reconnect backoff and cause
  more aggressive, less reliable re-pairing attempts.
- Increased the Bluetooth connection timeout so a slow-but-successful
  connection (e.g. right after the WiFi access point is disabled) is no
  longer abandoned and orphaned.

## 1.2.4 (build 30)

Changes since 1.2.3 (build 29).

### System status

- Added a CPU/thread usage report, accessible via a button in the load average
  dialog.

## 1.2.3 (build 29)

Changes since 1.2.0 (build 26).

### Image saving

- Saving an image now shows a confirmation snackbar.

## 1.2.0 (build 26)

Changes since 1.1.3 (build 25).

### Goto and navigation

- Implemented an alt-az goto variant.
- The goto dialog now preserves your target when switching between RA/Dec
  and alt-az entry.
- Azimuth is now shown using 16-point compass directions (e.g. "NNE")
  instead of degrees alone.
- The RA/Dec navigation button is now always shown in a consistent place,
  fixing cases where it could disappear or appear twice depending on
  focus/alignment skip settings.
- RA/Dec entry is no longer an advanced/expert-only feature.

### Preferences and UI

- Detection sensitivity is now adjustable via a slider, and is expert-only.
- Preference item labels are now tappable, not just their controls.
- Several preference items switched to a segmented-button style control.
- Various DIY-device visibility checks were simplified to rely on whether
  the corresponding UI implementation is actually available.

### Image saving

- Saved images now go to local device storage.
- Added iOS-specific settings for saving images locally.
- Saved image filenames now start with `cedar_img_`.

### Other fixes

- Fixed a menu sizing/visibility issue on iOS.
