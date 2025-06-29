// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:math' as math;
import 'package:cedar_flutter/draw_util.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

const double _hairline = 0.5;
const double _thin = 1;
const double _thick = 2;

double _deg2rad(double deg) {
  return deg / 180.0 * math.pi;
}

// rollAngleRad is counter-clockwise starting from up direction, where y
// increases downward. The angle typically corresponds to north (equatorial
// mount) or zenith (alt-az mount).
void drawBullseye(Canvas canvas, Color color, Offset boresight, double radius,
    double rollAngleRad,
    {daylightMode = false}) {
  if (daylightMode) {
    // Draw black outline for visibility against bright image.
    canvas.drawCircle(
        boresight,
        radius,
        Paint()
          ..color = Colors.black
          ..strokeWidth = 4 * _thin
          ..style = PaintingStyle.stroke);
    drawGapCross(canvas, Colors.black, boresight, radius, radius / 2,
        rollAngleRad, 3 * _thin, 3 * _thin);
  }
  canvas.drawCircle(
      boresight,
      radius,
      Paint()
        ..color = color
        ..strokeWidth = _thin
        ..style = PaintingStyle.stroke);
  drawGapCross(canvas, color, boresight, radius, radius / 2, rollAngleRad,
      _hairline, _hairline + (daylightMode ? 0 : 1));
}

void drawSlewTarget(
    BuildContext context,
    Canvas canvas,
    Color color,
    Offset boresight,
    double boresightDiameterPix,
    double rollAngleRad,
    Offset? slewTarget,
    double targetDistance,
    double targetAngle,
    bool drawDistanceText,
    bool portrait) {
  var distanceText = "";
  if (targetDistance > 10) {
    distanceText = sprintf("%.0f°", [targetDistance]);
  } else if (targetDistance > 1) {
    distanceText = sprintf("%.1f°", [targetDistance]);
  } else {
    final distanceMinutes = targetDistance * 60;
    if (distanceMinutes > 10) {
      distanceText = sprintf("%.0f'", [distanceMinutes]);
    } else if (distanceMinutes > 1) {
      distanceText = sprintf("%.1f'", [distanceMinutes]);
    } else {
      final distanceSeconds = distanceMinutes * 60;
      distanceText = sprintf("%.0f''", [distanceSeconds]);
    }
  }
  if (slewTarget == null) {
    // Slew target is not in field of view. Draw an arrow pointing to it.
    // Make arrow length proportional to targetDistance (degrees, up to 180).
    final arrowLength =
        math.min(100, 100 * math.sqrt(targetDistance / 180.0)).toDouble();
    final arrowRoot = boresightDiameterPix;
    final angleRad = _deg2rad(targetAngle);
    final arrowStart = Offset(boresight.dx - arrowRoot * math.sin(angleRad),
        boresight.dy - arrowRoot * math.cos(angleRad));
    drawArrow(context, canvas, color, arrowStart, arrowLength, angleRad,
        distanceText, portrait, _thin);
    drawDistanceText = false;
  } else {
    // Slew target is in the field of view.
    // Draw the slew target.
    drawGapCross(
        canvas, color, slewTarget, 11, 5, rollAngleRad, _thick, _thick);
  }
  // Draw a bullseye at the boresight position, maybe annotated with the target
  // distance.
  final bsRadius = boresightDiameterPix / 2;
  drawBullseye(canvas, color, boresight, bsRadius, rollAngleRad);
  if (drawDistanceText) {
    final textPos = Offset(
        boresight.dx - bsRadius - 20 * textScaleFactor(context), boresight.dy);
    drawText(context, canvas, color, textPos, distanceText, portrait);
  }
}
