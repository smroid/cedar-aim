// Copyright (c) 2025 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:math' as math;

import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/perf_stats_dialog.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

const double _kStrokeWidthMultiplier = 3.0;
const double _kStartAngleDegrees = 150.0;
const double _kSweepAngleDegrees = 240.0;
const double _kMaxValue = 10.0;
const double _kValueTopRatio = 0.22;
const double _kLabelBottomRatio = -0.05;
const Color _kNoSolutionColor = Color(0xff606060);

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
        : _kNoSolutionColor;
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
            backgroundStrokeWidth: _kStrokeWidthMultiplier * thicknessFactor,
            foregroundStrokeWidth: _kStrokeWidthMultiplier * thicknessFactor,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            foregroundColor: _solveColor(),
            value: math.min(_kMaxValue, math.sqrt(state.numStars)),
            maxValue: _kMaxValue,
          ),
          child: Stack(
            children: [
              // Value - positioned higher up in the arc opening.
              Positioned(
                top: size * _kValueTopRatio,
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
                bottom: size * _kLabelBottomRatio,
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
    
    // Draw background arc.
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = backgroundStrokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _degreesToRadians(_kStartAngleDegrees),
      _degreesToRadians(_kSweepAngleDegrees),
      false,
      backgroundPaint,
    );
    
    // Draw foreground arc based on value.
    final foregroundPaint = Paint()
      ..color = foregroundColor
      ..strokeWidth = foregroundStrokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    final sweepAngle = _degreesToRadians(_kSweepAngleDegrees * (value / maxValue));
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _degreesToRadians(_kStartAngleDegrees),
      sweepAngle,
      false,
      foregroundPaint,
    );
  }
  
  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  @override
  bool shouldRepaint(covariant _CircularGaugePainter oldDelegate) {
    return value != oldDelegate.value ||
           foregroundColor != oldDelegate.foregroundColor ||
           backgroundColor != oldDelegate.backgroundColor;
  }
}
