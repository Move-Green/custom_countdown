# Circular Countdown Timer

A highly customizable circular countdown timer widget for Flutter applications.

## Features

- Circular progress indicator that fills as time passes
- Customizable colors, stroke widths, and sizes
- Optional time display with customizable text styles
- Optional label display below the time
- Multiple control methods: start, pause, resume, reset, and restart
- Callbacks for timer completion and timer ticks
- Reverse fill option (fill clockwise or counter-clockwise)
- Auto-start option

## Installation

Add this package to your Flutter project by adding the following to your `pubspec.yaml` file:

```yaml
dependencies:
  circular_countdown_timer:
    git:
      url: https://github.com/Boburbek6010/custom_countdown
      ref: main  # or specific tag/commit
```

Or, if you're using this in a local project:

```yaml
dependencies:
  custom_countdown:
    path: ../path_to_package
```

## Usage

Here's a simple example of how to use the `CircularCountdownTimer`:

```dart
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

@override
Widget build(BuildContext context) {
  return CircularCountdownTimer(
    duration: const Duration(minutes: 5),
    strokeWidth: 10.0,
    progressColor: Colors.green,
    backgroundColor: Colors.grey,
    label: 'Drive',
    onComplete: () {
      // Do something when timer completes
    },
  );
}
```

## Advanced Usage

You can control the timer programmatically using the widget's methods:

```dart
// Create a reference to the widget
final CircularCountdownTimer countdownTimer = CircularCountdownTimer(
  duration: const Duration(minutes: 10),
  // other properties
);

// Start the timer
countdownTimer.start();

// Pause the timer
countdownTimer.pause();

// Resume the timer
countdownTimer.resume();

// Reset the timer to initial state
countdownTimer.reset();

// Restart the timer from beginning
countdownTimer.restart();
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `duration` | `Duration` | Required | The total duration for the countdown timer |
| `strokeWidth` | `double` | `10.0` | The width of the progress indicator stroke |
| `backgroundStrokeWidth` | `double` | `10.0` | The width of the background stroke |
| `progressColor` | `Color` | `Colors.green` | The color of the progress indicator |
| `backgroundColor` | `Color` | `Colors.grey` | The color of the background circle |
| `showTime` | `bool` | `true` | Controls whether to show the time in the center |
| `timeTextStyle` | `TextStyle?` | `null` | The style for the time text |
| `labelTextStyle` | `TextStyle?` | `null` | The style for the label text |
| `label` | `String?` | `null` | Optional label to display below the time |
| `onComplete` | `VoidCallback?` | `null` | Callback when the timer finishes |
| `onTick` | `ValueChanged<Duration>?` | `null` | Callback when the timer ticks |
| `autoStart` | `bool` | `true` | Whether the timer should start automatically |
| `isReverse` | `bool` | `false` | Whether to fill the progress from start or end |
| `size` | `double` | `200.0` | The size of the widget |

## Examples

### Basic Timer

```dart
CircularCountdownTimer(
  duration: const Duration(minutes: 30),
  progressColor: Colors.blue,
  backgroundColor: Colors.grey.shade300,
)
```

### Styled Timer with Label

```dart
CircularCountdownTimer(
  duration: const Duration(hours: 1),
  strokeWidth: 15.0,
  backgroundStrokeWidth: 15.0,
  progressColor: Colors.redAccent,
  backgroundColor: Colors.grey.shade200,
  timeTextStyle: TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
    color: Colors.redAccent,
  ),
  labelTextStyle: TextStyle(
    fontSize: 20.0,
    color: Colors.redAccent,
  ),
  label: 'Remaining',
  onComplete: () {
    print('Timer completed!');
  },
)
```

### Manual Control Timer

```dart
// Create reference to control the timer
final countdownTimer = CircularCountdownTimer(
  duration: const Duration(minutes: 5),
  autoStart: false,
  // other customizations
);

// Later in your UI
ElevatedButton(
  onPressed: () => countdownTimer.start(),
  child: Text('Start'),
),
```

## Contributing

Contributions are welcome! If you have any ideas, suggestions or bug reports, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.