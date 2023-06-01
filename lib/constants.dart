import 'package:flutter/material.dart';

class Constants {
  static String apiKey = "AIzaSyBLfBGQ_QJgsTheKco2y8d0q_3xxpwmchI";
  static String authDomain = "filesapp-dea64.firebaseapp.com";
  static String appId = "1:884303056898:ios:448c3f77498dc328ed971b";
  static String messagingSenderId = "884303056898";
  static String projectId = "filesapp-dea64";
  static String storageBucket = "filesapp-dea64.appspot.com";
  static String measurementId = "G-BHJLHJHSXR";

  static Color Kprimary = Colors.deepPurple;
  static Color Ksecondary = Colors.purple.shade400;
  static Color Kbackground = Colors.white;
  static Color Kblack = Colors.black;
  static Color Dblack = const Color(0xff303030);
  // static Color c3=Color(0xffBFACE2);
}

class Config {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static Orientation? orientation;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    orientation = _mediaQueryData!.orientation;
  }
}
