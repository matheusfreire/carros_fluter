import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  String label;
  String hint;
  bool password;
  TextEditingController tController;
  FormFieldValidator<String> validator;
  TextInputType keyboardType;
  TextInputAction inputAction;
  FocusNode focusNode;
  FocusNode nextFocus;

  AppText(
    this.label,
    this.hint, {
    this.password = false,
    this.tController,
    this.validator,
    this.keyboardType,
    this.inputAction,
    this.focusNode,
    this.nextFocus,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: tController,
      obscureText: password,
      keyboardType: keyboardType,
      textInputAction: inputAction,
      focusNode: focusNode,
      onFieldSubmitted: (String text) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      style: TextStyle(
        color: Colors.blue,
        fontSize: 25,
      ),
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey,
            fontSize: 25,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 16,
          )),
    );
  }
}
