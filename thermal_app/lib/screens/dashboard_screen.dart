import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final ApiService apiService;

  Map<String, dynamic>? channelData;
  List<dynamic>? feedsData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    debugPrint('DashboardScreen initState called');
    final channelId = dotenv.env['CHANNEL_ID'];
    final apiKey = dotenv.env['API_KEY'];

    debugPrint('CHANNEL_ID: $channelId');
    debugPrint('API_KEY: $apiKey');

    if (channelId == null || apiKey == null) {
      setState(() {
        errorMessage = 'Missing CHANNEL_ID or API_KEY in .env file';
        isLoading = false;
      });
      debugPrint('Error: $errorMessage');
      return;
    }

    apiService = ApiService(
      baseUrl: 'https://api.thingspeak.com/channels/$channelId',
      apiKey: apiKey,
    );
    debugPrint('ApiService initialized with baseUrl: ${apiService.baseUrl}');
    fetchData();
  }

  /**
   * Fetch data from ThingSpeak API and update state accordingly.
   */
  Future<void> fetchData() async {
    debugPrint('fetchData called');
    try {
      final data =
          await apiService.fetchDataWithResults(30); // Fetch 30 results
      debugPrint('Data fetched: $data');
      setState(() {
        channelData = data['channel'];
        feedsData = data['feeds'];
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching data: $e');
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  /**
   * Extract valid temperature readings from feeds data.
   */
  List<double> getValidTemperatures() {
    if (feedsData == null || feedsData!.isEmpty) {
      debugPrint('No feeds data available.');
      return [];
    }
    return feedsData!
        .map((feed) => double.tryParse((feed['field1'] ?? '').toString()))
        .where((temp) => temp != null)
        .cast<double>()
        .toList();
  }

  /**
   * Calculate average temperature from a list of temperatures.
   */
  double calculateAverageTemperature(List<double> temperatures) {
    if (temperatures.isEmpty) {
      debugPrint('No valid temperatures available for average calculation.');
      return 0.0;
    }
    return temperatures.reduce((a, b) => a + b) / temperatures.length;
  }

  /**
   * Calculate median temperature from a list of temperatures.
   */
  double calculateMedianTemperature(List<double> temperatures) {
    if (temperatures.isEmpty) {
      debugPrint('No valid temperatures available for median calculation.');
      return 0.0;
    }
    final sorted = List<double>.from(temperatures)..sort();
    final middle = sorted.length ~/ 2;
    return sorted.length.isOdd
        ? sorted[middle]
        : (sorted[middle - 1] + sorted[middle]) / 2;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build method called');
    debugPrint(
        'isLoading: $isLoading, errorMessage: $errorMessage, channelData: $channelData, feedsData: $feedsData');

    final validTemperatures = getValidTemperatures();
    final averageTemperature = calculateAverageTemperature(validTemperatures);
    final medianTemperature = calculateMedianTemperature(validTemperatures);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ThingSpeak Data'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text('Error: $errorMessage'))
              : channelData != null && feedsData != null
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Channel Information
                            Text(
                              'Channel Information',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text('Name: ${channelData!['name']}'),
                            Text('Created At: ${channelData!['created_at']}'),
                            Text('Updated At: ${channelData!['updated_at']}'),
                            Text('Latitude: ${channelData!['latitude']}'),
                            Text('Longitude: ${channelData!['longitude']}'),
                            Text(
                                'Last Entry ID: ${channelData!['last_entry_id']}'),
                            const SizedBox(height: 16),

                            // Average Temperature
                            Text(
                              'Average Temperature: ${averageTemperature.toStringAsFixed(2)} °C',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 8),

                            // Median Temperature
                            Text(
                              'Median Temperature: ${medianTemperature.toStringAsFixed(2)} °C',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 16),

                            // Temperature Graph
                            const Text(
                              'Temperature Over Time',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            validTemperatures.isNotEmpty
                                ? SizedBox(
                                    height: 200,
                                    child: CustomPaint(
                                      painter: TemperatureGraphPainter(
                                          temperatures: validTemperatures),
                                      child: Container(),
                                    ),
                                  )
                                : const Text(
                                    'No valid temperature data available for the graph.',
                                    style: TextStyle(color: Colors.red),
                                  ),
                          ],
                        ),
                      ),
                    )
                  : const Center(child: Text('No data available')),
    );
  }
}

class TemperatureGraphPainter extends CustomPainter {
  final List<double> temperatures;

  TemperatureGraphPainter({required this.temperatures});

  @override
  void paint(Canvas canvas, Size size) {
    if (temperatures.isEmpty) return;

    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    final stepX = size.width / (temperatures.length - 1);
    final maxTemp = temperatures.reduce((a, b) => a > b ? a : b);
    final minTemp = temperatures.reduce((a, b) => a < b ? a : b);
    final tempRange = maxTemp - minTemp;

    for (int i = 0; i < temperatures.length; i++) {
      final x = i * stepX;
      final y =
          size.height - ((temperatures[i] - minTemp) / tempRange * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
