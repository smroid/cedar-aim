// Copyright (c) 2026 Omair Kamil
// See LICENSE file in root directory for license terms.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cedar_flutter/cedar.pb.dart' as cedar_pb;
import 'package:cedar_flutter/cedar.pbenum.dart';
import 'package:cedar_flutter/platform.dart';
import 'package:grpc/grpc.dart';

class GuidanceDisplay extends StatefulWidget {
  const GuidanceDisplay({super.key});

  @override
  State<GuidanceDisplay> createState() => _GuidanceDisplayState();
}

class _GuidanceDisplayState extends State<GuidanceDisplay> {
  cedar_pb.FrameResult? _latestFrame;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _refreshLoop();
  }

  Future<void> _refreshLoop() async {
    while (mounted) {
      try {
        await Future.delayed(const Duration(milliseconds: 100));
        final request = cedar_pb.FrameRequest()..nonBlocking = true;
        final response = await getClient().getFrame(request);
        if (mounted) {
          setState(() {
            _latestFrame = response;
            _hasError = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _hasError = true;
          });
        }
        // On error wait for additional time before trying again
        await Future.delayed(const Duration(milliseconds: 400));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Card(
        // Set the card to black, otherwise we'll see a black border around the gray
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildContent(theme),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    // If error, no state, or no slew request -> show progress indicator
    if (_hasError || _latestFrame == null || !_latestFrame!.hasSlewRequest()) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      );
    }

    final slewRequest = _latestFrame!.slewRequest;
    final isAltAz =
        _latestFrame!.preferences.mountType == cedar_pb.MountType.ALT_AZ;

    final rot = slewRequest.offsetRotationAxis;
    final tilt = slewRequest.offsetTiltAxis;
    final angle = slewRequest.targetAngle;

    final offsetTextStyle = theme.textTheme.displayLarge?.copyWith(
      fontWeight: FontWeight.bold,
      fontFamily: 'RobotoMono',
      color: theme.colorScheme.primary,
    );

    final indicatorTextStyle = theme.textTheme.displayMedium?.copyWith(
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      fontFamily: 'RobotoMono',
      color: theme.colorScheme.primary,
    );

    return Column(
      children: [
        // Top Row: Guidance Text Values
        Expanded(
          flex: 10,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tilt offset (Alt/RA)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _formatOffset(tilt, true),
                        style: offsetTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
              // Rotation offset (Az/Dec)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _formatOffset(rot, false),
                        style: offsetTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bottom Row: Indicators
        Expanded(
          flex: 15,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Box: Tilt indicator
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: isAltAz
                      ? Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _DirectionArrow(
                                rotation: tilt > 0.0 ? 270 : 90,
                                alignRight: false,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text("Alt", style: indicatorTextStyle),
                              ),
                            ),
                          ],
                        )
                      : FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            tilt > 0 ? "North" : "South",
                            style: indicatorTextStyle,
                          ),
                        ),
                ),
              ),

              // Center Box: Target Arrow
              Expanded(
                flex: 2,
                child: (angle.abs() >= 0.05)
                    ? _TargetArrow(rotationDegrees: angle)
                    : const SizedBox.shrink(),
              ),

              // Right Box: Rotation indicator
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: isAltAz
                      ? Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _DirectionArrow(
                                rotation: rot > 0.0 ? 0 : 180,
                                alignRight: true,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(" Az", style: indicatorTextStyle),
                              ),
                            ),
                          ],
                        )
                      : FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            rot > 0 ? " East" : " West",
                            style: indicatorTextStyle,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatOffset(double num, bool padAtEnd) {
    final n = num.abs();
    final sign = num >= 0 ? '+' : '-';

    if (n >= 100.0) {
      final val = '$sign${n.toStringAsFixed(0)}';
      return padAtEnd ? '$val ' : ' $val';
    } else if (n >= 10.0) {
      return '$sign${n.toStringAsFixed(1)}';
    } else {
      return '$sign${n.toStringAsFixed(2)}';
    }
  }
}

class _TargetArrow extends StatelessWidget {
  final double rotationDegrees;

  const _TargetArrow({required this.rotationDegrees});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox.expand(
      child: FittedBox(
        // 2. BoxFit.contain scales the child to be as large as possible
        // while staying within the bounds.
        fit: BoxFit.contain,
        child: Transform.rotate(
          angle: -rotationDegrees * (math.pi / 180),
          child: Icon(
            Icons.straight,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _DirectionArrow extends StatelessWidget {
  final int rotation;
  final bool alignRight;

  _DirectionArrow({
    required this.rotation,
    required this.alignRight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox.expand(
      child: CustomPaint(
        painter: _ArrowPainter(
          rotationDegrees: rotation.toDouble(),
          alignRight: this.alignRight,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final double rotationDegrees;
  final bool alignRight;
  final Color color;

  _ArrowPainter({
    required this.rotationDegrees,
    required this.alignRight,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final minDim = math.min(size.width, size.height);
    final radius = minDim / 2.5;

    double shapeCenterX = minDim / 2;
    if (alignRight) {
      shapeCenterX = size.width - shapeCenterX;
    }
    final double shapeCenterY = minDim / 2;
    final center = Offset(shapeCenterX, shapeCenterY);

    // Create an isosceles triangle pointing right, then rotate it
    final path = Path();
    canvas.save();

    // Rotate around the calculated center
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationDegrees * math.pi / 180);

    // Draw triangle pointing Right
    path.moveTo(radius, 0);
    final xBack = -radius * 0.5;
    final ySide = radius * 0.866; // approximately sin(60)
    path.lineTo(xBack, -ySide);
    path.lineTo(xBack, ySide);
    path.close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter oldDelegate) {
    return oldDelegate.rotationDegrees != rotationDegrees ||
        oldDelegate.alignRight != alignRight ||
        oldDelegate.color != color;
  }
}
