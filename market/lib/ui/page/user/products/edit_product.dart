import 'package:flutter/material.dart';
import 'package:market/data/model/Product.dart';
import 'package:market/data/provider/ProductProvider.dart';
import 'package:market/ui/widget/dialog/material_dialog_neutral.dart';
import 'package:market/ui/widget/input/image_url_field_empty.dart';
import 'package:market/ui/widget/input/long_text_field_empty.dart';
import 'package:market/ui/widget/input/number_field_empty.dart';
import 'package:market/ui/widget/input/text_field_colored.dart';
import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {
  static const path = 'user/products/edit';

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final GlobalKey<FormState> formKey = GlobalKey();
  bool firstLoad = true;
  bool working = false;

  String id;
  String title;
  String description;
  double price;
  String image;
  bool isFavorite;

  @override
  void initState() {
    id = '';
    title = '';
    description = '';
    price = 0.0;
    image = '';
    isFavorite = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (firstLoad) {
      String productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        Product toEdit = Provider.of<ProductProvider>(context, listen: false)
            .findById(productId);

        id = toEdit.id;
        title = toEdit.title;
        description = toEdit.description;
        price = toEdit.price;
        image = toEdit.image;
        isFavorite = toEdit.isFavorite;
      }

      firstLoad = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: id.isEmpty ? Text('Create product') : Text('Edit product'),
        actions: [
          if (working)
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 10),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
                strokeWidth: 2,
              ),
            ),
          if (!working)
            IconButton(
              icon: Icon(Icons.save_outlined),
              onPressed: () => save(),
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFieldColored(
                  hint: 'Title',
                  value: title,
                  theme: Theme.of(context).primaryColor,
                  saveListener: (text) => setState(() => title = text),
                  validator: (text) => validateText(text),
                ),
                NumberFieldEmpty(
                  hint: 'Price',
                  value: price.toString(),
                  theme: Theme.of(context).primaryColor,
                  saveListener: (text) =>
                      setState(() => price = double.parse(text)),
                  validator: (text) => validateNumber(text),
                ),
                LongTextFieldEmpty(
                  hint: 'Description',
                  value: description,
                  theme: Theme.of(context).primaryColor,
                  saveListener: (text) => setState(() => description = text),
                  validator: (text) => validateText(text),
                ),
                SizedBox(height: 10),
                ImageUrlFieldEmpty(
                  hint: 'Image URL',
                  value: image,
                  imageHint: 'Enter URL',
                  imageUrl: image,
                  theme: Theme.of(context).primaryColor,
                  inputAction: TextInputAction.done,
                  changeListener: (text) => setState(() => image = text),
                  validator: (text) => validateUrl(text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void save() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      setState(() => working = true);

      final p = Product(
        id: id,
        title: title,
        description: description,
        price: price,
        image: image,
      );

      if (id.isEmpty) {
        Provider.of<ProductProvider>(context, listen: false)
            .add(p)
            .then((_) => Navigator.of(context).pop())
            .catchError((error) => showErrorDialog(error));
      } else {
        Provider.of<ProductProvider>(context, listen: false)
            .update(p)
            .then((_) => Navigator.of(context).pop())
            .catchError((error) => showErrorDialog(error));
      }
    }
  }

  String validateUrl(String text) {
    if (text.startsWith('http') || text.startsWith('https')) {
      return null;
    }

    return 'Please enter a valid url';
  }

  String validateText(String text) {
    if (text.isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  String validateNumber(String text) {
    if (double.tryParse(text) == null) {
      return 'Only numbers are allowed here';
    }
    if (double.parse(text) <= 0) {
      return 'The price cannot be 0 or less';
    }

    return null;
  }

  void showErrorDialog(error) {
    showDialog(
      context: context,
      builder: (ctx) => MaterialDialogNeutral(
        "An error occurred",
        error.toString(),
      ),
    ).then((_) => setState(() => working = false));
  }
}
