import 'package:files_app/controllerbinding.dart';
import 'package:files_app/screens/authentication/root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // run the initialization for the web
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId,
            authDomain: Constants.authDomain,
            storageBucket: Constants.storageBucket,
            measurementId: Constants.measurementId));
  } else {
    // run the initialization for the android , ios
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: ControllerBindings(),
      theme: ThemeData(),
      themeMode: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      //theme: ThemeData(primaryColor: Colors.deepPurple),
      home: const Root(),
    );
  }
}
