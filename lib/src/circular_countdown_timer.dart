// lib/src/circular_countdown_timer.dart
import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';

class CircularCountdownTimer extends StatefulWidget {
  /// Duration in seconds (this will be the remaining time from server)
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

  // Fixed: Separate current time from widget duration
  int _currentRemainingSeconds = 0;
  bool _isRunning = false;
  Timer? _localTimer;

  // For tracking total capacity (you can modify these values)
  static const Map<String, int> _totalCapacities = {
    'drive': 11 * 3600,     // 11 hours
    'shift': 14 * 3600,     // 14 hours
    'break': 8 * 3600,      // 8 hours
    'cycle': 70 * 3600,     // 70 hours
  };

  @override
  void initState() {
    super.initState();
    _currentRemainingSeconds = widget.duration;

    // Fixed: Short animation for smooth visual updates only
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut)
    );

    if (widget.autoStart) {
      start();
    }

    // Set initial progress
    _updateProgress();
  }

  @override
  void didUpdateWidget(CircularCountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Auto-sync when duration changes from parent (WebSocket update)
    if (oldWidget.duration != widget.duration) {
      _syncToServerTime(widget.duration);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _localTimer?.cancel();
    super.dispose();
  }

  /// NEW: Sync to server time without visual jump
  void _syncToServerTime(int serverSeconds) {
    _localTimer?.cancel();

    setState(() {
      _currentRemainingSeconds = serverSeconds.clamp(0, double.infinity).toInt();
    });

    _updateProgress();

    // Continue running if was running
    if (_isRunning && _currentRemainingSeconds > 0) {
      _startLocalCountdown();
    } else if (_currentRemainingSeconds <= 0) {
      _handleCompletion();
    }
  }

  /// NEW: Update visual progress based on capacity
  void _updateProgress() {
    // Calculate progress based on total capacity vs remaining
    final totalCapacity = _getTotalCapacity();
    if (totalCapacity > 0) {
      final usedTime = totalCapacity - _currentRemainingSeconds;
      final progress = (usedTime / totalCapacity).clamp(0.0, 1.0);
      _controller.animateTo(progress);
    }
  }

  /// NEW: Get total capacity (you can customize this)
  int _getTotalCapacity() {
    // Try to determine timer type from label or use default
    final label = widget.label.toLowerCase();
    for (final entry in _totalCapacities.entries) {
      if (label.contains(entry.key)) {
        return entry.value;
      }
    }
    return 8 * 3600; // Default 8 hours
  }

  /// Start the timer
  void start() {
    if (!_isRunning && _currentRemainingSeconds > 0) {
      setState(() {
        _isRunning = true;
      });
      _startLocalCountdown();
    }
  }

  /// Pause the timer
  void pause() {
    if (_isRunning) {
      setState(() {
        _isRunning = false;
      });
      _localTimer?.cancel();
    }
  }

  /// Resume the timer
  void resume() {
    if (!_isRunning && _currentRemainingSeconds > 0) {
      setState(() {
        _isRunning = true;
      });
      _startLocalCountdown();
    }
  }

  /// Reset the timer
  void reset() {
    _localTimer?.cancel();
    setState(() {
      _currentRemainingSeconds = widget.duration;
      _isRunning = false;
    });
    _updateProgress();
  }

  /// NEW: Restart with new duration (for WebSocket sync)
  void restart({int? duration}) {
    final newDuration = duration ?? widget.duration;
    _localTimer?.cancel();
    setState(() {
      _currentRemainingSeconds = newDuration;
      _isRunning = false;
    });
    _updateProgress();
  }

  /// NEW: Start local countdown between server syncs
  void _startLocalCountdown() {
    _localTimer?.cancel();

    _localTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentRemainingSeconds > 0) {
        setState(() {
          _currentRemainingSeconds--;
        });
        _updateProgress();
      } else {
        _handleCompletion();
      }
    });
  }

  /// NEW: Handle timer completion
  void _handleCompletion() {
    _localTimer?.cancel();
    setState(() {
      _isRunning = false;
      _currentRemainingSeconds = 0;
    });
    widget.onComplete?.call();
  }

  /// Formats a duration (in seconds) - SAME AS BEFORE
  String _formatTime(int totalSeconds) {
    if (totalSeconds == 0) {
      return "00:00";
    }
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return [hours, minutes, seconds].map((v) => v.toString().padLeft(2, '0')).join(':');
    } else if (minutes > 0) {
      return [minutes, seconds].map((v) => v.toString().padLeft(2, '0')).join(':');
    } else {
      return seconds.toString().padLeft(2, '0');
    }
  }

  @override
  Widget build(BuildContext context) {
    // EXACT SAME UI AS BEFORE
    final defaultTimeStyle = TextStyle(
      color: Colors.white,
      fontSize: widget.size * 0.22,
      fontWeight: FontWeight.bold,
    );

    final defaultLabelStyle = TextStyle(
      color: Colors.white,
      fontSize: widget.size * 0.1,
    );

    return Stack(
      alignment: const Alignment(0, 0),
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Dark background circle - SAME
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.backgroundColor,
                ),
              ),

              // Circular progress indicator - SAME UI, FIXED LOGIC
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: CircularProgressPainter(
                        progress: _animation.value, // Now properly animated
                        color: widget.indicatorColor,
                        strokeWidth: widget.strokeWidth,
                      ),
                    );
                  },
                ),
              ),

              // Time and label - SAME
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    _formatTime(_currentRemainingSeconds), // Fixed: use current time
                    style: widget.timeTextStyle ?? defaultTimeStyle,
                  ),
                  if (widget.label.isNotEmpty)
                    Text(
                      widget.label,
                      style: widget.labelTextStyle ?? defaultLabelStyle,
                    ),
                ],
              ),
            ],
          ),
        ),
        // Outer border - SAME
        Container(
            width: widget.size + 15,
            height: widget.size + 15,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 5,
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: widget.indicatorColor,
                )
            )
        ),
      ],
    );
  }
}

// EXACT SAME CustomPainter
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
      -pi / 2, // Start from top
      2 * pi * progress, // Draw based on progress
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