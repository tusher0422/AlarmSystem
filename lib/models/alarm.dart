import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

class Alarm {
  final TimeOfDay time;
  final tz.TZDateTime dateTime;
  bool isOn;

  Alarm({
    required this.time,
    required this.dateTime,
    this.isOn = true,
  });
}
