import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

abstract class NotificationHelper {
  // String token =
  //     "fnXWu8IETcWf8vJWE7P2Kc:APA91bGA1RPHeZMQrVGuBr5fY579BnZBL0tG_am1NNFV-myfh3CEB6myDAUzNSCyxuqkboEOTOVxf_nmYEdGxuvW44OkqQSpC3p2lHHGtJ_nuEBh47YEWAXyNcRhE9VqVkwWGicCcQ8G";

  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static void sendNotification({
    required String token,
    bool updateBlockedApps = false,
    bool refreshData = false,
    bool notification = true,
    List<String>? blockedApps,
  }) async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    await http
        .post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAA9S9xrdY:APA91bFZomn-A9WnrJUn1ePBYInqq9sp1oc4llAzHbHc_Z35dbJB2q60CjtZIaqVFDwguFtCtJa4iRZh00XblidhYjg-cLRbCAQLgC7e35B43FzmJtTgo1bTAQSjnLax-7Ke9urAth0f',
      },
      body: notification
          ? jsonEncode(
              <String, dynamic>{
                "to": token,
                "priority": "high",
                "notification": {
                  "title": "Notification from your parent",
                  "body": "Hey my child, have a good day",
                  "sound": "default"
                },
                "data": {
                  "click_action": "FLUTTER_NOTIFICATION_CLICK",
                  "updateBlockedApps": updateBlockedApps,
                  "refreshData": refreshData,
                  "blockedApps": blockedApps,
                }
              },
            )
          : jsonEncode(
              <String, dynamic>{
                "to": token,
                "priority": "high",
                // "notification": {
                //   "title": "Notification from your parent",
                //   "body": "Hey my child, have a good day",
                //   "sound": "default"
                // },
                "data": {
                  "click_action": "FLUTTER_NOTIFICATION_CLICK",
                  "updateBlockedApps": updateBlockedApps,
                  "refreshData": refreshData,
                  "blockedApps": blockedApps,
                }
              },
            ),
    )
        .catchError((error) {
      log("error");
      log(error.toString());
    });
    log('notification has been sent to $token');
  }
}
