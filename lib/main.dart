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
import 'package:gift/previwePage.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'Home Page/home_page.dart';
import 'fireBaseMessage/fireBaseMessagePage.dart';
import 'fireBaseMessage/message.dart';


// notification functions
final navigatorKey = GlobalKey<NavigatorState>();


Future _firebaseBackgroundMessage(RemoteMessage message) async {

  String? title = message.notification!.title;
  String? body = message.notification!.body;

  AwesomeNotifications().createNotification(
      content:NotificationContent(
          id: 123,
          channelKey: 'key1',
        color: Colors.white,
        title: title,
        body: body,
        category: NotificationCategory.Message,
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
    NotificationActionButton(
      key: 'Decline',
      label: 'Decline Message',
      color: Colors.cyan,
      autoDismissible: true,
    )
  ]
  );
  }

// end here////

void main() async {
// notification////
  AwesomeNotifications().initialize(
      // 'resource://drawable/res_app_icon', [
    null,[
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'key1',
            channelName: 'key1',
            channelDescription: 'Channel Calling ',
          defaultColor: Colors.cyan,
          ledColor: Colors.white,
          importance: NotificationImportance.Default,
          // channelShowBadge: true,
          //   playSound: true,
          //locked: true,
          //defaultRingtoneType: DefaultRingtoneType.Alarm,


        )
  ],
     channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true
  );
              /// end here///
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


  //// notification  ////

  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  FirebaseMessage.Init();
  FirebaseMessaging.onBackgroundMessage((_firebaseBackgroundMessage));

  // end here//
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);


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
      //home: PreviewPage(),
      home: MEssaging(),
     // home: GiftOpenPage(),
    );
  }



}
