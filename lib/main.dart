import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StopwatchPage(),
    );
  }
}

class StopwatchPage extends StatefulWidget {
  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timerStopwatch;
  Duration _durationStopwatch = const Duration();
  List<Duration> _laps = <Duration>[];

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String threeDigits(int n) => n.toString().padLeft(3, "0");

    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    String threeDigitMilliseconds = threeDigits(d.inMilliseconds.remainder(1000));

    return "$twoDigitMinutes:$twoDigitSeconds:$threeDigitMilliseconds";
  }

  void _startStopwatch() {
    _stopwatch.start();
    _timerStopwatch = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
      setState(() {
        _durationStopwatch = Duration(milliseconds: _stopwatch.elapsed.inMilliseconds);
      });
    });
  }

  void _stopStopwatch() {
    _stopwatch.stop();
    _timerStopwatch.cancel();
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    setState(() {
      _durationStopwatch = Duration(seconds: _stopwatch.elapsed.inSeconds);
      _laps.clear();
    });
  }

  void _lapStopwatch() {
    setState(() {
      _laps.add(_durationStopwatch);
    });
  }

  void _deleteLap(int index) {
    setState(() {
      _laps.removeAt(index);
    });
  }

  void _updateLap(int index) {
    setState(() {
      _laps[index] = _durationStopwatch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Stopwatch',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              formatDuration(_durationStopwatch),
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _startStopwatch,
              child: const Text('Start Stopwatch'),
            ),
            ElevatedButton(
              onPressed: _stopStopwatch,
              child: const Text('Stop Stopwatch'),
            ),
            ElevatedButton(
              onPressed: _resetStopwatch,
              child: const Text('Reset Stopwatch'),
            ),
            ElevatedButton(
              onPressed: _lapStopwatch,
              child: const Text('Lap Stopwatch'),
            ),
            const SizedBox(height: 30),
            Text(
              'Laps',
              style: Theme.of(context).textTheme.headline4,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _laps.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      'Lap ${index + 1}: ${formatDuration(_laps[index])}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () => _updateLap(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteLap(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}