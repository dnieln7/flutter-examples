class MenuGraphs {
  static const String get = '''
    query {
      menu {
        entrances {
          name
          description
          picture
          price
          type
        }
        middles  {
          name
          description
          picture
          price
          type
        }
        stews  {
          name
          description
          picture
          price
          type
        }
        desserts  {
          name
          description
          picture
          price
          type
        }
        drinks
         {
          name
          description
          price
          picture
          type
        }
      }
    }
  ''';

  static const String post = '''
    mutation(\$menu:MenuIn!) {
      createMenu(menu: \$menu) {
        id
      }
    }
  ''';
}
