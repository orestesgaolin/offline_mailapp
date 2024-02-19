import 'dart:async';

import 'package:flutter/cupertino.dart';

class ClockLabel extends StatefulWidget {
  const ClockLabel({super.key});

  @override
  State<ClockLabel> createState() => _ClockLabelState();
}

class _ClockLabelState extends State<ClockLabel> {
  // clock label using Timer
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // hh:mm:ss
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        DateTime.now().toIso8601String().substring(11, 19),
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
