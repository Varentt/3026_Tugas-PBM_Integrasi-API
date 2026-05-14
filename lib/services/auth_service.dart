import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {

  static const String baseUrl =
      'https://task.itprojects.web.id';

  final storage =
      const FlutterSecureStorage();

  Future<bool> login(
    String username,
    String password,
  ) async {

    final url = Uri.parse(
      '$baseUrl/api/auth/login',
    );

    final response = await http.post(

      url,

      headers: {
        'Content-Type':
            'application/json',

        'Accept':
            'application/json',
      },

      body: jsonEncode({

        'username': username,

        'password': password,
      }),
    );

    if (response.statusCode == 200) {

      final data =
          jsonDecode(response.body);

      String token =
          data['data']['token'];

      await storage.write(
        key: 'token',
        value: token,
      );

      return true;
    }

    return false;
  }

  Future<String?> getToken() async {

    return await storage.read(
      key: 'token',
    );
  }
}