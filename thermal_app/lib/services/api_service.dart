import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  final String apiKey;

  ApiService({required this.baseUrl, required this.apiKey});

  Future<Map<String, dynamic>> fetchLatestData() async {
    final url = '$baseUrl/feeds.json?api_key=$apiKey&results=1';
    debugPrint('ApiService: Making GET request to: $url');

    try {
      final response = await http.get(Uri.parse(url));
      debugPrint('ApiService: Response status code: ${response.statusCode}');
      debugPrint('ApiService: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        debugPrint('ApiService: Parsed response data: $data');
        return data;
      } else {
        throw Exception(
            'ApiService: Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('ApiService: Error during HTTP request: $e');
      throw Exception('ApiService: Failed to fetch data');
    }
  }

  Future<List<dynamic>> fetchHistoricalData() async {
    final url = '$baseUrl/feeds.json?api_key=$apiKey';
    debugPrint('ApiService: Making GET request to: $url');

    try {
      final response = await http.get(Uri.parse(url));
      debugPrint('ApiService: Response status code: ${response.statusCode}');
      debugPrint('ApiService: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final feeds = json.decode(response.body)['feeds'];
        debugPrint('ApiService: Parsed historical data: $feeds');
        return feeds;
      } else {
        throw Exception(
            'ApiService: Failed to fetch historical data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('ApiService: Error during HTTP request: $e');
      throw Exception('ApiService: Failed to fetch historical data');
    }
  }

  Future<Map<String, dynamic>> fetchDataWithResults(int results) async {
    final url = '$baseUrl/feeds.json?api_key=$apiKey&results=$results';
    debugPrint('ApiService: Making GET request to: $url');

    try {
      final response = await http.get(Uri.parse(url));
      debugPrint('ApiService: Response status code: ${response.statusCode}');
      debugPrint('ApiService: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        debugPrint('ApiService: Parsed response data: $data');
        return data;
      } else {
        throw Exception(
            'ApiService: Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('ApiService: Error during HTTP request: $e');
      throw Exception('ApiService: Failed to fetch data');
    }
  }
}
