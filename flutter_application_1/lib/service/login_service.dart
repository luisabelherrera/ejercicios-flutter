import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/car.dart';

class LoginService {
  static Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://carros-electricos.wiremockapi.cloud/auth'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['token'];
    } else {
      throw Exception('Error login: ${response.statusCode}');
    }
  }

  static Future<List<Car>> getCars(String token) async {
    final response = await http.get(
      Uri.parse('https://carros-electricos.wiremockapi.cloud/carros'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('GetCars Status: ${response.statusCode}');
    print('GetCars Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> carsJson = jsonDecode(response.body);
      return carsJson.map((json) => Car.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cars: ${response.body}');
    }
  }
}