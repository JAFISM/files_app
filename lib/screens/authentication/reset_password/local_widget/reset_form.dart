import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants.dart';
import '../../../../controller/auth_controller.dart';
import '../../../../widgets/round_textformfield.dart';

class ResetForm extends StatelessWidget {
  const ResetForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();

    final _authController = Get.find<AuthController>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          RoundedTextFormField(
            hintText: 'Email',
            controller: _emailController,
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
          SizedBox(height: Config.screenHeight! * 0.03),
          ElevatedButton(
            style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                    Size(double.infinity, Config.screenHeight! * 0.05)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Constants.Kprimary)),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _authController.resetPassword(_emailController.text.trim());
              }
            },
            child: Text("Reset Password"),
          ),
        ],
      ),
    );
  }
}
