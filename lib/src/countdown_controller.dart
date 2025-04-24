// lib/src/countdown_controller.dart
import 'dart:async';
import 'package:flutter/foundation.dart';

class CountdownController extends ChangeNotifier {
  Timer? _timer;
  int _duration = 0;
  int _remainingTime = 0;
  bool _isRunning = false;
  VoidCallback? _onComplete;

  int get remainingTime => _remainingTime;
  bool get isRunning => _isRunning;
  int get duration => _duration;

  void initialize({
    required int duration,
    VoidCallback? onComplete,
  }) {
    _duration = duration;
    _remainingTime = duration;
    _onComplete = onComplete;
    notifyListeners();
  }

  void start() {
    if (_isRunning || _remainingTime <= 0) return;

    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        _onComplete?.call();
        stop();
      }
    });

    notifyListeners();
  }

  void pause() {
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void resume() {
    if (!_isRunning && _remainingTime > 0) {
      start();
    }
  }

  void stop() {
    _isRunning = false;
    _timer?.cancel();
    _timer = null;
    notifyListeners();
  }

  void reset() {
    stop();
    _remainingTime = _duration;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}