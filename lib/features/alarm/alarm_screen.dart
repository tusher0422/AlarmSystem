import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  final List<Alarm> _alarms = [];
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _initializeNotifications();
    _setLocalTimeZone();
  }

  Future<void> _setLocalTimeZone() async {
    final String timeZoneName = tz.local.name;
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  void _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _flutterLocalNotificationsPlugin.initialize(settings);
  }

  Future<void> _addAlarm() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = tz.TZDateTime.now(tz.local);
      var scheduled = tz.TZDateTime(
          tz.local, now.year, now.month, now.day, picked.hour, picked.minute);
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      final newAlarm = Alarm(time: picked, dateTime: scheduled);
      setState(() => _alarms.add(newAlarm));
      _scheduleNotification(newAlarm);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alarm set successfully!')),
      );
    }
  }

  void _scheduleNotification(Alarm alarm) async {
    final id = alarm.dateTime.hashCode;
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Alarm',
      'Time to wake up!',
      alarm.dateTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarms',
          channelDescription: 'Channel for alarm notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('alarm'),
          enableVibration: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  void _cancelNotification(Alarm alarm) async {
    final id = alarm.dateTime.hashCode;
    await _flutterLocalNotificationsPlugin.cancel(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alarm turned off.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Selected Location header
              const Text(
                "Selected Location",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Location row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.location,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Add Alarm button
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A3A3A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: _addAlarm,
                    child: const Text("Add Alarm"),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Alarms Header
              const Text(
                "Alarms",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Alarm list
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

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D2D2D),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left side: Time
                          Text(
                            formattedTime,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Right side: Date + Switch
                          Row(
                            children: [
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Switch(
                                activeColor: Colors.purple,
                                value: alarm.isOn,
                                onChanged: (value) {
                                  setState(() => alarm.isOn = value);
                                  if (value) {
                                    _scheduleNotification(alarm);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                          content:
                                          Text('Alarm turned on.')),
                                    );
                                  } else {
                                    _cancelNotification(alarm);
                                  }
                                },
                              ),
                            ],
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
      ),
    );
  }
}
