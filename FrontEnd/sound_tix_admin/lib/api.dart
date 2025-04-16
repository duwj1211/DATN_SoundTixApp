import 'dart:convert';
import 'package:http/http.dart' as http;

httpGet(url) async {
  final response = await http.get(Uri.parse('$url'));
  if (response.statusCode == 200) {
    return {"header": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))};
  } else {
    throw Exception('Failed to load data');
  }
}

httpPost(url, requestBody, {Map<String, String>? additionalHeaders}) async {
  final headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    if (additionalHeaders != null) ...additionalHeaders,
  };

  final response = await http.post(Uri.parse('$url'), headers: headers, body: json.encode(requestBody));
  try {
    if (response.statusCode == 200) {
      return {"header": response.headers, "body": json.decode(utf8.decode(response.bodyBytes))};
    }
  } catch (e) {
    throw Exception('Failed to post data');
  }
}

httpPatch(url, requestBody, {Map<String, String>? additionalHeaders}) async {
  final headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    if (additionalHeaders != null) ...additionalHeaders,
  };
  final response = await http.patch(Uri.parse('$url'), headers: headers, body: json.encode(requestBody));
  try {
    if (response.statusCode == 200) {
      return {"header": response.headers, "body": json.decode(utf8.decode(response.bodyBytes)), "statusCode": response.statusCode};
    }
  } catch (e) {
    throw Exception('Failed to update data');
  }
}

httpDelete(url, {Map<String, String>? additionalHeaders}) async {
  final headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    if (additionalHeaders != null) ...additionalHeaders,
  };
  final response = await http.delete(Uri.parse('$url'), headers: headers);

  if (response.statusCode == 200) {
    return {"header": response.headers, "statusCode": response.statusCode};
  } else {
    throw Exception('Failed to delete data');
  }
}
