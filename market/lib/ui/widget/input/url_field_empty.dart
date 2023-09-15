import 'package:flutter/material.dart';

class UrlFieldEmpty extends StatelessWidget {
  final String hint;
  final TextInputAction inputAction;
  final Color theme;
  final Function saveListener;
  final Function changeListener;
  final Function validator;

  UrlFieldEmpty({
    @required this.hint,
    @required this.theme,
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
      textInputAction: inputAction != null ? inputAction : TextInputAction.next,
      keyboardType: TextInputType.url,
      cursorColor: theme,
      style: TextStyle(fontSize: 16, color: Colors.black),
      onSaved: saveListener != null ? (text) => saveListener(text) : null,
      onChanged: changeListener != null ? (text) => changeListener(text) : null,
      validator: validator != null ? (text) => validator(text) : null,
    );
  }
}
