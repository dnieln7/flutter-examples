import 'package:flutter/material.dart';
import 'package:my_restaurant/data/provider/cart_provider.dart';
import 'package:my_restaurant/res/palette.dart';
import 'package:my_restaurant/ui/cart/pay_confirm.dart';
import 'package:my_restaurant/utils/navigation_utils.dart';
import 'package:my_restaurant/widgets/input/long_text_field_empty.dart';
import 'package:my_restaurant/widgets/input/number_field_empty.dart';
import 'package:my_restaurant/widgets/input/phone_field_empty.dart';
import 'package:my_restaurant/widgets/input/text_field_empty.dart';
import 'package:my_restaurant/widgets/label/body_label.dart';
import 'package:my_restaurant/widgets/label/sub_title_label.dart';
import 'package:provider/provider.dart';

class PayDetails extends StatefulWidget {
  final _key = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _PayDetailsState createState() => _PayDetailsState();
}

class _PayDetailsState extends State<PayDetails> {
  String name;
  String phone;
  String extras;
  String comments;
  String street;
  String city;
  String pc;
  String references;
  bool delivery = false;

  @override
  void initState() {
    name = '';
    phone = '';
    extras = '';
    comments = '';
    street = '';
    city = '';
    pc = '';
    references = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(title: Text('Order details')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: () => validateForm(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: widget._key,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubTitleLabel('Please enter your contact details'),
                TextFieldEmpty(
                  hint: 'Name *',
                  theme: Theme.of(context).primaryColor,
                  changeListener: (value) => setState(() => name = value),
                  validator: (text) => _getErrorMessage(text.isEmpty),
                ),
                PhoneFieldEmpty(
                  hint: 'Phone *',
                  theme: Theme.of(context).primaryColor,
                  textListener: (value) => setState(() => phone = value),
                  validator: (text) => _getErrorMessage(text.isEmpty),
                ),
                LongTextFieldEmpty(
                  hint: 'Extras',
                  theme: Theme.of(context).primaryColor,
                  changeListener: (value) => setState(() => extras = value),
                ),
                LongTextFieldEmpty(
                  hint: 'Comments',
                  theme: Theme.of(context).primaryColor,
                  changeListener: (value) => setState(() => comments = value),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: delivery,
                      activeColor: Palette.success,
                      onChanged: (value) => setState(() => delivery = value),
                    ),
                    Text(('I want to eat at home')),
                  ],
                ),
                if (delivery)
                  SubTitleLabel('Please enter your address details'),
                if (delivery)
                  TextFieldEmpty(
                    hint: 'Street *',
                    theme: Theme.of(context).primaryColor,
                    changeListener: (value) => setState(() => street = value),
                    validator: (text) => _getErrorMessage(text.isEmpty),
                  ),
                if (delivery)
                  TextFieldEmpty(
                    hint: 'City *',
                    theme: Theme.of(context).primaryColor,
                    changeListener: (value) => setState(() => city = value),
                    validator: (text) => _getErrorMessage(text.isEmpty),
                  ),
                if (delivery)
                  NumberFieldEmpty(
                    hint: 'Postal Code *',
                    theme: Theme.of(context).primaryColor,
                    changeListener: (value) => setState(() => pc = value),
                    validator: (text) => _getErrorMessage(text.isEmpty),
                  ),
                if (delivery)
                  LongTextFieldEmpty(
                    hint: 'References',
                    theme: Theme.of(context).primaryColor,
                    changeListener: (value) =>
                        setState(() => references = value),
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

  void validateForm() {
    if (widget._key.currentState.validate()) {
      if (delivery) {
        Provider.of<CartProvider>(context, listen: false).setDelivery({
          'name': name,
          'phone': phone,
          'extras': extras,
          'comments': comments,
          'street': street,
          'city': city,
          'pc': pc,
          'references': references,
        });
      } else {
        Provider.of<CartProvider>(context, listen: false).setReservation({
          'name': name,
          'phone': phone,
          'extras': extras,
          'comments': comments,
        });
      }
      NavigationUtils.push(context, PayConfirm());
    }
  }

  String _getErrorMessage(empty) {
    if (empty) {
      return 'This field is required';
    }
    return null;
  }
}
