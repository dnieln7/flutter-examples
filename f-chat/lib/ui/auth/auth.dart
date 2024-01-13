import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_chat/utils/validation_utils.dart';
import 'package:f_chat/widget/banner_text.dart';
import 'package:f_chat/widget/email_field.dart';
import 'package:f_chat/widget/password_field.dart';
import 'package:f_chat/widget/profile_picker.dart';
import 'package:f_chat/widget/text_field_colored.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loginMode = true;
  bool working = false;
  bool showProfilePicker = false;

  String email;
  String username;
  String password;
  String password2;
  File profilePicture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color.fromARGB(255, 30, 30, 46),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/auth-background.png', fit: BoxFit.fill),
          SingleChildScrollView(
            child: Column(
              children: [
                AppBar(backgroundColor: Colors.transparent, elevation: 0),
                SizedBox(height: 20),
                BannerText(text: 'F-Chat'),
                Card(
                  elevation: 5,
                  margin: EdgeInsets.all(20),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Form(
                          key: formKey,
                          child: !showProfilePicker
                              ? createFormFields()
                              : Container(),
                        ),
                        if (showProfilePicker) ProfilePicker(setProfilePicture),
                        SizedBox(height: 20),
                        if (working)
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: CircularProgressIndicator(),
                          ),
                        if (!working) createButtons()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget createFormFields() {
    return Column(
      children: [
        EmailField(
          hint: 'Email',
          theme: Theme.of(context).primaryColor,
          changeListener: (text) => email = text,
          validator: (text) => ValidationUtils.validateEmail(text),
        ),
        if (!loginMode)
          TextFieldColored(
            hint: 'Username',
            theme: Theme.of(context).primaryColor,
            changeListener: (text) => username = text,
            validator: (text) => ValidationUtils.validateUsername(text),
          ),
        PasswordField(
          hint: 'Password',
          theme: Theme.of(context).primaryColor,
          changeListener: (text) => password = text,
          validator: (text) => ValidationUtils.validatePassword(text),
          hideText: true,
        ),
        if (!loginMode)
          PasswordField(
            hint: 'Confirm password',
            theme: Theme.of(context).primaryColor,
            changeListener: (text) => password2 = text,
            validator: (text) =>
                ValidationUtils.validatePasswordEquality(text, password),
            hideText: true,
          ),
      ],
    );
  }

  Widget createButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          child: Text(
            loginMode
                ? 'LOGIN'
                : showProfilePicker
                    ? 'CREATE ACCOUNT'
                    : 'SELECT PROFILE PICTURE',
          ),
          onPressed: showProfilePicker ? tryToLogin : toProfilePicker,
        ),
        if (showProfilePicker)
          TextButton(
            child: Text('BACK'),
            onPressed: toForm,
          ),
        if (!showProfilePicker)
          TextButton(
            child: Text(
              loginMode ? 'SIGN UP' : 'I HAVE AN ACCOUNT',
            ),
            onPressed: changeLoginMode,
          ),
      ],
    );
  }

  void toProfilePicker() {
    FocusScope.of(context).unfocus();

    if (formKey.currentState.validate()) {
      setState(() => showProfilePicker = true);
    }
  }

  void toForm() {
    setState(() => showProfilePicker = false);
  }

  void changeLoginMode() {
    setState(() => loginMode = !loginMode);
  }

  void setProfilePicture(File profilePicture) {
    setState(() => this.profilePicture = profilePicture);
  }

  Future<void> tryToLogin() async {
    setState(() => working = true);

    final auth = FirebaseAuth.instance;
    UserCredential userCredential;

    try {
      if (loginMode) {
        userCredential = await auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
      } else {
        if (profilePicture == null) {
          throw Exception('Please select a profile picture');
        }

        userCredential = await auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('users')
            .child('profile')
            .child(userCredential.user.uid + '.jpg');

        await ref.putFile(profilePicture).whenComplete(() => {});

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user.uid)
            .set(
                {'username': username, 'email': email, 'profile-picture': url});
      }
    } on PlatformException catch (error) {
      var message =
          error.message ?? 'An error occurred please check your credentials';

      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

      setState(() => working = false);
    } catch (error) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

      setState(() => working = false);
    }
  }
}
