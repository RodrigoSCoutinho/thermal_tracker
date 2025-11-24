import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  final String apiKey;
  final http.Client httpClient;

  ApiService({
    required this.baseUrl,
    required this.apiKey,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  Future<Map<String, dynamic>> fetchLatestData() async {
    final url = '$baseUrl/feeds.json?api_key=$apiKey&results=1';
    debugPrint('ApiService: Making GET request to: $url');

    try {
      final response = await httpClient.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'ApiService: Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('ApiService: Failed to fetch data');
    }
  }

  Future<List<dynamic>> fetchHistoricalData() async {
    final url = '$baseUrl/feeds.json?api_key=$apiKey';

    try {
      final response = await httpClient.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body)['feeds'];
      } else {
        throw Exception(
            'ApiService: Failed to fetch historical data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('ApiService: Failed to fetch historical data');
    }
  }

  Future<Map<String, dynamic>> fetchDataWithResults(int results) async {
    final url = '$baseUrl/feeds.json?api_key=$apiKey&results=$results';

    try {
      final response = await httpClient.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'ApiService: Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('ApiService: Failed to fetch data');
    }
  }
}
