import 'package:flutter/material.dart';

class MaterialDialogYesNo extends StatelessWidget {
  final String title;
  final String body;
  final String positiveActionLabel;
  final Function positiveAction;
  final String negativeActionLabel;
  final Function negativeAction;

  MaterialDialogYesNo({
    this.title,
    this.body,
    this.positiveActionLabel,
    this.positiveAction,
    this.negativeActionLabel,
    this.negativeAction,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        FlatButton(
          onPressed: () => negativeAction(),
          child: Text(negativeActionLabel.toUpperCase()),
          textColor: Theme.of(context).primaryColor,
        ),
        FlatButton(
          onPressed: () => positiveAction(),
          child: Text(positiveActionLabel.toUpperCase()),
          textColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
