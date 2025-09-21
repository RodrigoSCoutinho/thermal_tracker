import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String baseUrl =
      'https://api.thingspeak.com/channels/${dotenv.env['CHANNEL_ID']}';
  final String apiKey = dotenv.env['API_KEY']!;

  Future<Map<String, dynamic>> fetchLatestData() async {
    final response = await http
        .get(Uri.parse('$baseUrl/feeds.json?api_key=$apiKey&results=1'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<dynamic>> fetchHistoricalData() async {
    final response =
        await http.get(Uri.parse('$baseUrl/feeds.json?api_key=$apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['feeds'];
    } else {
      throw Exception('Failed to fetch historical data');
    }
  }
}
