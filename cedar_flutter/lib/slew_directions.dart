// Copyright (c) 2025 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:ui' as ui;
import 'package:cedar_flutter/cedar_common.pb.dart';
import 'package:cedar_flutter/cedar_sky.pb.dart';
import 'package:cedar_flutter/draw_util.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

enum ArrowDirection { left, right, up, down }

class SlewDirectionsWidgets {
  final bool northernHemisphere;
  final Color Function() getSolveColor;

  SlewDirectionsWidgets({
    required this.northernHemisphere,
    required this.getSolveColor,
  });

  Widget _buildTriangleArrow(ArrowDirection direction, Color color, double size) {
    return CustomPaint(
      size: Size(size, size),
      painter: _TriangleArrowPainter(direction, color),
    );
  }

  Widget buildAxisGuidance(BuildContext context, String axisName, double offset,
      bool isAltAz, bool isRotationAxis, double scaleFactor, double size) {
    final color = getSolveColor();

    // Format offset with appropriate precision.
    int precision = 0;
    if (offset.abs() < 10.0) {
      precision = 1;
    }
    if (offset.abs() < 1.0) {
      precision = 2;
    }
    String offsetFormatted = sprintf("%+.*f", [precision, offset]);

    // Get direction cue and arrow direction.
    String directionCue;
    ArrowDirection? arrowDirection;

    if (isAltAz) {
      if (isRotationAxis) {
        directionCue = offset >= 0 ? "right" : "left";
        arrowDirection = offset >= 0 ? ArrowDirection.right : ArrowDirection.left;
      } else {
        directionCue = offset > 0 ? "up" : "down";
        arrowDirection = offset > 0 ? ArrowDirection.up : ArrowDirection.down;
      }
    } else {
      if (isRotationAxis) {
        directionCue = offset >= 0 ? "towards east" : "towards west";
        arrowDirection = null; // No arrow for equatorial mount rotation
      } else {
        final towardsPole = northernHemisphere ? offset >= 0 : offset <= 0;
        directionCue = towardsPole ? "towards pole" : "away from pole";
        arrowDirection = null; // No arrow for equatorial mount tilt
      }
    }

    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(axisName,
                   style: TextStyle(color: color, fontSize: 12 * scaleFactor),
                   textScaler: textScaler(context)),
              SizedBox(width: 4 * textScaleFactor(context)),
              Text("$offsetFormatted°",
                   style: TextStyle(color: color, fontSize: 20 * scaleFactor, fontWeight: FontWeight.bold),
                   textScaler: textScaler(context)),
            ],
          ),
          if (arrowDirection != null)
            Transform.translate(
              offset: const Offset(0, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTriangleArrow(arrowDirection, color, 20 * textScaleFactor(context) * scaleFactor),
                  const SizedBox(width: 4),
                  Text(directionCue,
                       style: TextStyle(color: color, fontSize: 10 * scaleFactor, fontStyle: FontStyle.italic),
                       textScaler: textScaler(context)),
                ],
              ),
            )
          else
            Transform.translate(
              offset: const Offset(0, 0),
              child: Text(directionCue,
                   style: TextStyle(color: color, fontSize: 8 * scaleFactor, fontStyle: FontStyle.italic),
                   textScaler: textScaler(context)),
            ),
        ],
      ),
    );
  }

  Widget buildObjectLabel(BuildContext context, CelestialCoord target,
      CatalogEntry catalogEntry, double scaleFactor, double size,
      String Function(double, {bool short}) formatRightAscension,
      String Function(double, {bool short}) formatDeclination) {
    final color = Theme.of(context).colorScheme.primary;

    List<Widget> children = [
      Text("Target",
           style: TextStyle(color: color, fontSize: 10 * scaleFactor),
           textScaler: textScaler(context)),
    ];

    if (catalogEntry.catalogLabel.isNotEmpty) {
      // Show catalog name and object type.
      final commonName = commonNameForEntry(catalogEntry);
      final objectLabel = commonName.isEmpty ? labelForEntry(catalogEntry) : commonName;
      bool usedTwoLines = false;

      // Handle short vs long names differently
      if (objectLabel.length <= 12) {
        // Short name: single line with scaling
        children.add(FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(objectLabel,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: color, fontSize: 14 * scaleFactor, fontStyle: FontStyle.italic),
                      textScaler: textScaler(context))));
      } else {
        // Long name: try to break at a space for better line breaks
        String displayLabel = objectLabel;
        final midPoint = objectLabel.length ~/ 2;

        // Look for a space near the middle to break on
        for (int i = 1; i <= midPoint; i++) {
          final checkBefore = midPoint - i;
          final checkAfter = midPoint + i;

          if (checkBefore >= 0 && checkBefore < objectLabel.length && objectLabel[checkBefore] == ' ') {
            displayLabel = objectLabel.replaceFirst(' ', '\n', checkBefore);
            break;
          }
          if (checkAfter < objectLabel.length && objectLabel[checkAfter] == ' ') {
            displayLabel = objectLabel.replaceFirst(' ', '\n', checkAfter);
            break;
          }
        }

        // Two lines with scaling
        children.add(FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(displayLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: color, fontSize: 12 * scaleFactor, fontStyle: FontStyle.italic, height: 1.1),
                      textScaler: textScaler(context))));
        usedTwoLines = true;
      }

      if (!usedTwoLines && catalogEntry.objectType.label.isNotEmpty) {
        final label = catalogEntry.objectType.label;
        children.add(Text("($label)",
                          style: TextStyle(color: color, fontSize: 10 * scaleFactor,),
                          textScaler: textScaler(context)));
      }
    } else {
      // Show RA and Dec
      final ra = formatRightAscension(target.ra, short: true);
      final dec = formatDeclination(target.dec, short: true);

      children.add(Text("RA $ra",
                        style: TextStyle(color: color, fontSize: 10 * scaleFactor),
                        textScaler: textScaler(context)));
      children.add(Text("Dec $dec",
                        style: TextStyle(color: color, fontSize: 10 * scaleFactor),
                        textScaler: textScaler(context)));
    }

    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}

class _TriangleArrowPainter extends CustomPainter {
  final ArrowDirection direction;
  final Color color;

  _TriangleArrowPainter(this.direction, this.color);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final paint = ui.Paint()
      ..color = color
      ..style = ui.PaintingStyle.fill;

    final path = ui.Path();
    final center = ui.Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    switch (direction) {
      case ArrowDirection.right:
        // Right-pointing triangle
        path.moveTo(center.dx - radius, center.dy - radius);
        path.lineTo(center.dx + radius, center.dy);
        path.lineTo(center.dx - radius, center.dy + radius);
        break;
      case ArrowDirection.left:
        // Left-pointing triangle
        path.moveTo(center.dx + radius, center.dy - radius);
        path.lineTo(center.dx - radius, center.dy);
        path.lineTo(center.dx + radius, center.dy + radius);
        break;
      case ArrowDirection.up:
        // Up-pointing triangle
        path.moveTo(center.dx, center.dy - radius);
        path.lineTo(center.dx + radius, center.dy + radius);
        path.lineTo(center.dx - radius, center.dy + radius);
        break;
      case ArrowDirection.down:
        // Down-pointing triangle
        path.moveTo(center.dx, center.dy + radius);
        path.lineTo(center.dx + radius, center.dy - radius);
        path.lineTo(center.dx - radius, center.dy - radius);
        break;
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}