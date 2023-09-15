import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final String hint;
  final Color theme;
  final String value;
  final bool hideText;
  final TextInputAction inputAction;
  final Function saveListener;
  final Function changeListener;
  final Function validator;

  PasswordField({
    @required this.hint,
    @required this.theme,
    this.value,
    @required this.hideText,
    this.inputAction,
    this.saveListener,
    this.changeListener,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: hint,
        alignLabelWithHint: true,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme),
        ),
      ),
      initialValue: value ?? '',
      textInputAction: inputAction ?? TextInputAction.next,
      keyboardType: TextInputType.visiblePassword,
      obscureText: hideText,
      cursorColor: theme,
      style: TextStyle(fontSize: 16, color: Colors.black),
      onSaved: saveListener != null ? (text) => saveListener(text) : null,
      onChanged: changeListener != null ? (text) => changeListener(text) : null,
      validator: validator != null ? (text) => validator(text) : null,
    );
  }
}
