// example/lib/main.dart
import 'package:custom_countdown/custom_countdown.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countdown Timer Example',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final CountdownController _breakController = CountdownController();
  final CountdownController _driveController = CountdownController();

  @override
  void initState() {
    super.initState();

    // Initialize break timer (4 hours 45 minutes = 17,100 seconds)
    _breakController.initialize(
      duration: 17100,
      onComplete: () {
        print('Break timer completed!');
      },
    );

    // Initialize drive timer (7 hours 32 minutes = 27,120 seconds)
    _driveController.initialize(
      duration: 27120,
      onComplete: () {
        print('Drive timer completed!');
      },
    );
  }

  @override
  void dispose() {
    _breakController.dispose();
    _driveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularCountdownTimer(
              controller: _breakController,
              label: 'Break',
              theme: const CountdownTheme(
                progressColor: Colors.amber,
                backgroundColor: Color(0xFF5C5628),
              ),
            ),
            CircularCountdownTimer(
              controller: _driveController,
              label: 'Drive',
              theme: const CountdownTheme(
                progressColor: Colors.green,
                backgroundColor: Color(0xFF285C35),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _breakController.start();
              _driveController.start();
            },
            tooltip: 'Start',
            child: const Icon(Icons.play_arrow),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              _breakController.pause();
              _driveController.pause();
            },
            tooltip: 'Pause',
            child: const Icon(Icons.pause),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              _breakController.reset();
              _driveController.reset();
            },
            tooltip: 'Reset',
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
