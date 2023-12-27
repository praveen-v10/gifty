import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class FirebaseMessage{
 static final _fireBaseMessaging = FirebaseMessaging.instance;

  // request for notification

 static Future Init() async {
  await _fireBaseMessaging.requestPermission(
    alert: true,
    badge: true,
    announcement: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );


  final token = await  _fireBaseMessaging.getToken();
  print('token id $token');

}

}