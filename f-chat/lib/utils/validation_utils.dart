class ValidationUtils {
  static String validateEmail(String text) {
    RegExp regex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );

    if (text.isEmpty || !regex.hasMatch(text)) {
      return 'Please enter a valid email!';
    }

    return null;
  }

  static String validateUsername(String text) {
    if(text.isEmpty) {
      return 'Please enter a username!';
    }

    return null;
  }

  static String validatePassword(String text) {
    if(text.isEmpty || text.length < 7) {
      return 'Password must be a least 7 characters long!';
    }

    return null;
  }

  static String validatePasswordEquality(String text, String toCompareAgainst) {
    if(text != toCompareAgainst) {
      return 'Passwords must match!';
    }

    return null;
  }
}