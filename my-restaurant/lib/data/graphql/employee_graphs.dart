class EmployeeGraphs {
  static const String login = '''
    query(\$auth:AuthIn!){
      login(auth:\$auth) {
        successful
        message
        token
        role
      }
    }
  ''';
}
