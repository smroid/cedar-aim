// Copyright (c) 2025 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:math' as math;

import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/perf_stats_dialog.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

class PerfGauge extends StatelessWidget {
  final MyHomePageState state;
  final double size;
  final double textFactor;
  final double thicknessFactor;
  
  const PerfGauge({
    super.key,
    required this.state,
    required this.size,
    required this.textFactor,
    required this.thicknessFactor,
  });

  void _showPerfStats(BuildContext context) {
    perfStatsDialog(state, context);
  }

  Text _solveText(String str, {required double size}) {
    return Text(str,
        style: TextStyle(
            fontSize: size,
            color: _solveColor()),
        textScaler: textScaler(state.context));
  }

  Color _solveColor() {
    return state.hasSolution
        ? Theme.of(state.context).colorScheme.primary
        : const Color(0xff606060);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: GestureDetector(
        onTap: () => _showPerfStats(context),
        child: CustomPaint(
          painter: _CircularGaugePainter(
            backgroundStrokeWidth: 3 * thicknessFactor,
            foregroundStrokeWidth: 3 * thicknessFactor,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            foregroundColor: _solveColor(),
            value: math.min(10, math.sqrt(state.numStars)),
            maxValue: 10,
          ),
          child: Stack(
            children: [
              // Value - positioned higher up in the arc opening.
              Positioned(
                top: size * 0.22,
                left: 0,
                right: 0,
                child: Center(
                  child: _solveText(
                    sprintf("%d", [state.numStars]),
                    size: 13 * textFactor,
                  ),
                ),
              ),
              // Label - positioned below the bottom edge.
              Positioned(
                bottom: -size * 0.05,
                left: 0,
                right: 0,
                child: Center(
                  child: _solveText(
                    "stars",
                    size: 10 * textFactor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircularGaugePainter extends CustomPainter {
  final double backgroundStrokeWidth;
  final double foregroundStrokeWidth;
  final Color backgroundColor;
  final Color foregroundColor;
  final double value;
  final double maxValue;

  _CircularGaugePainter({
    required this.backgroundStrokeWidth,
    required this.foregroundStrokeWidth,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.value,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (backgroundStrokeWidth / 2);
    
    // Draw background arc from 150° to 30° (240° total)
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = backgroundStrokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _degreesToRadians(150),
      _degreesToRadians(240),
      false,
      backgroundPaint,
    );
    
    // Draw foreground arc based on value
    final foregroundPaint = Paint()
      ..color = foregroundColor
      ..strokeWidth = foregroundStrokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    final sweepAngle = _degreesToRadians(240 * (value / maxValue));
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _degreesToRadians(150),
      sweepAngle,
      false,
      foregroundPaint,
    );
  }
  
  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}