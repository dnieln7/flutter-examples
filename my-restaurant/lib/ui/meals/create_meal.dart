import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:my_restaurant/data/graphql/graphql_configuration.dart';
import 'package:my_restaurant/data/graphql/meal_graphs.dart';
import 'package:my_restaurant/res/messages.dart';
import 'package:my_restaurant/res/strings.dart';
import 'package:my_restaurant/utils/firebase_storage_helper.dart';
import 'package:my_restaurant/utils/image_utils.dart';
import 'package:my_restaurant/utils/printer.dart';
import 'package:my_restaurant/utils/validation_utils.dart';
import 'package:my_restaurant/widgets/dialog/material_dialog_neutral.dart';
import 'package:my_restaurant/widgets/input/image_avatar.dart';
import 'package:my_restaurant/widgets/input/long_text_field_empty.dart';
import 'package:my_restaurant/widgets/input/number_field_empty.dart';
import 'package:my_restaurant/widgets/input/selector_field_empty.dart';
import 'package:my_restaurant/widgets/input/text_field_empty.dart';
import 'package:my_restaurant/widgets/label/body_label.dart';

class CreateMeal extends StatefulWidget {
  final _key = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _CreateMealState createState() => _CreateMealState();
}

class _CreateMealState extends State<CreateMeal> {
  bool working = false;
  ImageSelectorUtils selector;
  File selectedPicture;

  String name;
  String description;
  String picture;
  double price;
  String type;

  @override
  void initState() {
    selector = ImageSelectorUtils(
      height: 480,
      width: 960,
      quality: 50,
      cameraListener: (file) => setState(() => selectedPicture = file),
      galleryListener: (file) => setState(() => selectedPicture = file),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(title: Text('Create meal')),
      floatingActionButton: working
          ? FloatingActionButton(
              onPressed: null,
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 2,
              ),
            )
          : FloatingActionButton(
              onPressed: () => validate(),
              child: Icon(Icons.save),
            ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: widget._key,
            child: Column(
              children: [
                ImageAvatar(
                  image: selectedPicture,
                  icon: Icons.add_a_photo,
                  theme: Theme.of(context).primaryColor,
                  themeAlt: Colors.black54,
                  selector: (context) => selector.showSelector(context),
                ),
                SizedBox(height: 20),
                TextFieldEmpty(
                  hint: 'Name *',
                  theme: Theme.of(context).primaryColor,
                  changeListener: (value) => setState(() => name = value),
                  validator: (text) => ValidationUtils.validateEmpty(text),
                ),
                SizedBox(height: 10),
                LongTextFieldEmpty(
                  hint: 'Description *',
                  theme: Theme.of(context).primaryColor,
                  changeListener: (value) =>
                      setState(() => description = value),
                  validator: (text) => ValidationUtils.validateEmpty(text),
                ),
                SizedBox(height: 10),
                NumberFieldEmpty(
                  hint: 'Price *',
                  theme: Theme.of(context).primaryColor,
                  changeListener: (value) =>
                      setState(() => price = double.parse(value)),
                  validator: (text) => ValidationUtils.validateEmpty(text),
                ),
                SizedBox(height: 10),
                SelectorFieldEmpty(
                  options: Strings.mealTypeSelector,
                  hint: 'Type *',
                  theme: Theme.of(context).primaryColor,
                  textListener: (value) => setState(() => type = value),
                  validator: (text) => ValidationUtils.validateEmpty(text),
                ),
                Container(
                  width: double.infinity,
                  child: BodyLabel('* Required fields'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validate() {
    if (selectedPicture == null) {
      Printer.snackBar(widget._scaffoldKey, Messages.noPicture);

      return;
    }

    if (widget._key.currentState.validate()) {
      setState(() => working = true);
      var fileName = 'meal_' +
          type +
          '_' +
          name +
          '_' +
          DateTime.now().toString().substring(0, 10);

      FirebaseStorageHelper(
        imageToUpload: selectedPicture,
        fileName: fileName,
        location: 'my-restaurant/meals/',
        onSuccess: (url) => {picture = url, createMeal()},
        onFailure: (_) => showErrorMessage(),
      ).uploadFile();
    }
  }

  void showDoneDialog() {
    showDialog(
      context: context,
      builder: (_) => MaterialDialogNeutral('', 'Meal successfully created.'),
    ).then((_) => Navigator.of(context).pop());
  }

  void showErrorMessage() {
    setState(() => working = false);
    Printer.snackBar(widget._scaffoldKey, Messages.error);
  }

  void createMeal() async {
    final meal = {
      'name': name,
      'description': description,
      'price': price,
      'picture': picture,
      'type': type,
    };

    final client = await GraphQLConfiguration.getAuthClient();
    final options = MutationOptions(
      document: gql(MealGraphs.post),
      variables: {'meal': meal},
    );
    final result = await client.mutate(options);

    if (result.hasException) {
      await Printer.showErrorDialog(context, result.exception);
      setState(() => working = false);
    } else {
      if (result.data['createMeal']['id'] != null) {
        showDoneDialog();
      }
    }
  }
}
