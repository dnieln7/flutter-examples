import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:my_restaurant/data/graphql/employee_graphs.dart';
import 'package:my_restaurant/data/provider/session_provider.dart';
import 'package:my_restaurant/res/messages.dart';
import 'package:my_restaurant/res/strings.dart';
import 'package:my_restaurant/ui/drawer/drawer_app.dart';
import 'package:my_restaurant/ui/menu/daily_menu.dart';
import 'package:my_restaurant/utils/navigation_utils.dart';
import 'package:my_restaurant/utils/printer.dart';
import 'package:my_restaurant/widgets/input/password_field.dart';
import 'package:my_restaurant/widgets/input/text_field_empty.dart';
import 'package:my_restaurant/widgets/label/banner_label.dart';
import 'package:my_restaurant/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  final _key = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final bool _obscureText = true;
  bool working = false;

  String username;
  String password;

  @override
  void initState() {
    username = '';
    password = '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(title: Text(DrawerApp.employees)),
      drawer: DrawerApp(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 40),
        child: Column(
          children: [
            BannerLabel(Strings.appName, Theme.of(context).primaryColor),
            SizedBox(height: 40),
            Form(
              key: widget._key,
              child: Column(
                children: [
                  TextFieldEmpty(
                    hint: 'Username',
                    theme: Theme.of(context).primaryColor,
                    changeListener: (text) => setState(() => username = text),
                    validator: (text) => _getErrorMessage(text.isEmpty),
                  ),
                  SizedBox(height: 10),
                  PasswordField(
                    hint: 'Password',
                    hideText: _obscureText,
                    theme: Theme.of(context).primaryColor,
                    changeListener: (text) => setState(() => password = text),
                    validator: (text) => _getErrorMessage(text.isEmpty),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            if (working) CircularProgressIndicator(),
            if (!working)
              RoundedButton(
                label: 'Log in',
                theme: Theme.of(context).primaryColor,
                action: () => validateForm(),
                expanded: true,
              ),
          ],
        ),
      ),
    );
  }

  String _getErrorMessage(empty) {
    if (empty) {
      return 'This field is required';
    }
    return null;
  }

  void validateForm() {
    if (widget._key.currentState.validate()) {
      setState(() => working = true);

      var client = GraphQLProvider.of(context).value;
      final options = QueryOptions(
        document: gql(EmployeeGraphs.login),
        variables: {
          'auth': {'username': username, 'password': password}
        },
      );

      client.query(options).then((result) {
        if (result.hasException) {
          Printer.snackBar(widget._scaffoldKey, Messages.error);
        }

        var data = result.data['login'] as Map<String, dynamic>;

        if (data['successful'] as bool) {
          Provider.of<SessionProvider>(context, listen: false)
              .login(data['token'], data['role']);
          NavigationUtils.replace(context, DailyMenu());
        } else {
          Printer.snackBar(widget._scaffoldKey, data['message']);
        }
      }).catchError(
        (error) => Printer.snackBar(widget._scaffoldKey, Messages.error),
      );

      setState(() => working = false);
    }
  }
}
