import 'dart:async';
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
      return configuredUrl.trim().replaceFirst(RegExp(r'/$'), '');
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000/api';
    }
    return 'http://127.0.0.1:5000/api';
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    return _sendJson('/auth/login', {'email': email, 'password': password});
  }

  Future<Map<String, dynamic>> signup(String email, String password, String displayName, String role) async {
    return _sendJson('/auth/signup', {
      'email': email,
      'password': password,
      'display_name': displayName,
      'role': role,
    });
  }

  Future<Map<String, dynamic>> analyzeToxicity(String text) async {
    return _sendJson('/ai/toxicity', {'text': text});
  }

  Future<Map<String, dynamic>> _sendJson(String path, Map<String, dynamic> payload) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$path'),
        headers: _jsonHeaders,
        body: jsonEncode(payload),
      ).timeout(_requestTimeout);
      return _handleResponse(response);
    } on TimeoutException {
      throw Exception('The request timed out. Check your connection and try again.');
    } on http.ClientException {
      throw Exception('Unable to reach the BalKavach server.');
    }
  }

  Future<Map<String, dynamic>> analyzeImage(XFile imageFile) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/ai/image'));
      request.files.add(http.MultipartFile.fromBytes('image', await imageFile.readAsBytes(), filename: imageFile.name));
      if (_token != null) request.headers['Authorization'] = 'Bearer $_token';
      final streamedResponse = await request.send().timeout(_requestTimeout);
      return _handleResponse(await http.Response.fromStream(streamedResponse));
    } on TimeoutException {
      throw Exception('The image analysis timed out. Check your connection and try again.');
    } on http.ClientException {
      throw Exception('Unable to reach the BalKavach server.');
    }
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
    final message = body['error'];
    throw Exception(message is String && message.isNotEmpty ? message : 'Unexpected API error');
  }
}
