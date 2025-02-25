import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    if (!(Platform.isAndroid || Platform.isIOS)) return;

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

  static Future<void> showUploadProgressNotification(
      double progress, String fileName, String uploadId) async {
    if ((Platform.isAndroid || Platform.isIOS)) {
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
        uploadId.hashCode,
        'Uploading: $fileName',
        'Upload Progress: $progress%',
        platformChannelSpecifics,
        payload: 'upload_progress',
      );
    }
  }

  static Future<void> showUploadCompletionNotification(
      String fileName, String uploadId) async {
    if ((Platform.isAndroid || Platform.isIOS)) {
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
        uploadId.hashCode,
        'Upload Complete ✅',
        '$fileName uploaded successfully!',
        platformChannelSpecifics,
        payload: 'upload_complete',
      );
    }
  }

  static Future<void> showUploadErrorNotification(
      String uploadId, String fileName) async {
    if ((Platform.isAndroid || Platform.isIOS)) {
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
        uploadId.hashCode,
        'Upload Failed❗',
        '$fileName failed to upload',
        platformChannelSpecifics,
        payload: 'upload_failed',
      );
    }
  }

  static Future<void> showDownloadProgressNotification(
      double progress, String fileName, String fileId) async {
    if ((Platform.isAndroid || Platform.isIOS)) {
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        fileId,
        'Downloads',
        channelDescription: 'Shows progress of downloads',
        importance: Importance.high,
        priority: Priority.high,
        progress: progress.round(),
        showProgress: true,
        maxProgress: 100,
        onlyAlertOnce: true,
        color: Colors.teal[200],
      );

      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(
        fileId.hashCode,
        'Downloading: $fileName',
        'Download Progress: $progress%',
        platformChannelSpecifics,
        payload: 'download_progress',
      );
    }
  }

  static Future<void> showDownloadCompletionNotification(
      String fileName, String uploadId) async {
    if ((Platform.isAndroid || Platform.isIOS)) {
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        uploadId,
        'Downloads',
        channelDescription: 'Shows progress of download completions',
        importance: Importance.high,
        priority: Priority.high,
        color: Colors.teal[200],
      );

      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(
        uploadId.hashCode,
        'Download Complete 💯',
        '$fileName saved successfully!',
        platformChannelSpecifics,
        payload: 'download_complete',
      );
    }
  }

  static Future<void> showDownloadErrorNotification(
      String fileId, String fileName) async {
    if ((Platform.isAndroid || Platform.isIOS)) {
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        fileId,
        'Downloads',
        channelDescription: 'Show failed downloads',
        importance: Importance.high,
        priority: Priority.high,
      );

      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(
        fileId.hashCode,
        'Download Failed 💔❗',
        '$fileName failed to download',
        platformChannelSpecifics,
        payload: 'download_failed',
      );
    }
  }
}
