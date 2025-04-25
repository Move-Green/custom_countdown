import 'package:custom_countdown/custom_countdown.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: TimerScreenWithKey(),
    ),
  );
}

class TimerScreenWithKey extends StatefulWidget {
  const TimerScreenWithKey({Key? key}) : super(key: key);

  @override
  TimerScreenWithKeyState createState() => TimerScreenWithKeyState();
}

class TimerScreenWithKeyState extends State<TimerScreenWithKey> {
  final GlobalKey<CircularCountdownTimerState> _timerKey = GlobalKey<CircularCountdownTimerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularCountdownTimer(
          key: _timerKey,
          duration: 5,
          // 8:34 in seconds
          label: 'Shift',
          indicatorColor: Colors.blue,
          backgroundColor: const Color(0xFF192133),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _timerKey.currentState?.start(),
              child: const Text('Start'),
            ),
            ElevatedButton(
              onPressed: () => _timerKey.currentState?.pause(),
              child: const Text('Pause'),
            ),
            ElevatedButton(
              onPressed: () => _timerKey.currentState?.reset(),
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
