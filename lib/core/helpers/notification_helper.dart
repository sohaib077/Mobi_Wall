import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

abstract class NotificationHelper {
  // String token =
  //     "fnXWu8IETcWf8vJWE7P2Kc:APA91bGA1RPHeZMQrVGuBr5fY579BnZBL0tG_am1NNFV-myfh3CEB6myDAUzNSCyxuqkboEOTOVxf_nmYEdGxuvW44OkqQSpC3p2lHHGtJ_nuEBh47YEWAXyNcRhE9VqVkwWGicCcQ8G";

  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<String> _getAccessToken() async {
    final jsonString = await rootBundle.loadString(
        'assets/notifications_key/mobiwall-43f95-ca076616cced.json');

    final accountCredentials =
        auth.ServiceAccountCredentials.fromJson(jsonString);

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final client =
        await auth.clientViaServiceAccount(accountCredentials, scopes);

    return client.credentials.accessToken.data;
  }

  static void sendNotification({
    required String token,
    bool updateBlockedApps = false,
    bool refreshData = false,
    bool notification = true,
    List<String>? blockedApps,
  }) async {
    final String accessToken = await _getAccessToken();
    const String fcmUrl =
        "https://fcm.googleapis.com/v1/projects/mobiwall-43f95/messages:send";

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

    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: notification
          ? jsonEncode(<String, dynamic>{
              'message': {
                'token': token,
                'notification': {
                  'title': "Notification from your parent",
                  'body': 'Have a good day my boy',
                },
                'android': {
                  'notification': {
                    "sound": "default",
                    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                    'channel_id': 'high_importance_channel'
                  },
                },
              },
            })
          : jsonEncode(<String, dynamic>{
              'message': {
                'token': token,
                'data': {
                  'updateBlockedApps': updateBlockedApps.toString(),
                  'refreshData': refreshData.toString(),
                  'blockedApps': blockedApps.toString(),
                },
              },
            }),
    );

    if (response.statusCode == 200) {
      log('Notification sent successfully');
    } else {
      log('Failed to send notification: ${response.body}');
    }

    // await http
    //     .post(
    //   Uri.parse(
    //       "https://fcm.googleapis.com/v1/projects/mobiwall-43f95/messages:send"),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json',
    //     'Authorization': 'Bearer $accessToken',
    //   },
    //   body: notification
    //       ? jsonEncode(
    //           <String, dynamic>{
    //             "to": token,
    //             "priority": "high",
    //             "notification": {
    //               "title": "Notification from your parent",
    //               "body": "Hey my child, have a good day",
    //               "sound": "default"
    //             },
    //             "data": {
    //               "click_action": "FLUTTER_NOTIFICATION_CLICK",
    //               "updateBlockedApps": updateBlockedApps,
    //               "refreshData": refreshData,
    //               "blockedApps": blockedApps,
    //             }
    //           },
    //         )
    //       : jsonEncode(
    //           <String, dynamic>{
    //             "to": token,
    //             "priority": "high",
    //             // "notification": {
    //             //   "title": "Notification from your parent",
    //             //   "body": "Hey my child, have a good day",
    //             //   "sound": "default"
    //             // },
    //             "data": {
    //               "click_action": "FLUTTER_NOTIFICATION_CLICK",
    //               "updateBlockedApps": updateBlockedApps,
    //               "refreshData": refreshData,
    //               "blockedApps": blockedApps,
    //             }
    //           },
    //         ),
    // ).then((value) {
    //   log('value = ${value.statusCode}');
    //   log('value = ${value.body}');
    // log('notification has been sent to $token');
    // })
    //     .catchError((error) {
    //   log("error");
    //   log(error.toString());
    // });
  }
}
