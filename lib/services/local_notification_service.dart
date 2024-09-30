import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  LocalNotificationService._();

  static LocalNotificationService notificationService =
      LocalNotificationService._();
  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
  AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
    "chat-app",
    "Local Notification",
    importance: Importance.max,
    priority: Priority.max,
  );

  //init
  Future<void> initNotificationService() async {
    plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    AndroidInitializationSettings android =
        const AndroidInitializationSettings("mipmap/ic_launcher");
    DarwinInitializationSettings iOS = const DarwinInitializationSettings();
    InitializationSettings settings =
        InitializationSettings(android: android, iOS: iOS);
    await plugin.initialize(settings);
  }

  // show
  Future<void> showNotification(String title, String body) async {
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);
    await plugin.show(0, title, body, notificationDetails);
  }

  // Schedule Notification
  Future<void> scheduleNotification() async {
    tz.Location location = tz.getLocation('Asia/Kolkata');
    await plugin.zonedSchedule(
      1,
      "Enjoy New Features",
      "Hello Chat App",
      tz.TZDateTime.now(location).add(const Duration(seconds: 5)),
      NotificationDetails(android: androidDetails),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
