import 'package:flutter/material.dart';

class ImageUrlFieldEmpty extends StatelessWidget {
  final String hint;
  final String value;
  final String imageHint;
  final String imageUrl;
  final TextInputAction inputAction;
  final Color theme;
  final Function saveListener;
  final Function changeListener;
  final Function validator;

  ImageUrlFieldEmpty({
    @required this.hint,
    this.value,
    @required this.imageHint,
    @required this.imageUrl,
    @required this.theme,
    this.inputAction,
    this.saveListener,
    this.changeListener,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 100,
          height: 100,
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(border: Border.all(width: 1, color: theme)),
          child: imageUrl.isEmpty
              ? Text(imageHint, textAlign: TextAlign.center)
              : FittedBox(child: Image.network(imageUrl), fit: BoxFit.cover),
        ),
        Expanded(
          child: TextFormField(
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
            textInputAction:
                inputAction != null ? inputAction : TextInputAction.next,
            keyboardType: TextInputType.url,
            cursorColor: theme,
            style: TextStyle(fontSize: 16, color: Colors.black),
            onSaved: saveListener != null ? (text) => saveListener(text) : null,
            onChanged:
                changeListener != null ? (text) => changeListener(text) : null,
            validator: validator != null ? (text) => validator(text) : null,
          ),
        ),
      ],
    );
  }
}
