// Copyright (c) 2025 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:math' as math;

import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/perf_stats_dialog.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

const double _kStrokeWidthMultiplier = 4.0;
const double _kStartAngleDegrees = 160.0;
const double _kSweepAngleDegrees = 220.0;
const double _kMaxValue = 10.0;
const double _kExposureTimeMaxMs = 1000.0;
const double _kSolveRateMaxHz = 50.0;
const double _kStarsMax = 100.0;
const double _kValueTopRatio = 0.1;
const double _kUnitsTopRatio = 0.42;
const double _kLabelBottomRatio = 0.0;
const Color _kNoSolutionColor = Color(0xff606060);

/// A custom circular performance gauge that displays metrics with dynamic scaling.
///
/// The gauge displays three components:
/// - Numeric value (centered in gauge opening)
/// - Units (smaller text below value, when applicable)
/// - Descriptive label (below the gauge)
///
/// Currently supports three metric types:
/// - exposure_time: Shows ms or seconds based on value
/// - solve_interval: Shows Hz (solve rate)
/// - stars: Shows star count (no units)
///
/// All metrics use sqrt scaling for better visual responsiveness at lower values,
/// with values above the full-scale maximum pinned at maximum gauge deflection.
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

  /// Converts seconds to Hz, with zero-division protection.
  double _secondsToHz(double seconds) {
    return seconds > 0.0 ? 1.0 / seconds : 0.0;
  }

  /// Formats a value with conditional decimal places based on magnitude.
  /// Values >= 10 show no decimals, values < 10 show one decimal place.
  String _formatWithConditionalDecimal(double value) {
    // Round to 1 decimal place first to determine formatting
    double rounded = (value * 10).round() / 10;
    return rounded >= 10.0 ? sprintf("%.0f", [rounded]) : sprintf("%.1f", [rounded]);
  }

  /// Returns the current metric's display value, units, and gauge position.
  /// - Raw values are normalized to their full-scale maximum
  /// - sqrt() is applied for better low-value visibility
  /// - Result is scaled to _kMaxValue for the gauge painter
  ({String value, String? units, double gaugeValue}) _getCurrentValueAndUnits() {
    final choice = (state.preferences?.perfGaugeChoice.isEmpty ?? true)
        ? "stars"
        : state.preferences!.perfGaugeChoice;

    String displayValue;
    String? displayUnits;
    double rawValue;
    double maxValue;

    switch (choice) {
      case "exposure_time":
        final expTimeMs = state.exposureTimeMs;
        rawValue = expTimeMs;
        maxValue = _kExposureTimeMaxMs;

        if (expTimeMs >= 1000) {
          double seconds = expTimeMs / 1000;
          displayValue = _formatWithConditionalDecimal(seconds);
          displayUnits = "sec";
        } else {
          displayValue = _formatWithConditionalDecimal(expTimeMs);
          displayUnits = "ms";
        }
        break;
      case "solve_interval":
        if (state.processingStats?.solveInterval.recent.mean != null) {
         final solveInterval = state.processingStats!.solveInterval.recent.mean;
          double hz = _secondsToHz(solveInterval);
          rawValue = hz;
          maxValue = _kSolveRateMaxHz;
          displayValue = _formatWithConditionalDecimal(hz);
          displayUnits = "Hz";
        } else {
          displayValue = "0.0";
          displayUnits = "Hz";
          rawValue = 0.0;
          maxValue = _kSolveRateMaxHz;
        }
        break;
      case "stars":
      default:
        final stars = state.numStars;
        rawValue = stars.toDouble();
        maxValue = _kStarsMax;
        displayValue = sprintf("%d", [stars]);
        displayUnits = null;
        break;
    }

    // Apply sqrt scaling to all metrics.
    double normalized = math.min(1.0, rawValue / maxValue);
    double gaugeVal = math.sqrt(normalized) * _kMaxValue;

    return (value: displayValue, units: displayUnits, gaugeValue: gaugeVal);
  }

  String _getCurrentLabel() {
    final choice = (state.preferences?.perfGaugeChoice.isEmpty ?? true)
        ? "stars"
        : state.preferences!.perfGaugeChoice;
    switch (choice) {
      case "exposure_time":
        return "exp. time";
      case "solve_interval":
        return "solve rate";
      case "stars":
      default:
        return "stars";
    }
  }

  double _getCurrentGaugeValue() {
    return _getCurrentValueAndUnits().gaugeValue;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.3,
      height: size,
      child: GestureDetector(
        onTap: () => _showPerfStats(context),
        child: CustomPaint(
          key: ValueKey('perf_gauge_${_getCurrentGaugeValue()}'),
          painter: _CircularGaugePainter(
            backgroundStrokeWidth: _kStrokeWidthMultiplier * thicknessFactor,
            foregroundStrokeWidth: _kStrokeWidthMultiplier * thicknessFactor,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            foregroundColor: _solveColor(),
            value: _getCurrentGaugeValue(),
            maxValue: _kMaxValue,
          ),
          child: Stack(
            children: [
              // Value - positioned higher up in the arc opening, or centered if no units.
              Positioned(
                top: size * (_getCurrentValueAndUnits().units != null ? _kValueTopRatio : 0.22),
                left: 0,
                right: 0,
                child: Center(
                  child: _solveText(
                    _getCurrentValueAndUnits().value,
                    size: 12 * textFactor,
                  ),
                ),
              ),
              // Units - positioned below the value, within the gauge.
              if (_getCurrentValueAndUnits().units != null)
                Positioned(
                  top: size * _kUnitsTopRatio,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _solveText(
                      _getCurrentValueAndUnits().units!,
                      size: 8 * textFactor,
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
                    _getCurrentLabel(),
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

/// Custom painter for drawing the circular gauge arc.
///
/// Draws a background arc and a foreground arc that represents the current value.
/// The gauge uses a partial circle (not full 360°) with rounded end caps.
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
    final radius = (size.height / 2) - (backgroundStrokeWidth / 2);

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
