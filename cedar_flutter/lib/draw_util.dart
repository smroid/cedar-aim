// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:math' as math;
import 'package:cedar_flutter/cedar_sky.pb.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';

const double _textFontSize = 16.0;
const double _arrowSize = 12.0;
const double _arrowAngleDegrees = 25.0;
const List<String> _specialCatalogLabels = ['IAU', 'BAY', 'HYG', 'AST', 'COM', 'PL'];

// Catalog labels in order of how recognizable their designations are, most
// recognizable first. A catalog not listed here sorts after all of these,
// and falls back to the default "label+entry" rendering.
//
// AST/COM/PL are omitted: they name planets, asteroids and comets, which
// are never merged with an M/IAU/NGC/IC designation of the same object, so
// they never actually compete against this list for ranking.
const List<String> _catalogRank = ['M', 'IAU', 'HYG', 'BAY', 'NGC', 'IC'];

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
              String text, {FontWeight fontWeight = FontWeight.normal}) {
  final textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: _textFontSize, fontWeight: fontWeight)),
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
  textPainter.paint(canvas, adjustedPos);
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

// Picks the most recognizable designation of an object out of `primary`
// (usually SelectedCatalogEntry.entry or FovCatalogEntry.entry) together
// with its alternates (usually dedupedEntries). `primary` is not
// necessarily the most recognizable of the set, so callers that want to
// label an object for a user should call this rather than assuming
// `primary` is fit to display as-is.
CatalogEntry bestDesignation(
    CatalogEntry primary, Iterable<CatalogEntry> alternates) {
  var best = primary;
  var bestRank = _catalogRank.indexOf(primary.catalogLabel);
  if (bestRank == -1) {
    bestRank = _catalogRank.length;
  }
  for (var alt in alternates) {
    var rank = _catalogRank.indexOf(alt.catalogLabel);
    if (rank == -1) {
      rank = _catalogRank.length;
    }
    if (rank < bestRank) {
      best = alt;
      bestRank = rank;
    }
  }
  return best;
}
