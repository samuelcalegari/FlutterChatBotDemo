import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class NotificationService {
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> setup() async {
    // #1
    const androidSetting = AndroidInitializationSettings('app_icon');

    // #2
    const initSettings =
        InitializationSettings(android: androidSetting, iOS: null);

    // #3
    await _localNotificationsPlugin.initialize(initSettings).then((_) {
      debugPrint('setupPlugin: setup success');
    }).catchError((Object error) {
      debugPrint('Error: $error');
    });
  }

  void addNotif(String message) async {
    tzData.initializeTimeZones();
    final scheduleTime = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, 3);
    // #2
    final androidDetail = AndroidNotificationDetails(
        "channel", // channel Id
        "channel" // channel Name
        );

    final noticeDetail = NotificationDetails(
      iOS: null,
      android: androidDetail,
    );

    // #3
    final id = 0;

    // #4
    await _localNotificationsPlugin.show(
      0,
      "Nouveau message",
      message,
      noticeDetail,
      payload: 'Notification Payload',
    );
  }
}
