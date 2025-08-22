// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:math' as math;
import 'package:cedar_flutter/cedar_sky.pb.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';

const double _textFontSize = 18.0;
const double _arrowSize = 12.0;
const double _arrowAngleDegrees = 25.0;
const double _textDistanceBase = 30.0;
const double _textDistancePerChar = 1.0;
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
