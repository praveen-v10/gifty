import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gift/fireBaseMessage/fireBaseMessagePage.dart';


class MEssaging extends StatefulWidget {


   MEssaging({super.key});

  @override
  State<MEssaging> createState() => _MEssagingState();
}

class _MEssagingState extends State<MEssaging> {


  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      if (message != null && message.notification != null) {
        String? title = message.notification!.title;
        String? body = message.notification!.body;

        AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 123,
              channelKey: 'Call Channel',
              color: Colors.white,
              title: title,
              body: body,
              category: NotificationCategory.Call,
              wakeUpScreen: true,
              fullScreenIntent: true,
              autoDismissible: false,
              backgroundColor: Colors.orange,

            ),
            actionButtons: [
              NotificationActionButton(
                key: 'Accept',
                label: 'Accept Message',
                color: Colors.cyan,
                autoDismissible: true,
              ),
            ]
        );
      }

    }

    );

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final data = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Text'),
      ),
      body: Row(
        children: [
          InkWell(
            onTap: () async {
              sendAndroidNotification();
              String? token = await FirebaseMessaging.instance.getToken();
              print(token);
            },
            child: Container(

            )
          )
        ],
      )
    );
  }


  Future<void> sendAndroidNotification() async {
    try {
      http.Response response = await http.post(
        Uri.parse('http://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=AAAAV_MGAVc:APA91bGntZ-w9i45A0Vg6Hj_YaPomgrS9LeQxidpdSFvSEwNBCah8kiHtn1-qaM2V2JUF2EwE2wpbNJV_VbXnQ4wHrWkBPIq_axJatQ8i_1Z_dL79Q47ivcqjScSS-M_9dlXifFQQLTZ',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'Hello',
              'title': 'Notification',
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': 'emq1i0RRRLSqGPu11QKX4E:APA91bFMPpZ2xEMj07F1-_caOt-QwLjuWfsCDHqMAliRL2ruEYuviGn-gGPsu1ODYR3TAUQtHJZxTjJ6bG_CG5QDeU-MBrEkug1nqNgPUEwdoq_g9Qb0QXNnj18sSJQttCqkIrmn8iHH',
            //'token': 'ch87wazdQLaeYJPsIuapbL:APA91bHoULORpXLiEFxyURnyZ3mLHqz9SP3mhBDLqPJOwRQE9wOAeTP3sUlEczDYv50fLeHaoRfwj4rdbjN3h9tpibaoe5DNTzAHqL9j0g54oxo1vS1-MT-nCfXphsCKdqQPEs34zAxQ'
          },
        ),
      );
      response;
    } catch (e) {
      e;
    }
  }

}
