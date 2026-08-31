# Cedar Aim Release Notes

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
