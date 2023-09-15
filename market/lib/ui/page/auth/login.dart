import 'package:flutter/material.dart';
import 'package:market/data/enum/AuthMode.dart';
import 'package:market/data/model/Auth.dart';
import 'package:market/ui/widget/banner_leaned.dart';
import 'package:market/ui/widget/dialog/material_dialog_neutral.dart';
import 'package:market/ui/widget/input/email_field.dart';
import 'package:market/ui/widget/input/password_field.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  static const path = '/login';

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).viewPadding.top + 20;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.7),
                  Theme.of(context).accentColor.withOpacity(0.7)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          if (isPortrait)
            ListView(
              children: [
                SizedBox(height: statusBarHeight),
                BannerLeaned(text: 'Market', font: 'Anton'),
                AuthCard(),
              ],
            ),
          if (!isPortrait)
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(height: statusBarHeight),
                  Row(
                    children: [
                      BannerLeaned(text: 'Market', font: 'Anton'),
                      Expanded(child: AuthCard()),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var working = false;
  var mode = AuthMode.Login;

  AnimationController animationController;
  Animation<Size> heightAnimation;
  AnimationController opacityController;
  Animation<double> opacityAnimation;
  Animation<Offset> offSetAnimation;

  String email;
  String password;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    heightAnimation = Tween<Size>(
      begin: Size(double.infinity, 360),
      end: Size(double.infinity, 450),
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.linear),
    );

    opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );

    offSetAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );

    // heightAnimation.addListener(() => setState(() => {}));
    super.initState();
  }

  @override
  void dispose() {
    // animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: heightAnimation,
      builder: (context, reusable) => Container(
        height: heightAnimation.value.height,
        child: reusable,
      ),
      child: Card(
        margin: EdgeInsets.all(20),
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EmailField(
                  hint: 'E-Mail',
                  theme: Theme.of(context).primaryColor,
                  validator: (text) => validateEmail(text),
                  saveListener: (text) => email = text,
                ),
                PasswordField(
                  hint: 'Password',
                  theme: Theme.of(context).primaryColor,
                  hideText: true,
                  validator: (text) => validatePassword(text),
                  changeListener: (text) => password = text,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                    minHeight: mode == AuthMode.SignUp ? 60 : 0,
                    maxHeight: mode == AuthMode.SignUp ? 120 : 0,
                  ),
                  child: FadeTransition(
                    opacity: opacityAnimation,
                    child: PasswordField(
                      hint: 'Confirm Password',
                      theme: Theme.of(context).primaryColor,
                      hideText: true,
                      validator: (text) => validateConfirmPassword(text),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (working)
                  CircularProgressIndicator()
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        child: Text(
                          mode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',
                        ),
                        onPressed: submit,
                      ),
                      TextButton(
                        child: Text(
                          '${mode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                        ),
                        onPressed: switchAuthMode,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() => working = true);

    _formKey.currentState.save();

    if (mode == AuthMode.Login) {
      Provider.of<Auth>(context, listen: false)
          .login(email, password)
          .then((_) => setState(() => working = false))
          .catchError((error) => showErrorDialog(error.toString()));
    } else {
      Provider.of<Auth>(context, listen: false)
          .signUp(email, password)
          .then((_) => setState(() => working = false))
          .catchError((error) => showErrorDialog(error.toString()));
    }
  }

  void switchAuthMode() {
    if (mode == AuthMode.Login) {
      setState(() {
        mode = AuthMode.SignUp;
      });

      animationController.forward();
    } else {
      setState(() {
        mode = AuthMode.Login;
      });

      animationController.reverse();
    }
  }

  void showErrorDialog(String message) {
    String body = message.replaceAll('_', ' ');

    showDialog(
      context: context,
      builder: (ctx) => MaterialDialogNeutral('An error occurred', body),
    ).then((_) => setState(() => working = false));
  }

  String validateEmail(String text) {
    RegExp regex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );

    if (text.isEmpty || !regex.hasMatch(text)) {
      return 'Invalid email!';
    }

    return null;
  }

  String validatePassword(String text) {
    if (text.isEmpty || text.length < 6) {
      return 'Password is too short!';
    }

    return null;
  }

  String validateConfirmPassword(String text) {
    if (mode == AuthMode.SignUp) {
      if (text.isEmpty || text.length < 6) {
        return 'Password is too short!';
      }
      if (text != password) {
        return 'Passwords do not match!';
      }
    }

    return null;
  }
}
