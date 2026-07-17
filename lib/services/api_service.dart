import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:study_box/models/product.dart';

class ApiService {
  static const String _productsUrl = 'https://wantapi.com/products.php';

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(_productsUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        final List<dynamic> productList = jsonData['data'] ?? [];

        return productList
            .map((json) => Product.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      } else {
        throw Exception('Ürünler alınamadı. Hata kodu: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('ApiService hatası: $error');
      rethrow;
    }
  }
}
