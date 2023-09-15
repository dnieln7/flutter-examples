import 'package:flutter/material.dart';

class LongTextFieldEmpty extends StatelessWidget {
  final String hint;
  final String value;
  final Color theme;
  final Function saveListener;
  final Function changeListener;
  final Function validator;

  LongTextFieldEmpty({
    @required this.hint,
    this.value,
    @required this.theme,
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
      initialValue: value != null ? value : '',
      keyboardType: TextInputType.multiline,
      cursorColor: theme,
      style: TextStyle(fontSize: 16, color: Colors.black),
      minLines: 1,
      maxLines: 10,
      maxLength: 250,
      onSaved: saveListener != null ? (text) => saveListener(text) : null,
      onChanged: changeListener != null ? (text) => changeListener(text) : null,
      validator: validator != null ? (text) => validator(text) : null,
    );
  }
}
