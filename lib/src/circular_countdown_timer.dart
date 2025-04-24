// lib/src/circular_countdown_timer.dart
import 'dart:math';
import 'package:flutter/material.dart';

class CircularCountdownTimer extends StatefulWidget {
  /// Duration in seconds
  final int duration;

  /// Timer label text
  final String label;

  /// Outer circle color
  final Color indicatorColor;

  /// Background circle color
  final Color backgroundColor;

  /// Width of the progress indicator
  final double strokeWidth;

  /// Size of the widget
  final double size;

  /// Style for the timer text
  final TextStyle? timeTextStyle;

  /// Style for the label text
  final TextStyle? labelTextStyle;

  /// Callback when timer completes
  final VoidCallback? onComplete;

  /// Whether to start automatically
  final bool autoStart;

  const CircularCountdownTimer({
    Key? key,
    required this.duration,
    this.label = '',
    this.indicatorColor = Colors.blue,
    this.backgroundColor = const Color(0xFF1E293B),
    this.strokeWidth = 10.0,
    this.size = 200.0,
    this.timeTextStyle,
    this.labelTextStyle,
    this.onComplete,
    this.autoStart = false,
  }) : super(key: key);

  @override
  CircularCountdownTimerState createState() => CircularCountdownTimerState();
}

class CircularCountdownTimerState extends State<CircularCountdownTimer> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late int _remainingSeconds;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _remainingSeconds = (widget.duration * (1.0 - _controller.value)).ceil();
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isRunning = false;
          });
          widget.onComplete?.call();
        }
      });

    if (widget.autoStart) {
      start();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Start the timer
  void start() {
    if (!_isRunning) {
      _controller.forward(from: 1.0 - (_remainingSeconds / widget.duration));
      setState(() {
        _isRunning = true;
      });
    }
  }

  /// Pause the timer
  void pause() {
    if (_isRunning) {
      _controller.stop();
      setState(() {
        _isRunning = false;
      });
    }
  }

  /// Resume the timer
  void resume() {
    if (!_isRunning) {
      _controller.forward();
      setState(() {
        _isRunning = true;
      });
    }
  }

  /// Reset the timer
  void reset() {
    _controller.reset();
    setState(() {
      _remainingSeconds = widget.duration;
      _isRunning = false;
    });
  }

  /// Format seconds as HH:MM or MM:SS
  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultTimeStyle = TextStyle(
      color: Colors.white,
      fontSize: widget.size * 0.22,
      fontWeight: FontWeight.bold,
    );

    final defaultLabelStyle = TextStyle(
      color: Colors.white,
      fontSize: widget.size * 0.1,
    );

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dark background circle
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.backgroundColor,
            ),
          ),

          // Circular progress indicator
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: CircularProgressPainter(
                progress: 1.0 - _controller.value,
                color: widget.indicatorColor,
                strokeWidth: widget.strokeWidth,
              ),
            ),
          ),

          // Time and label
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatTime(_remainingSeconds),
                style: widget.timeTextStyle ?? defaultTimeStyle,
              ),
              const SizedBox(height: 8),
              if (widget.label.isNotEmpty)
                Text(
                  widget.label,
                  style: widget.labelTextStyle ?? defaultLabelStyle,
                ),
            ],
          ),


          Container(
            width: widget.size+15,
            height: widget.size+15,
            decoration:  ShapeDecoration(
              shape: OvalBorder(
                side: BorderSide(
                  width: 4,
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: widget.indicatorColor,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Paint for the progress arc
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw the arc based on progress
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,  // Start from top
      2 * pi * progress,  // Draw based on progress
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}