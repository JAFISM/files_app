import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../constants.dart';
import '../../../widgets/hero_image.dart';
import '../../../widgets/hero_title.dart';
import 'local_widget/reset_form.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Config.screenWidth! * 0.04),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
            ),
            const HeroTitle(
                title: 'Recovery', subtitle: 'Please enter you account email'),
            SizedBox(height: Config.screenHeight! * 0.05),
            const HeroImage(
                path: 'assets/files_store_image.png',
                sementicLabel: 'Reset Hero'),
            SizedBox(height: Config.screenHeight! * 0.05),
            const ResetForm(),
            SizedBox(height: Config.screenHeight! * 0.2),
          ],
        ),
      )),
    );
  }
}
