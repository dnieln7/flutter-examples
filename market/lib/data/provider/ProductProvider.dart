import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:market/data/model/Product.dart';
import 'package:market/service/ApiConfig.dart';

class ProductProvider with ChangeNotifier {
  String _token;
  String _userId;
  List<Product> _items;

  ProductProvider(this._token, this._userId, this._items);

  List<Product> get products => [..._items];

  List<Product> get favoriteProducts =>
      _items.where((product) => product.isFavorite).toList();

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchFromNetwork(bool doFilter) async {
    final filter = doFilter ? '&orderBy="creatorId"&equalTo="$_userId"' : '';
    final requestUrl = ApiConfig.db_url + '/products.json?auth=$_token$filter';

    try {
      final response = await http.get(requestUrl);
      if (response.statusCode >= 400) {
        throw Exception('Could not fetch');
      }

      if (response.body == null) {
        throw Exception('Null body');
      }

      final favoritesUrl =
          ApiConfig.db_url + '/user-favorites/$_userId.json?auth=$_token';
      final favoritesResponse = await http.get(favoritesUrl);
      var favorites;

      if (favoritesResponse != null && favoritesResponse.body != null) {
        favorites = json.decode(favoritesResponse.body) as Map<String, dynamic>;
      }

      final decoded = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> list = [];

      decoded.forEach((id, data) => {
            list.add(Product(
              id: id,
              title: data['title'],
              description: data['description'],
              price: data['price'],
              image: data['image'],
              isFavorite: favorites == null ? false : favorites[id] ?? false,
            ))
          });
      _items = list;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> add(Product product) async {
    final requestUrl = ApiConfig.db_url + '/products.json?auth=$_token';
    final body = {
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'image': product.image,
      'creatorId': _userId,
    };

    try {
      final response = await http.post(requestUrl, body: json.encode(body));
      final decoded = json.decode(response.body);

      product.id = decoded['name'];
      _items.insert(0, product);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> update(Product product) async {
    final requestUrl =
        ApiConfig.db_url + '/products/${product.id}.json?auth=$_token';
    final body = {
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'image': product.image,
    };

    try {
      final response = await http.patch(requestUrl, body: json.encode(body));

      int index = _items.indexWhere((p) => p.id == product.id);
      _items[index] = product;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> delete(String id) async {
    final requestUrl = ApiConfig.db_url + '/products/$id.json?auth=$_token';

    try {
      final response = await http.delete(requestUrl);

      if (response.statusCode >= 400) {
        throw Exception('Could not delete');
      }

      _items.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
