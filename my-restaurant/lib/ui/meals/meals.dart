import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:my_restaurant/data/graphql/graphql_configuration.dart';
import 'package:my_restaurant/data/graphql/meal_graphs.dart';
import 'package:my_restaurant/data/model/Meal.dart';
import 'package:my_restaurant/res/messages.dart';
import 'package:my_restaurant/ui/drawer/drawer_app.dart';
import 'package:my_restaurant/ui/meals/create_meal.dart';
import 'package:my_restaurant/ui/meals/meal_detail.dart';
import 'package:my_restaurant/utils/navigation_utils.dart';
import 'package:my_restaurant/utils/printer.dart';
import 'package:my_restaurant/widgets/dialog/material_dialog_yes_no.dart';
import 'package:my_restaurant/widgets/no_items_message.dart';
import 'package:my_restaurant/widgets/tile/delete_touchable_list_tile.dart';

class Meals extends StatefulWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _MealsState createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  Function refetch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(title: Text(DrawerApp.meals)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            NavigationUtils.push(context, CreateMeal()).then((_) => refetch()),
      ),
      drawer: DrawerApp(),
      body: createList(),
    );
  }

  Widget createList() {
    return Query(
      options: QueryOptions(
        document: gql(MealGraphs.get),
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.hasException) {
          return RefreshIndicator(
            onRefresh: refetch,
            child: SingleChildScrollView(
              child: NoItemsMessage(
                title: 'Error',
                subtitle: result.exception.toString(),
                icon: Icons.error,
              ),
            ),
          );
        }

        if (result.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        var data = result.data['meals'] as List<Object>;
        var meals = List<Meal>.from(data.map((item) => Meal.createMeal(item)));

        this.refetch = refetch;

        if (meals.isEmpty) {
          return RefreshIndicator(
            onRefresh: refetch,
            child: SingleChildScrollView(
              child: NoItemsMessage(
                title: 'No meals',
                subtitle: 'There are no meals, start adding some!',
                icon: Icons.no_meals,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: refetch,
          child: ListView.builder(
            itemBuilder: (context, index) => DeleteTouchableListTile(
              image: meals[index].picture,
              title: meals[index].name,
              subtitle: meals[index].type,
              touchAction: () => NavigationUtils.push(
                context,
                MealDetail(meals[index]),
              ),
              deleteAction: () => showDeleteDialog(meals[index], refetch),
            ),
            itemCount: meals.length,
          ),
        );
      },
    );
  }

  void showDeleteDialog(Meal meal, Function refetch) {
    showDialog(
      context: context,
      builder: (_) => MaterialDialogYesNo(
        title: 'Delete meal',
        body: 'This will delete the meal ${meal.name} forever.',
        positiveActionLabel: 'Delete',
        positiveAction: () =>
            {deleteMeal(meal.id), Navigator.of(context).pop(), refetch()},
        negativeActionLabel: 'Cancel',
        negativeAction: () => Navigator.of(context).pop(),
      ),
    );
  }

  void deleteMeal(int id) async {
    QueryResult result;
    final client = await GraphQLConfiguration.getAuthClient();
    final options = MutationOptions(
      document: gql(MealGraphs.delete),
      variables: {'id': id},
    );

    result = await client.mutate(options);

    if (result.hasException) {
      await Printer.showErrorDialog(context, result.exception);
    }
  }

  void showErrorMessage() {
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text(Messages.errorSession)),
    );
  }
}
