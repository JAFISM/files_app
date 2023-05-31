import 'package:files_app/constants.dart';
import 'package:flutter/material.dart';

import 'local_widget/sign_in_form.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Constants.Kbackground,
          elevation: 0,
          title: Text(
            "Login",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w500,
                color: Constants.Kprimary),
          ),
          bottom: AppBar(
            elevation: 0,
            backgroundColor: Constants.Kbackground,
            title: Text(
              "Welcome Back!",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  color: Constants.Kprimary),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Config.screenWidth! * 0.04),
          child: Column(
            children: [
              SizedBox(
                height: Config.screenHeight! * 0.06,
              ),
              // shows textfields and buttons
              SignInForm(),
            ],
          ),
        ),
      ),
    );
  }
}
