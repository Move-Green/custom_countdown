// import 'package:flutter/material.dart';
//
// class TimerScreenWithKey extends StatefulWidget {
//   const TimerScreenWithKey({Key? key}) : super(key: key);
//
//   @override
//   TimerScreenWithKeyState createState() => TimerScreenWithKeyState();
// }
//
// class TimerScreenWithKeyState extends State<TimerScreenWithKey> {
//   final GlobalKey<CircularTimerState> _timerKey = GlobalKey<CircularTimerState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: CircularTimer(
//           key: _timerKey,
//           duration: 8 * 3600 + 34 * 60, // 8:34 in seconds
//           label: 'Shift',
//           indicatorColor: Colors.blue,
//           backgroundColor: const Color(0xFF192133),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ElevatedButton(
//               onPressed: () => _timerKey.currentState?.start(),
//               child: const Text('Start'),
//             ),
//             ElevatedButton(
//               onPressed: () => _timerKey.currentState?.pause(),
//               child: const Text('Pause'),
//             ),
//             ElevatedButton(
//               onPressed: () => _timerKey.currentState?.reset(),
//               child: const Text('Reset'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }