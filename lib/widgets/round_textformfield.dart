import 'package:flutter/material.dart';

class RoundedTextFormField extends StatelessWidget {
  const RoundedTextFormField({
    Key? key,
    this.controller,
    this.obsecureText = false,
    @required this.hintText,
    this.validator,
  }) : super(key: key);

  final TextEditingController? controller;
  final bool? obsecureText;
  final String? hintText;
  final validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsecureText!,
      decoration: InputDecoration(
        hintText: hintText!,
        focusedBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.deepPurple),
          borderRadius: const BorderRadius.all(
            const Radius.circular(30.0),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.deepPurple),
          borderRadius: const BorderRadius.all(
            const Radius.circular(30.0),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: const BorderRadius.all(
            const Radius.circular(30.0),
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: const BorderRadius.all(
            const Radius.circular(30.0),
          ),
        ),
      ),
      validator: validator,
    );
  }
}
