import 'package:files_app/constants.dart';
import 'package:files_app/widgets/hero_title.dart';
import 'package:flutter/material.dart';

import '../../widgets/hero_image.dart';
import '../../widgets/round_textformfield.dart';
import 'local_widget/sign_in_button.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Config.init(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   //backgroundColor: Constants.Kbackground,
        //   elevation: 0,
        //   title: Text(
        //     "Login",
        //     style: TextStyle(
        //         fontSize: 40,
        //         fontWeight: FontWeight.w500,
        //         color: Constants.Kprimary),
        //   ),
        //   bottom: AppBar(
        //     elevation: 0,
        //     // backgroundColor: Constants.Kbackground,
        //     title: Text(
        //       "Welcome Back!",
        //       style: TextStyle(
        //           fontSize: 40,
        //           fontWeight: FontWeight.w500,
        //           color: Constants.Kprimary),
        //     ),
        //   ),
        // ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Config.screenWidth! * 0.04),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HeroTitle(title: "Login", subtitle: "Welcome Back!"),
                const HeroImage(
                    path: "assets/files_store_image.png", sementicLabel: ""),
                buildTextFormFields(),
                // shows textfields and buttons
                SignInButtons(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFormFields() {
    return Column(
      children: [
        RoundedTextFormField(
          controller: _emailController,
          hintText: 'Email',
          validator: (value) {
            bool _isEmailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value!);
            if (!_isEmailValid) {
              return 'Invalid email.';
            }
            return null;
          },
        ),
        SizedBox(height: Config.screenHeight! * 0.02),
        RoundedTextFormField(
          controller: _passwordController,
          hintText: 'Password',
          obsecureText: true,
          validator: (value) {
            if (value.toString().length < 6) {
              return 'Password should be longer or equal to 6 characters.';
            }
            return null;
          },
        ),
      ],
    );
  }
}
