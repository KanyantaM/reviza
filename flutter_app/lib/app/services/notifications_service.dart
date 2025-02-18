import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_stat_notification_icon',
    );
    const initializationSettingsDarwin = DarwinInitializationSettings(
      notificationCategories: [],
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showProgressNotification(
      double progress, String fileName, String uploadId) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      uploadId,
      'File Uploads',
      channelDescription: 'Shows progress of file uploads',
      importance: Importance.high,
      priority: Priority.high,
      progress: progress.round(),
      showProgress: true,
      maxProgress: 100,
      onlyAlertOnce: true,
      color: Colors.tealAccent,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0,
      'Uploading: $fileName',
      'Upload Progress: $progress%',
      platformChannelSpecifics,
      payload: 'upload_progress',
    );
  }

  static Future<void> showCompletionNotification(
      String fileName, String uploadId) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      uploadId,
      'File Uploads',
      channelDescription: 'Shows progress of file uploads',
      importance: Importance.high,
      priority: Priority.high,
      color: Colors.tealAccent,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0,
      'Upload Complete ✅',
      '$fileName uploaded successfully!',
      platformChannelSpecifics,
      payload: 'upload_complete',
    );
  }

  static Future<void> showUploadErrorNotification(
      String uploadId, String fileName) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      uploadId,
      'File Uploads',
      channelDescription: 'Show failed uploads',
      importance: Importance.high,
      priority: Priority.high,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0,
      'Upload Failed❗',
      '$fileName failed to upload',
      platformChannelSpecifics,
      payload: 'upload_failed',
    );
  }
}
