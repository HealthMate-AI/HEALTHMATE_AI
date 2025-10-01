import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

  final InitializationSettings initSettings =
      InitializationSettings(android: androidInit, iOS: iosInit);

  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

Future<void> checkExpiringMedicinesOnStart({required User user}) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('medicine_expiry_tracker')
      .where('userId', isEqualTo: user.uid)
      .get();

  final prefs = await SharedPreferences.getInstance();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  for (final doc in snapshot.docs) {
    final data = doc.data();
    final medicineName = data['medicineName'] ?? 'Unknown';
    final expiryTs = data['expiryDate'];
    DateTime? expiryDate;
    if (expiryTs is Timestamp) expiryDate = expiryTs.toDate();
    if (expiryTs is DateTime) expiryDate = expiryTs;
    if (expiryDate == null) continue;

    final id = doc.id;
    final expDateOnly = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    final daysDiff = expDateOnly.difference(today).inDays;

    String? milestone;
    if (daysDiff < 0) milestone = 'expired';
    else if (daysDiff == 0) milestone = 'today';
    else if (daysDiff == 1) milestone = '1day';
    else if (daysDiff <= 7) milestone = '1week';
    else if (daysDiff <= 30) milestone = '1month';

    if (milestone == null) continue;

    final key = '$id-$milestone';
    if (prefs.getBool(key) == true) continue;

    String message;
    switch (milestone) {
      case 'expired':
        message = '⚠️ $medicineName has already expired!';
        break;
      case 'today':
        message = '⚠️ $medicineName expires today!';
        break;
      case '1day':
        message = '⏰ $medicineName expires in 1 day!';
        break;
      case '1week':
        message = '⏰ $medicineName expires in $daysDiff days!';
        break;
      case '1month':
        message = '⏰ $medicineName expires in $daysDiff days (within 1 month)!';
        break;
      default:
        message = '';
    }

    if (message.isNotEmpty) {
      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'Medicine Expiry Alert',
        message,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'expiry_channel',
            'Medicine Expiry',
            channelDescription: 'Notifications for medicine expiry',
            importance: Importance.max,
            priority: Priority.high,
            color: Color(0xFF01D6A4),
            playSound: true,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
      await prefs.setBool(key, true);
    }
  }
}

