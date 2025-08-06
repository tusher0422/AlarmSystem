

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import '../../models/alarm.dart';

class AlarmScreen extends StatefulWidget {
  final String location;
  const AlarmScreen({super.key, required this.location});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final List<AlarmEntry> _alarms = [];
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _addAlarm() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final now = tz.TZDateTime.now(tz.local);
      var scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );

      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      final newAlarm = AlarmEntry(time: picked, dateTime: scheduled);
      setState(() => _alarms.add(newAlarm));

      _scheduleNotification(newAlarm);
    }
  }

  void _scheduleNotification(AlarmEntry alarm) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      alarm.dateTime.hashCode,
      'Alarm',
      'Time to wake up!',
      alarm.dateTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarms',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  void _cancelNotification(AlarmEntry alarm) async {
    await _flutterLocalNotificationsPlugin.cancel(alarm.dateTime.hashCode);
    _showOffNotification();
  }

  void _showOffNotification() async {
    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Alarm Off',
      'You turned off an alarm.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_off',
          'Alarm Off',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Your Alarms"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Selected Location:\n${widget.location}",
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addAlarm,
              child: const Text("Add Alarm"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _alarms.isEmpty
                  ? const Center(
                child: Text(
                  "No alarms added.",
                  style: TextStyle(color: Colors.white54),
                ),
              )
                  : ListView.builder(
                itemCount: _alarms.length,
                itemBuilder: (_, index) {
                  final alarm = _alarms[index];
                  final formattedTime = alarm.time.format(context);
                  final formattedDate =
                  DateFormat('EEE dd MMM yyyy').format(alarm.dateTime);

                  return Card(
                    color: Colors.grey[900],
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$formattedTime   $formattedDate',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                          Switch(
                            value: alarm.isOn,
                            onChanged: (value) {
                              setState(() => alarm.isOn = value);
                              if (value) {
                                _scheduleNotification(alarm);
                              } else {
                                _cancelNotification(alarm);
                              }
                            },
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
