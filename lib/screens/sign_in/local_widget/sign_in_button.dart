import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controller/auth_controller.dart';
import '../../../widgets/rounded_elevatedbutton.dart';
import '../../../widgets/text_with_text_button.dart';
import '../../authentication/reset_password/reset_password.dart';
import '../../sign_up/sign_up.dart';

class SignInButtons extends StatelessWidget {
  const SignInButtons({
    Key? key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  })  : _formKey = formKey,
        _emailController = emailController,
        _passwordController = passwordController,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    final _authController = Get.find<AuthController>();

    return Expanded(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: Config.screenHeight! * 0.002),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Constants.Kprimary),
                ),
                onPressed: () => Get.to(() => ResetPassword()),
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent),
                ),
              ),
            ),
          ),
          RoundedElevatedButton(
            title: 'Sign in',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                String email = _emailController.text.trim();
                String password = _passwordController.text;

                _authController.signIn(email, password);
              }
            },
            padding: EdgeInsets.symmetric(
              horizontal: Config.screenWidth! * 0.2,
              vertical: Config.screenHeight! * 0.002,
            ),
          ),
          // SizedBox(height: Config.screenHeight! * 0.00),
          ElevatedButton.icon(
            icon: Icon(FontAwesomeIcons.google),
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Constants.Kprimary)),
            onPressed: () => _authController.signInWithGoogle(),
            label: Text("Login With Google"),
          ),
          TextWithTextButton(
            text: 'Don\'t have an account?',
            textButtonText: 'Sign up',
            onPressed: () => Get.to(() => SignUp()),
          ),
        ],
      ),
    );
  }
}
