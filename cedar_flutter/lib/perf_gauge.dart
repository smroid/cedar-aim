// Copyright (c) 2025 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:math' as math;

import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/perf_stats_dialog.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
        child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              onAxisTapped: (double value) => _showPerfStats(context),
              startAngle: 150,
              endAngle: 30,
              showLabels: false,
              showTicks: false,
              showAxisLine: false,
              minimum: 0,
              maximum: 10,
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  positionFactor: 0.3,
                  angle: 270,
                  widget: _solveText(
                    sprintf("%d", [state.numStars]),
                    size: 12 * textFactor,
                  ),
                ),
                GaugeAnnotation(
                  positionFactor: 0.4,
                  angle: 90,
                  widget: _solveText(
                    "stars",
                    size: 10 * textFactor,
                  ),
                ),
              ],
              ranges: <GaugeRange>[
                GaugeRange(
                  startWidth: 3 * thicknessFactor,
                  endWidth: 3 * thicknessFactor,
                  startValue: 0,
                  endValue: 10,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                GaugeRange(
                  startWidth: 3 * thicknessFactor,
                  endWidth: 3 * thicknessFactor,
                  startValue: 0,
                  endValue: math.min(10, math.sqrt(state.numStars)),
                  color: _solveColor(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}