// lib/src/circular_countdown_timer.dart
import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';

class CircularCountdownTimer extends StatefulWidget {
  /// Total capacity in seconds (e.g., 8 hours = 28800 seconds)
  final int totalCapacity;

  /// Current remaining time in seconds
  final int remainingTime;

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

  /// Show capacity progress indicator
  final bool showCapacityProgress;

  const CircularCountdownTimer({
    Key? key,
    required this.totalCapacity,
    required this.remainingTime,
    this.label = '',
    this.indicatorColor = Colors.blue,
    this.backgroundColor = const Color(0xFF1E293B),
    this.strokeWidth = 10.0,
    this.size = 200.0,
    this.timeTextStyle,
    this.labelTextStyle,
    this.onComplete,
    this.autoStart = false,
    this.showCapacityProgress = true,
  }) : super(key: key);

  @override
  CircularCountdownTimerState createState() => CircularCountdownTimerState();
}

class CircularCountdownTimerState extends State<CircularCountdownTimer> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int _currentRemainingSeconds = 0;
  bool _isRunning = false;
  Timer? _countdownTimer;
  DateTime? _lastSyncTime;

  @override
  void initState() {
    super.initState();
    _currentRemainingSeconds = widget.remainingTime;

    // Animation controller for smooth visual updates
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Smooth transition duration
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
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

    // Sync when remaining time changes from parent
    if (oldWidget.remainingTime != widget.remainingTime) {
      syncToTime(widget.remainingTime);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  /// Sync timer to specific remaining time (from server)
  void syncToTime(int remainingSeconds) {
    setState(() {
      _currentRemainingSeconds = remainingSeconds.clamp(0, widget.totalCapacity);
      _lastSyncTime = DateTime.now();
    });

    _updateProgress();

    // If timer was running, continue running
    if (_isRunning && _currentRemainingSeconds > 0) {
      _startLocalCountdown();
    } else if (_currentRemainingSeconds <= 0) {
      _handleTimerComplete();
    }
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
      _countdownTimer?.cancel();
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

  /// Reset timer to initial state
  void reset() {
    _countdownTimer?.cancel();
    setState(() {
      _currentRemainingSeconds = widget.remainingTime;
      _isRunning = false;
    });
    _updateProgress();
  }

  /// Restart timer with new duration
  void restart({int? duration}) {
    _countdownTimer?.cancel();
    setState(() {
      _currentRemainingSeconds = duration ?? widget.remainingTime;
      _isRunning = false;
    });
    _updateProgress();
    start();
  }

  /// Start local countdown between server syncs
  void _startLocalCountdown() {
    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentRemainingSeconds > 0) {
        setState(() {
          _currentRemainingSeconds--;
        });
        _updateProgress();
      } else {
        _handleTimerComplete();
      }
    });
  }

  /// Update visual progress indicator
  void _updateProgress() {
    if (widget.totalCapacity > 0) {
      final progress = (_currentRemainingSeconds / widget.totalCapacity).clamp(0.0, 1.0);
      _controller.animateTo(progress);
    }
  }

  /// Handle timer completion
  void _handleTimerComplete() {
    _countdownTimer?.cancel();
    setState(() {
      _isRunning = false;
      _currentRemainingSeconds = 0;
    });
    widget.onComplete?.call();
  }

  /// Format time as HH:MM:SS or MM:SS
  String _formatTime(int totalSeconds) {
    if (totalSeconds <= 0) return "00:00";

    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return [hours, minutes, seconds]
          .map((v) => v.toString().padLeft(2, '0'))
          .join(':');
    } else {
      return [minutes, seconds]
          .map((v) => v.toString().padLeft(2, '0'))
          .join(':');
    }
  }

  /// Get capacity percentage (used time)
  double get capacityPercentage {
    if (widget.totalCapacity <= 0) return 0.0;
    final usedTime = widget.totalCapacity - _currentRemainingSeconds;
    return (usedTime / widget.totalCapacity).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final defaultTimeTextStyle = TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    final defaultLabelTextStyle = TextStyle(
      fontSize: 16.0,
      color: Colors.white70,
    );

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: widget.strokeWidth,
              backgroundColor: widget.backgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(widget.backgroundColor),
            ),
          ),

          // Capacity progress (total used time)
          if (widget.showCapacityProgress)
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: CircularProgressIndicator(
                value: capacityPercentage,
                strokeWidth: widget.strokeWidth,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                    widget.indicatorColor.withOpacity(0.3)
                ),
              ),
            ),

          // Remaining time indicator
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  value: _animation.value,
                  strokeWidth: widget.strokeWidth / 2,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(widget.indicatorColor),
                ),
              );
            },
          ),

          // Center content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Time display
              Text(
                _formatTime(_currentRemainingSeconds),
                style: widget.timeTextStyle ?? defaultTimeTextStyle,
              ),

              // Label
              if (widget.label.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  widget.label,
                  style: widget.labelTextStyle ?? defaultLabelTextStyle,
                ),
              ],

              // Capacity info (optional)
              if (widget.showCapacityProgress) ...[
                const SizedBox(height: 2),
                Text(
                  '${(capacityPercentage * 100).toInt()}% used',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white54,
                  ),
                ),
              ],
            ],
          ),

          // Sync indicator
          if (_lastSyncTime != null &&
              DateTime.now().difference(_lastSyncTime!).inSeconds < 3)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}