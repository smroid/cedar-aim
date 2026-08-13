// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:math' as math;
import 'package:cedar_flutter/cedar_sky.pb.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';

const double _textFontSize = 16.0;
const double _arrowSize = 12.0;
const double _arrowAngleDegrees = 25.0;

// Catalogs whose labels should NOT be used to prefix displayed object
// designations.
const List<String> _specialCatalogLabels =
    ['AST', 'BAY', 'COM', 'HYG', 'IAU', 'PL', 'WDS'];

// Catalog labels in order of how recognizable their designations are, most
// recognizable first. A catalog not listed here sorts after all of these,
// and falls back to the default "label+entry" rendering.
//
// AST/COM/PL are omitted: they name planets, asteroids and comets, which
// are never merged with another catalog's designation of the same object, so
// they never actually compete against this list for ranking.
const List<String> _catalogRank =
    ['M', 'IAU', 'HYG', 'BAY', 'WDS', 'NGC', 'IC', 'C'];

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

// Whether `catalogLabel` is one whose entries are conventionally shown
// without a catalog prefix (e.g. IAU star names), rather than as
// "label+entry" (e.g. "NGC1976").
bool isSpecialCatalogLabel(String catalogLabel) {
  return _specialCatalogLabels.contains(catalogLabel);
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

String _normalizedForMatch(String s) =>
    s.replaceAll(' ', '').toLowerCase();

// Picks the most recognizable designation of an object out of `primary`
// (usually SelectedCatalogEntry.entry or FovCatalogEntry.entry) together
// with its alternates (usually dedupedEntries). `primary` is not
// necessarily the most recognizable of the set, so callers that want to
// label an object for a user should call this rather than assuming
// `primary` is fit to display as-is.
//
// Three tiers of preference are considered, in order:
//
// 1. If `searchText` is given and non-empty, a designation whose label
//    (per labelForEntry) starts with it wins outright -- a result found by
//    searching "c2" should be shown as "C24", not as whichever designation
//    would otherwise be preferred, since that is the designation the
//    user's search actually matched. Comparison ignores case and spaces on
//    both sides, so "c 2" and "C24" match too.
// 2. Otherwise, if `preferredCatalogs` is given and non-empty (typically
//    CatalogEntryMatch.catalog_label, when CatalogEntryMatch.
//    match_catalog_label is set), a designation belonging to one of those
//    catalogs wins -- when the user has filtered the browser to NGC, an
//    object found under that filter should be labeled with its NGC
//    designation, not some other catalog's. If several qualifying
//    designations belong to different preferred catalogs, the
//    recognizability ranking below picks among them (preferredCatalogs
//    itself carries no ordering).
// 3. Otherwise, the recognizability ranking below picks the winner.
//
// Within any tier, if several designations qualify, the recognizability
// ranking picks among them.
CatalogEntry bestDesignation(
    CatalogEntry primary, Iterable<CatalogEntry> alternates,
    {String? searchText, Iterable<String>? preferredCatalogs}) {
  final query = searchText == null || searchText.isEmpty
      ? null
      : _normalizedForMatch(searchText);
  final preferred =
      preferredCatalogs == null || preferredCatalogs.isEmpty
          ? null
          : preferredCatalogs.toSet();

  CatalogEntry? best;
  var bestRank = _catalogRank.length + 1;
  var bestTier = 0; // Higher is better: 2 = search match, 1 = preferred
                    // catalog, 0 = neither.
  for (var candidate in [primary, ...alternates]) {
    final matchesSearch = query != null &&
        _normalizedForMatch(labelForEntry(candidate)).startsWith(query);
    final matchesPreferred =
        preferred != null && preferred.contains(candidate.catalogLabel);
    final tier = matchesSearch ? 2 : (matchesPreferred ? 1 : 0);
    var rank = _catalogRank.indexOf(candidate.catalogLabel);
    if (rank == -1) {
      rank = _catalogRank.length;
    }
    if (best == null ||
        tier > bestTier ||
        (tier == bestTier && rank < bestRank)) {
      best = candidate;
      bestRank = rank;
      bestTier = tier;
    }
  }
  return best!;
}
