import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:my_restaurant/data/graphql/graphql_configuration.dart';
import 'package:my_restaurant/data/graphql/meal_graphs.dart';
import 'package:my_restaurant/data/graphql/menu_graphs.dart';
import 'package:my_restaurant/data/model/Meal.dart';
import 'package:my_restaurant/data/model/Menu.dart';
import 'package:my_restaurant/res/palette.dart';
import 'package:my_restaurant/ui/meals/create_meal.dart';
import 'package:my_restaurant/ui/menu/daily_menu.dart';
import 'package:my_restaurant/utils/navigation_utils.dart';
import 'package:my_restaurant/utils/printer.dart';
import 'package:my_restaurant/widgets/dialog/material_dialog_neutral.dart';
import 'package:my_restaurant/widgets/no_items_message.dart';
import 'package:my_restaurant/widgets/tile/image_checkbox_tile.dart';

class CreateDrinks extends StatefulWidget {
  CreateDrinks(this.menu);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final Menu menu;

  @override
  _CreateDrinksState createState() => _CreateDrinksState();
}

class _CreateDrinksState extends State<CreateDrinks> {
  final Map<int, Meal> selected = {};
  bool working = false;
  QueryResult result;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) => fetchMeals());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(
        title: Text('Select drinks'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => NavigationUtils.push(context, CreateMeal())
                .then((_) => fetchMeals()),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selected.isEmpty
          ? Container()
          : working
              ? FloatingActionButton(
                  onPressed: null,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : FloatingActionButton(
                  onPressed: () => publishMenu(),
                  child: Icon(Icons.save),
                ),
      body: createList(),
    );
  }

  Widget createList() {
    if (result == null) {
      return Center(child: CircularProgressIndicator());
    }

    if (result.hasException) {
      return NoItemsMessage(
        title: 'Error',
        subtitle: result.exception.toString(),
        icon: Icons.error_outline,
      );
    }

    final data = result.data['meals'] as List<Object>;
    final meals = List<Meal>.from(data.map((item) => Meal.createMeal(item)));
    final viewMeals = meals.where((meal) => meal.type == 'Drink').toList();

    if (viewMeals.isEmpty) {
      return NoItemsMessage(
        title: 'No meals',
        subtitle: 'There are no meals, start adding some!',
        icon: Icons.no_meals,
      );
    }

    return RefreshIndicator(
      onRefresh: fetchMeals,
      child: ListView.builder(
        itemBuilder: (context, index) => ImageCheckboxTile(
          title: viewMeals[index].name,
          imageUrl: viewMeals[index].picture,
          checkedColor: Palette.success,
          isChecked: selected.containsKey(viewMeals[index].id),
          checkListener: (value) => modifySelected(viewMeals[index]),
        ),
        itemCount: viewMeals.length,
      ),
    );
  }

  void modifySelected(Meal meal) {
    if (selected.containsKey(meal.id)) {
      setState(() => selected.removeWhere((key, value) => key == meal.id));
    } else {
      setState(() => selected.putIfAbsent(meal.id, () => meal));
    }
  }

  Future<QueryResult> fetchMeals() async {
    setState(() => {this.result = null, selected.clear()});

    final client = GraphQLProvider.of(context).value;
    final options = QueryOptions(
      document: gql(MealGraphs.get),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    final result = await client.query(options);

    setState(() => this.result = result);

    return result;
  }

  void publishMenu() async {
    if (selected.length <= 3) {
      setState(() => working = true);

      widget.menu.drinks = selected.values.toList();

      final entrances = widget.menu.entrances
          .map((item) => {
                'name': item.name,
                'description': item.description,
                'price': item.price,
                'picture': item.picture,
                'type': item.type,
              })
          .toList();

      final middles = widget.menu.middles
          .map((item) => {
                'name': item.name,
                'description': item.description,
                'price': item.price,
                'picture': item.picture,
                'type': item.type,
              })
          .toList();

      final stews = widget.menu.stews
          .map((item) => {
                'name': item.name,
                'description': item.description,
                'price': item.price,
                'picture': item.picture,
                'type': item.type,
              })
          .toList();

      final desserts = widget.menu.desserts
          .map((item) => {
                'name': item.name,
                'description': item.description,
                'price': item.price,
                'picture': item.picture,
                'type': item.type,
              })
          .toList();

      final drinks = widget.menu.drinks
          .map((item) => {
                'name': item.name,
                'description': item.description,
                'price': item.price,
                'picture': item.picture,
                'type': item.type,
              })
          .toList();

      final client = await GraphQLConfiguration.getAuthClient();
      final options = MutationOptions(
        document: gql(MenuGraphs.post),
        variables: {
          'menu': {
            'entrances': entrances,
            'middles': middles,
            'stews': stews,
            'desserts': desserts,
            'drinks': drinks,
          },
        },
      );
      final result = await client.mutate(options);

      if (result.hasException) {
        await Printer.showErrorDialog(context, result.exception);
        setState(() => working = false);
      } else {
        if (result.data['createMenu']['id'] != null) {
          showDoneDialog();
        }
      }
    } else {
      Printer.snackBar(widget._scaffoldKey, 'You can only add up to 3 meals');
    }
  }

  void showDoneDialog() {
    showDialog(
      context: context,
      builder: (_) =>
          MaterialDialogNeutral('', 'Today\'s menu has been published.'),
    ).then((_) => NavigationUtils.popAndReplace(context, DailyMenu()));
  }
}
