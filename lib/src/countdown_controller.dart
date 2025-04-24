// lib/src/timer_controller.dart
import 'package:flutter/foundation.dart';

class CountdownController extends ChangeNotifier {
  bool _isRunning = false;
  bool _isPaused = false;
  int _initialDuration = 0;

  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;

  void initialize(int duration) {
    _initialDuration = duration;
    _isRunning = false;
    _isPaused = false;
    notifyListeners();
  }

  void setRunning(bool running) {
    _isRunning = running;
    if (running) {
      _isPaused = false;
    }
    notifyListeners();
  }

  void setPaused(bool paused) {
    _isPaused = paused;
    if (paused) {
      _isRunning = false;
    }
    notifyListeners();
  }

  void reset() {
    _isRunning = false;
    _isPaused = false;
    notifyListeners();
  }
}