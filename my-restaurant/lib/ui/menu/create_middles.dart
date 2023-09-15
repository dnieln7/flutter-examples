import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:my_restaurant/data/graphql/meal_graphs.dart';
import 'package:my_restaurant/data/model/Meal.dart';
import 'package:my_restaurant/data/model/Menu.dart';
import 'package:my_restaurant/res/palette.dart';
import 'package:my_restaurant/ui/meals/create_meal.dart';
import 'package:my_restaurant/ui/menu/create_stews.dart';
import 'package:my_restaurant/utils/navigation_utils.dart';
import 'package:my_restaurant/utils/printer.dart';
import 'package:my_restaurant/widgets/no_items_message.dart';
import 'package:my_restaurant/widgets/tile/image_checkbox_tile.dart';

class CreateMiddles extends StatefulWidget {
  CreateMiddles(this.menu);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final Menu menu;

  @override
  _CreateMiddlesState createState() => _CreateMiddlesState();
}

class _CreateMiddlesState extends State<CreateMiddles> {
  final Map<int, Meal> selected = {};
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
        title: Text('Select middles'),
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
          : FloatingActionButton(
              child: Icon(Icons.arrow_forward),
              mini: true,
              onPressed: () => goNext(),
            ),
      body: createList(),
    );
  }

  void goNext() {
    if (selected.length <= 3) {
      widget.menu.middles = selected.values.toList();

      NavigationUtils.push(context, CreateStews(widget.menu));
    } else {
      Printer.snackBar(widget._scaffoldKey, 'You can only add up to 3 meals');
    }
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
    final viewMeals = meals.where((meal) => meal.type == 'Middle').toList();

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
}
