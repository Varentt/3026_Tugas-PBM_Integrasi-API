import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/product_model.dart';

class ProductService {

  static const String baseUrl =
      'https://task.itprojects.web.id';

  final storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<List<ProductModel>> getProducts() async {

    final token = await getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/products'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    List products = data['data']['products'];

    return products
        .map(
          (product) =>
              ProductModel.fromJson(product),
        )
        .toList();
  }

  Future<bool> addProduct(
    String name,
    int price,
    String description,
  ) async {

    final token = await getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/api/products'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
      }),
    );

    return response.statusCode == 200 ||
        response.statusCode == 201;
  }

  Future<bool> deleteProduct(int id) async {

    final token = await getToken();

    final response = await http.delete(

      Uri.parse(
        '$baseUrl/api/products/$id',
      ),

      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print(response.body);

    return response.statusCode == 200;
  }
}