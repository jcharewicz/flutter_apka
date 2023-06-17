import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // serwisy


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]) // Orientacja
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
theme: ThemeData(
  primarySwatch: Colors.blue,
  colorScheme: ThemeData().colorScheme.copyWith(secondary: Colors.amber),
),
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
  final List<Duration> _laps = <Duration>[];

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
        title: const Text('Stoper'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text(
            //   '',
            //   style: Theme.of(context).textTheme.headlineSmall,
            // ),
            SizedBox(
              height: 50, // Przerwa między tytułem, a miernikiem
            ),
            Text(
              formatDuration(_durationStopwatch),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _startStopwatch,
                  child: Icon(Icons.play_arrow),
                ),
                SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _stopStopwatch,
                  child: Icon(Icons.pause),
                ),
                SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _resetStopwatch,
                  child: Icon(Icons.stop),
                ),
                SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _lapStopwatch,
                  child: Icon(Icons.flag),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              'Okrążenia',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _laps.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        'Okrążenie ${index + 1}: ${formatDuration(_laps[index])}',
                        style: Theme.of(context).textTheme.titleLarge,
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