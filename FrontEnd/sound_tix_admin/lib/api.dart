import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

Future<Map<String, dynamic>> httpGet(BuildContext context, String url, {Map<String, String>? additionalHeaders}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwtToken');

  final headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    if (token != null) 'Authorization': 'Bearer $token',
    if (additionalHeaders != null) ...additionalHeaders,
  };

  final response = await http.get(Uri.parse(url), headers: headers);
  return _handleResponse(context, response);
}

Future<Map<String, dynamic>> httpPost(BuildContext context, String url, dynamic requestBody, {Map<String, String>? additionalHeaders}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwtToken');

  final headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    if (token != null) 'Authorization': 'Bearer $token',
    if (additionalHeaders != null) ...additionalHeaders,
  };

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: json.encode(requestBody),
  );

  return _handleResponse(context, response);
}

Future<Map<String, dynamic>> httpPatch(BuildContext context, String url, dynamic requestBody, {Map<String, String>? additionalHeaders}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwtToken');

  final headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    if (token != null) 'Authorization': 'Bearer $token',
    if (additionalHeaders != null) ...additionalHeaders,
  };

  final response = await http.patch(
    Uri.parse(url),
    headers: headers,
    body: json.encode(requestBody),
  );

  return _handleResponse(context, response);
}

Future<Map<String, dynamic>> httpDelete(BuildContext context, String url, {Map<String, String>? additionalHeaders}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwtToken');

  final headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    if (token != null) 'Authorization': 'Bearer $token',
    if (additionalHeaders != null) ...additionalHeaders,
  };

  final response = await http.delete(Uri.parse(url), headers: headers);
  return _handleResponse(context, response);
}

Future<Map<String, dynamic>> _handleResponse(BuildContext context, http.Response response) async {
  final prefs = await SharedPreferences.getInstance();

  if (response.statusCode == 200) {
    final contentType = response.headers['content-type'] ?? '';
    final body = utf8.decode(response.bodyBytes);

    return {
      'header': response.headers,
      'body': contentType.contains('application/json') ? json.decode(body) : body,
      'statusCode': 200,
    };
  } else if (response.statusCode == 403) {
    await prefs.remove('jwtToken');
    await prefs.remove('userId');

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phiên đăng nhập đã hết. Vui lòng đăng nhập lại')),
      );
      context.go('/login');
    }

    throw Exception('Phiên đăng nhập đã hết. Vui lòng đăng nhập lại');
  } else if (response.statusCode == 400) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.body)),
      );
    }

    throw Exception('Phiên đăng nhập đã hết. Vui lòng đăng nhập lại');
  } else {
    throw Exception('Lỗi: ${response.statusCode} - ${response.reasonPhrase}');
  }
}
