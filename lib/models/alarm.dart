import 'dart:convert';
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


  Map<String, dynamic> toMap() {
    return {
      'hour': time.hour,
      'minute': time.minute,
      'dateTime': dateTime.toIso8601String(),
      'isOn': isOn,
    };
  }


  factory Alarm.fromMap(Map<String, dynamic> map) {
    return Alarm(
      time: TimeOfDay(hour: map['hour'], minute: map['minute']),
      dateTime: tz.TZDateTime.parse(tz.local, map['dateTime']),
      isOn: map['isOn'] ?? true,
    );
  }


  String toJson() => json.encode(toMap());


  factory Alarm.fromJson(String source) => Alarm.fromMap(json.decode(source));
}
