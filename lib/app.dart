import 'package:bloc_timer/timer/timer.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bloc timer',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Color.fromRGBO(72, 74, 126, 1),
        ),
      ),

      // TimerPage() is in the view directory
      home: TimerPage(),
    );
  }
}
