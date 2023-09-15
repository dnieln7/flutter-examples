class MealGraphs {
  static const String get = '''
    query {
      meals {
        id
        name
        description
        price
        picture
        type
      }
    }
    ''';

  static const String post = '''
    mutation(\$meal:MealIn!) {
      createMeal(meal: \$meal) {
        id
      }
    }
    ''';

  static const String delete = '''
    mutation(\$id: ID!) {
      deleteMeal(id: \$id) {
        successful
      }
    }
    ''';
}
