import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:my_restaurant/widgets/dialog/material_dialog_neutral.dart';

class Printer {
  static void snackBar(scaffoldKey, message) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static Future<dynamic> showErrorDialog(
      context, OperationException exception) {
    if (exception.linkException != null &&
        exception.linkException is ServerException) {
      final serverException = exception.linkException as ServerException;
      final errors = serverException.parsedResponse.errors;
      final messages = <String>[];
      errors.forEach((item) => messages.add(item.message));

      return showDialog(
        context: context,
        builder: (ctx) => MaterialDialogNeutral(
          'An error has occurred',
          messages.toString(),
        ),
      );
    } else if (exception.graphqlErrors != null &&
        exception.graphqlErrors.isNotEmpty) {
      final messages = <String>[];
      exception.graphqlErrors.forEach((item) => messages.add(item.message));

      return showDialog(
        context: context,
        builder: (ctx) => MaterialDialogNeutral(
          'An error has occurred',
          messages.toString(),
        ),
      );
    }

    return showDialog(
      context: context,
      builder: (ctx) => MaterialDialogNeutral(
        'An error has occurred',
        exception.toString(),
      ),
    );
  }
}
