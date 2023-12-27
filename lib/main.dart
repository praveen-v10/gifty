import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:gift/cartPage/cart_icon.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'fireBaseMessage/fireBaseMessagePage.dart';
import 'fireBaseMessage/message.dart';



final navigatorKey = GlobalKey<NavigatorState>();


Future _firebaseBackgroundMessage(RemoteMessage message) async {

  String? title = message.notification!.title;
  String? body = message.notification!.body;

  AwesomeNotifications().createNotification(
      content:NotificationContent(
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
    )
  ]
  );
  }



void main() async {

  AwesomeNotifications().initialize(
      appFlavor, [
        NotificationChannel(
            channelKey: 'call_channel',
            channelName: 'Call Channel',
            channelDescription: 'Channel Calling ',
          defaultColor: Colors.cyan,
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          locked: true,
          defaultRingtoneType: DefaultRingtoneType.Ringtone

        )
  ]
  );
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();

  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   if(message.notification != null){
  //     print('Background Tapped');
  //     navigatorKey.currentState!.pushNamed('/message',arguments: message);
  //   }
  // });
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  FirebaseMessage.Init();
  FirebaseMessaging.onBackgroundMessage((_firebaseBackgroundMessage));
  runApp( MyApp());
}


class MyApp extends StatelessWidget {
   MyApp({super.key});

  // This widget is the root of your application.





  @override
  Widget build(BuildContext context) {

    return  GetMaterialApp(
     navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Gifty',
      home: CartPageIcon(),
      //home: HomePage(),
     // home: GiftOpenPage(),
    );
  }



}
