import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ApiService {
  static const _requestTimeout = Duration(seconds: 20);
  static String? _token;

  void setToken(String? token) => _token = token;

  Map<String, String> get _jsonHeaders => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  // Override with --dart-define=API_BASE_URL=https://api.example.com/api.
  static String get baseUrl {
    const configuredUrl = String.fromEnvironment('API_BASE_URL');
    if (configuredUrl.isNotEmpty) {
      return configuredUrl.replaceFirst(RegExp(r'/$'), '');
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000/api';
    }
    return 'http://127.0.0.1:5000/api';
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _jsonHeaders,
      body: jsonEncode({'email': email, 'password': password}),
    ).timeout(_requestTimeout);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> signup(String email, String password, String displayName, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: _jsonHeaders,
      body: jsonEncode({
        'email': email,
        'password': password,
        'display_name': displayName,
        'role': role,
      }),
    ).timeout(_requestTimeout);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> analyzeToxicity(String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ai/toxicity'),
      headers: _jsonHeaders,
      body: jsonEncode({'text': text}),
    ).timeout(_requestTimeout);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> analyzeImage(XFile imageFile) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/ai/image'));
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        await imageFile.readAsBytes(),
        filename: imageFile.name,
      ),
    );
    if (_token != null) request.headers['Authorization'] = 'Bearer $_token';
    final streamedResponse = await request.send().timeout(_requestTimeout);
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException {
      throw Exception('The server returned an invalid response.');
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }
    throw Exception(body['error'] ?? 'Unexpected API error');
  }
}
