// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:math' as math;
import 'package:cedar_flutter/draw_util.dart';
import 'package:flutter/material.dart';

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
    bool portrait,
    Size imageSize) {
  if (slewTarget == null) {
    // Slew target is not in field of view. Draw an arrow pointing to it.
    // Calculate arrow length to reach near the image edge (with margin for text).
    final angleRad = _deg2rad(targetAngle);
    final direction = Offset(-math.sin(angleRad), -math.cos(angleRad));

    // Calculate intersection with image bounds, leaving margin for distance text
    const margin = 20.0;
    final maxX = imageSize.width - margin;
    final maxY = imageSize.height - margin;

    // Find which edge the arrow direction intersects
    double tToEdge = double.infinity;

    if (direction.dx > 0) {
      tToEdge = math.min(tToEdge, (maxX - boresight.dx) / direction.dx);
    } else if (direction.dx < 0) {
      tToEdge = math.min(tToEdge, (margin - boresight.dx) / direction.dx);
    }

    if (direction.dy > 0) {
      tToEdge = math.min(tToEdge, (maxY - boresight.dy) / direction.dy);
    } else if (direction.dy < 0) {
      tToEdge = math.min(tToEdge, (margin - boresight.dy) / direction.dy);
    }

    final arrowLength = math.max(40.0, tToEdge - boresightDiameterPix);
    final arrowStart = Offset(boresight.dx - boresightDiameterPix * math.sin(angleRad),
        boresight.dy - boresightDiameterPix * math.cos(angleRad));
    drawArrow(context, canvas, color, arrowStart, arrowLength, angleRad,
              portrait, _thin);
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
}
