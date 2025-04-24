// lib/src/circular_countdown_timer.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'countdown_controller.dart';
import 'countdown_theme.dart';

class CircularCountdownTimer extends StatefulWidget {
  final CountdownController controller;
  final CountdownTheme theme;
  final String label;
  final String? Function(int seconds)? timeFormatter;

  const CircularCountdownTimer({
    super.key,
    required this.controller,
    this.theme = const CountdownTheme(),
    this.label = '',
    this.timeFormatter,
  });

  @override
  CircularCountdownTimerState createState() => CircularCountdownTimerState();
}

class CircularCountdownTimerState extends State<CircularCountdownTimer> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final remainingTime = widget.controller.remainingTime;
        final progress = widget.controller.duration > 0
            ? remainingTime / widget.controller.duration
            : 0.0;

        return SizedBox(
          width: widget.theme.width,
          height: widget.theme.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Progress background
              CustomPaint(
                size: Size(widget.theme.width, widget.theme.height),
                painter: _CircularProgressPainter(
                  progress: 1.0,
                  color: widget.theme.backgroundColor,
                  strokeWidth: widget.theme.strokeWidth,
                ),
              ),

              // Progress indicator
              CustomPaint(
                size: Size(widget.theme.width, widget.theme.height),
                painter: _CircularProgressPainter(
                  progress: progress,
                  color: widget.theme.progressColor,
                  strokeWidth: widget.theme.strokeWidth,
                ),
              ),

              // Timer text and label
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.timeFormatter?.call(remainingTime) ??
                        _formatTime(remainingTime),
                    style: widget.theme.textStyle,
                  ),
                  if (widget.label.isNotEmpty)
                    Text(
                      widget.label,
                      style: widget.theme.labelStyle,
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${remainingSeconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
          '${remainingSeconds.toString().padLeft(2, '0')}';
    }
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - strokeWidth / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from top
      2 * pi * progress, // Draw based on progress
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}