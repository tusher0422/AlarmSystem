

import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmEntry {
  final TimeOfDay time;
  final tz.TZDateTime dateTime;
  bool isOn;

  AlarmEntry({
    required this.time,
    required this.dateTime,
    this.isOn = true,
  });
}
