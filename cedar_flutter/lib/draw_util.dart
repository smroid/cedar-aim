// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:math' as math;
import 'package:cedar_flutter/cedar_common.pb.dart';
import 'package:cedar_flutter/cedar_sky.pb.dart';
import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

const double _textFontSize = 18.0;
const double _arrowSize = 12.0;
const double _arrowAngleDegrees = 25.0;
const double _textDistanceBase = 30.0;
const double _textDistancePerChar = 1.0;
const double _smallFontSize = 26.0;
const double _largeFontSize = 52.0;
const int _backgroundOpacity = 160;
const List<String> _specialCatalogLabels = ['IAU', 'AST', 'COM', 'PL'];

// angleRad is counter-clockwise starting from up direction, where y increases
// downward. The angle typically corresponds to north (equatorial mount) or
// zenith (alt-az mount).
void drawCross(Canvas canvas, Color color, Offset center, double radius,
    double angleRad, double thickness, double directionThickness) {
  var unitVec = Offset.fromDirection(angleRad + math.pi / 2);
  var unitVecRightAngle = Offset.fromDirection(angleRad);

  canvas.drawLine(
      center.translate(0, 0),
      center.translate(radius * unitVec.dx, -radius * unitVec.dy),
      Paint()
        ..color = color
        ..strokeWidth = directionThickness);
  canvas.drawLine(
      center.translate(0, 0),
      center.translate(-radius * unitVec.dx, radius * unitVec.dy),
      Paint()
        ..color = color
        ..strokeWidth = thickness);
  canvas.drawLine(
      center.translate(
          -radius * unitVecRightAngle.dx, radius * unitVecRightAngle.dy),
      center.translate(
          radius * unitVecRightAngle.dx, -radius * unitVecRightAngle.dy),
      Paint()
        ..color = color
        ..strokeWidth = thickness);
}

// angleRad is counter-clockwise starting from up direction, where y increases
// downward. The angle typically corresponds to north (equatorial mount) or
// zenith (alt-az mount).
void drawGapCross(
    Canvas canvas,
    Color color,
    Offset center,
    double radius,
    double gapRadius,
    double angleRad,
    double thickness,
    double directionThickness) {
  var unitVec = Offset.fromDirection(angleRad + math.pi / 2);
  var unitVecRightAngle = Offset.fromDirection(angleRad);

  canvas.drawLine(
      center.translate(gapRadius * unitVec.dx, -gapRadius * unitVec.dy),
      center.translate(radius * unitVec.dx, -radius * unitVec.dy),
      Paint()
        ..color = color
        ..strokeWidth = directionThickness);
  canvas.drawLine(
      center.translate(-gapRadius * unitVec.dx, gapRadius * unitVec.dy),
      center.translate(-radius * unitVec.dx, radius * unitVec.dy),
      Paint()
        ..color = color
        ..strokeWidth = thickness);
  canvas.drawLine(
      center.translate(
          gapRadius * unitVecRightAngle.dx, -gapRadius * unitVecRightAngle.dy),
      center.translate(
          radius * unitVecRightAngle.dx, -radius * unitVecRightAngle.dy),
      Paint()
        ..color = color
        ..strokeWidth = thickness);
  canvas.drawLine(
      center.translate(
          -gapRadius * unitVecRightAngle.dx, gapRadius * unitVecRightAngle.dy),
      center.translate(
          -radius * unitVecRightAngle.dx, radius * unitVecRightAngle.dy),
      Paint()
        ..color = color
        ..strokeWidth = thickness);
}

// Draw the text centered at `pos`.
void drawText(BuildContext context, Canvas canvas, Color color, Offset pos,
    String text, bool portrait) {
  final textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: _textFontSize)),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      textScaler: textScaler(context));
  textPainter.layout();
  // The textPainter.paint() call puts the upper left corner of the text at the
  // passed pos. Adjust the pos passed to textPainter.paint() so that the center
  // of the next will be at pos.
  Size textSize = textPainter.size;
  final adjustedPos =
      Offset(pos.dx - textSize.width / 2, pos.dy - textSize.height / 2);
  final pivot = textPainter.size.center(adjustedPos);
  if (portrait) {
    canvas.save();
    canvas.translate(pivot.dx, pivot.dy);
    canvas.rotate(-math.pi / 2);
    canvas.translate(-pivot.dx, -pivot.dy);
  }
  textPainter.paint(canvas, adjustedPos);
  if (portrait) {
    canvas.restore();
  }
}

// angleRad is counter-clockwise starting from up direction, where y increases
// downward.
void drawArrow(
    BuildContext context,
    Canvas canvas,
    Color color,
    Offset start,
    double length,
    double angleRad,
    String text,
    bool portrait,
    double thickness) {
  angleRad +=
      math.pi / 2; // The math below wants angle to start from +x direction.
  var end = Offset(start.dx + length * math.cos(angleRad),
      start.dy - length * math.sin(angleRad));

  // Adapted from https://stackoverflow.com/questions/72714333
  // (flutter-how-do-i-make-arrow-lines-with-canvas).
  final paint = Paint()
    ..color = color
    ..strokeWidth = thickness;
  canvas.drawLine(start, end, paint);
  const arrowSize = _arrowSize;
  const arrowAngle = _arrowAngleDegrees * math.pi / 180;

  final path = Path();
  path.moveTo(end.dx - arrowSize * math.cos(angleRad - arrowAngle),
      end.dy + arrowSize * math.sin(angleRad - arrowAngle));
  path.lineTo(end.dx, end.dy);
  path.lineTo(end.dx - arrowSize * math.cos(angleRad + arrowAngle),
      end.dy + arrowSize * math.sin(angleRad + arrowAngle));
  path.close();
  canvas.drawPath(path, paint);
  if (text.isNotEmpty) {
    // Position text some distance beyond the arrowhead. Longer text gets moved
    // out a little further.
    double dist = _textDistanceBase + _textDistancePerChar * text.length * textScaleFactor(context);
    var textPos = Offset(start.dx + (length + dist) * math.cos(angleRad),
        start.dy - (length + dist) * math.sin(angleRad));
    drawText(context, canvas, color, textPos, text, portrait);
  }
}

String labelForEntry(CatalogEntry entry) {
  if (_specialCatalogLabels.contains(entry.catalogLabel)) {
    return entry.catalogEntry;
  }
  return entry.catalogLabel + entry.catalogEntry;
}

String commonNameForEntry(CatalogEntry entry) {
  if (_specialCatalogLabels.contains(entry.catalogLabel)) {
    return "";
  }
  return entry.commonName;
}

String _buildObjectLabel(MyHomePageState state, CelestialCoord target, CatalogEntry catalogEntry) {
  final targetRA = sprintf("RA %s", [state.formatRightAscension(target.ra)]);
  final targetDec = sprintf("Dec %s", [state.formatDeclination(target.dec)]);

  var objectLabel = sprintf("%s\n%s", [targetRA, targetDec]);
  if (catalogEntry.catalogLabel != "") {
    objectLabel = labelForEntry(catalogEntry);
    var commonName = commonNameForEntry(catalogEntry);
    if (commonName.isNotEmpty) {
      objectLabel = sprintf("%s\n%s", [objectLabel, commonName]);
    }
  }
  return objectLabel;
}

Map<String, String> _buildAxisLabels(bool altAz, bool northernHemisphere, double offsetRotationAxis, double offsetTiltAxis) {
  final String rotationAxisName = altAz ? "Az" : "RA";
  final String rotationCue = altAz
      ? (offsetRotationAxis >= 0 ? "right" : "left")
      : (offsetRotationAxis >= 0 ? "towards east" : "towards west");
  final String rotationIconChar =
      altAz ? (offsetRotationAxis >= 0 ? "↻ " : "↺ ") : "";

  final String tiltAxisName = altAz ? "Alt" : "Dec";
  final bool towardsPole =
      northernHemisphere ? offsetTiltAxis >= 0 : offsetTiltAxis <= 0;
  final String tiltCue = altAz
      ? (offsetTiltAxis > 0 ? "up" : "down")
      : (towardsPole ? "towards pole" : "away from pole");
  final String tiltIconChar = altAz ? (offsetTiltAxis > 0 ? "⇑ " : "⇓ ") : "";

  return {
    'rotationAxisName': rotationAxisName,
    'rotationCue': rotationCue,
    'rotationIconChar': rotationIconChar,
    'tiltAxisName': tiltAxisName,
    'tiltCue': tiltCue,
    'tiltIconChar': tiltIconChar,
  };
}

Map<String, String> _formatOffsets(double offsetRotationAxis, double offsetTiltAxis) {
  int rotationPrecision = 0;
  if (offsetRotationAxis.abs() < 10.0) {
    rotationPrecision = 1;
  }
  if (offsetRotationAxis.abs() < 1.0) {
    rotationPrecision = 2;
  }
  int tiltPrecision = 0;
  if (offsetTiltAxis.abs() < 10.0) {
    tiltPrecision = 1;
  }
  if (offsetTiltAxis.abs() < 1.0) {
    tiltPrecision = 2;
  }

  String rotationFormatted =
    sprintf("%+.*f", [rotationPrecision, offsetRotationAxis]);
  String tiltFormatted =
    sprintf("%+.*f", [tiltPrecision, offsetTiltAxis]);
  return {
    'rotationFormatted': rotationFormatted,
    'tiltFormatted': tiltFormatted,
  };
}

TextPainter _buildSlewTextPainter(String objectLabel, Map<String, String> axisLabels, Map<String, String> formattedOffsets, Color color, double displayScale) {
  var smallFont = _smallFontSize;
  var largeFont = _largeFontSize;

  return TextPainter(
      // Don't scale slew directions text with preferences, but do scale with
      // displayScale.
      textScaler: TextScaler.linear(displayScale),
      text: TextSpan(
          children: [
            TextSpan(
              text: "$objectLabel\n",
              style:
                  TextStyle(fontSize: smallFont, fontStyle: FontStyle.italic),
            ),
            TextSpan(
              text: sprintf("%s ", [axisLabels['rotationAxisName']]),
              style: TextStyle(fontSize: smallFont),
            ),
            TextSpan(
              text: formattedOffsets['rotationFormatted'],
              style:
                  TextStyle(fontSize: largeFont, fontWeight: FontWeight.bold),
            ),
            TextSpan(text: "°", style: TextStyle(fontSize: largeFont)),
            const TextSpan(text: "\n"),
            TextSpan(
              text: sprintf("%s", [axisLabels['rotationIconChar']]),
              style: TextStyle(fontSize: smallFont),
            ),
            TextSpan(
              text: sprintf("%s", [axisLabels['rotationCue']]),
              style:
                  TextStyle(fontSize: smallFont, fontStyle: FontStyle.italic),
            ),
            const TextSpan(text: "\n\n"),
            TextSpan(
              text: sprintf("%s ", [axisLabels['tiltAxisName']]),
              style: TextStyle(fontSize: smallFont),
            ),
            TextSpan(
              text: formattedOffsets['tiltFormatted'],
              style:
                  TextStyle(fontSize: largeFont, fontWeight: FontWeight.bold),
            ),
            TextSpan(text: "°", style: TextStyle(fontSize: largeFont)),
            const TextSpan(text: "\n"),
            TextSpan(
              text: sprintf("%s", [axisLabels['tiltIconChar']]),
              style: TextStyle(fontSize: smallFont),
            ),
            TextSpan(
              text: sprintf("%s", [axisLabels['tiltCue']]),
              style:
                  TextStyle(fontSize: smallFont, fontStyle: FontStyle.italic),
            ),
          ],
          style: TextStyle(
            fontFamily: "RobotoMono",
            color: color,
          )),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center);
}

void drawSlewDirections(
  BuildContext context,
  MyHomePageState state,
  CelestialCoord target,
  CatalogEntry catalogEntry,
  Canvas canvas,
  Color color,
  Offset pos,
  bool altAz, // false: eq
  bool northernHemisphere,
  double offsetRotationAxis, // degrees, az or ra movement
  double offsetTiltAxis, // degrees, alt or dec movement
  bool portrait,
  double displayScale,
) {
  final objectLabel = _buildObjectLabel(state, target, catalogEntry);
  final axisLabels = _buildAxisLabels(altAz, northernHemisphere, offsetRotationAxis, offsetTiltAxis);
  final formattedOffsets = _formatOffsets(offsetRotationAxis, offsetTiltAxis);
  final textPainter = _buildSlewTextPainter(objectLabel, axisLabels, formattedOffsets, color, displayScale);
  _paintSlewDirections(canvas, textPainter, pos, portrait, color);
}

void _paintSlewDirections(Canvas canvas, TextPainter textPainter, Offset pos, bool portrait, Color color) {
  textPainter.layout();

  final pivot = textPainter.size.center(pos);
  if (portrait) {
    canvas.save();
    canvas.translate(pivot.dy, pivot.dx);
    canvas.rotate(-math.pi / 2);
    canvas.translate(-pivot.dx, -pivot.dy);
  }

  // Our slew directions might overlap with other stuff on the image,
  // such as the slew target and/or the boresight bullseye (arrange for those
  // to be drawn before the slew directions). Dim the background clutter.
  Color opaqueColor = const Color.fromARGB(_backgroundOpacity, 0, 0, 0);
  final backgroundPaint = Paint()..color = opaqueColor;
  canvas.drawRect(
      Rect.fromLTRB(pos.dx, pos.dy, pos.dx + textPainter.width,
          pos.dy + textPainter.height),
      backgroundPaint);

  textPainter.paint(canvas, pos);
  if (portrait) {
    canvas.restore();
  }
}
