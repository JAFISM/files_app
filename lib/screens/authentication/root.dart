import 'package:files_app/constants.dart';
import 'package:files_app/screens/sign_in/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../home/home.dart';

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Config.init(context);

    return Scaffold(
      backgroundColor: Constants.Kbackground,
      body: GetBuilder<AuthController>(
        builder: (_) {
          return SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Config.screenWidth! * 0.04),
                child: _.isSignedIn.value ? Home() : SignIn()),
          );
        },
      ),
    );
  }
}
// }
