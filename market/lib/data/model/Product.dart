import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:market/service/ApiConfig.dart';

class Product with ChangeNotifier {
  String id;
  final String title;
  final String description;
  final double price;
  final String image;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.image,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final requestUrl =
        ApiConfig.db_url + '/user-favorites/$userId/$id.json?auth=$token';

    try {
      final response =
          await http.put(requestUrl, body: json.encode(isFavorite));

      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
        throw Exception('Could not update');
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
      throw error;
    }
  }
}
