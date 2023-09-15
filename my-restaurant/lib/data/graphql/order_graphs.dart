class OrderGraphs {
  static const String get = '''
    query {
      orders{
        id
        date
        total
        type
        fulfilled
        extras
        comments
        client_name
        client_phone
        client_address_street
        client_address_city
        client_address_pc
        client_address_references
        entrance {
          name
          description
          price
          picture
          type
        }
        middle {
          name
          description
          price
          picture
          type
        }
        stew {
          name
          description
          price
          picture
          type
        }
        dessert {
          name
          description
          price
          picture
          type
        }
        drink {
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
    mutation(\$order: OrderIn!) {
      createOrder(order:\$order){
        id
      }
    }
    ''';

  static const String put = '''
    mutation(\$id: ID!, \$fulfilled: Boolean!) {
      updateOrderStatus(id: \$id, status: \$fulfilled) {
        rows
      }
   }
    ''';

  static const String delete = '''
    mutation(\$id: ID!) {
	    deleteOrder(id: \$id) {
        successful
      }
    }
    ''';
}
