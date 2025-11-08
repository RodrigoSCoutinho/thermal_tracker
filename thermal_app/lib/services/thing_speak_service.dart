import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ThingSpeakService {
  final String baseUrl = "https://api.thingspeak.com/channels";
  final String apiKey = dotenv.env['API_KEY'] ?? "";
  final String channelId = dotenv.env['CHANNEL_ID'] ?? "";

  Future<Map<String, dynamic>> fetchLatestData() async {
    final url = '$baseUrl/$channelId/feeds.json?api_key=$apiKey&results=1';
    debugPrint('ThingSpeakService: Making GET request to: $url');

    try {
      final response = await http.get(Uri.parse(url));
      debugPrint(
          'ThingSpeakService: Response status code: ${response.statusCode}');
      debugPrint('ThingSpeakService: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('ThingSpeakService: Parsed response data: $data');
        return data;
      } else {
        throw Exception(
            'ThingSpeakService: Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('ThingSpeakService: Error during HTTP request: $e');
      throw Exception('ThingSpeakService: Failed to fetch data');
    }
  }

  Future<List<dynamic>> fetchHistoricalData() async {
    final url = '$baseUrl/$channelId/feeds.json?api_key=$apiKey';
    debugPrint('ThingSpeakService: Making GET request to: $url');

    try {
      final response = await http.get(Uri.parse(url));
      debugPrint(
          'ThingSpeakService: Response status code: ${response.statusCode}');
      debugPrint('ThingSpeakService: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final feeds = json.decode(response.body)['feeds'];
        debugPrint('ThingSpeakService: Parsed historical data: $feeds');
        return feeds;
      } else {
        throw Exception(
            'ThingSpeakService: Failed to fetch historical data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('ThingSpeakService: Error during HTTP request: $e');
      throw Exception('ThingSpeakService: Failed to fetch historical data');
    }
  }
}
