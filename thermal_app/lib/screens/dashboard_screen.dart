import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/api_service.dart';
import '../widgets/temperature_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final ApiService apiService;

  String latestTemperature = 'Loading...';
  Color cardColor = Colors.blue;
  List<double> temperatureHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(
      baseUrl:
          'https://api.thingspeak.com/channels/${dotenv.env['CHANNEL_ID']}',
      apiKey: dotenv.env['API_KEY']!,
    );
    fetchTemperature();
    fetchTemperatureHistory();
  }

  Future<void> fetchTemperature() async {
    try {
      final data = await apiService.fetchLatestData();
      if (data['feeds'] != null && data['feeds'].isNotEmpty) {
        setState(() {
          latestTemperature = '${data['feeds'][0]['field1']} °C';
          cardColor = double.parse(data['feeds'][0]['field1']) > 30
              ? Colors.red
              : Colors.green;
        });
      } else {
        setDummyData();
      }
    } catch (e) {
      setDummyData();
    }
  }

  Future<void> fetchTemperatureHistory() async {
    try {
      final data = await apiService.fetchHistoricalData();
      if (data.isNotEmpty) {
        setState(() {
          temperatureHistory = data
              .map<double>((entry) => double.tryParse(entry['field1']) ?? 0.0)
              .toList();
          isLoading = false;
        });
      } else {
        setDummyHistory();
      }
    } catch (e) {
      setDummyHistory();
    }
  }

  void setDummyData() {
    setState(() {
      latestTemperature = '25.0 °C (Dummy)';
      cardColor = Colors.green;
    });
  }

  void setDummyHistory() {
    setState(() {
      temperatureHistory = List.generate(10, (index) => 20 + index.toDouble());
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Latest Temperature Card
            TemperatureCard(
              title: 'Latest Temperature',
              value: latestTemperature,
              color: cardColor,
            ),
            const SizedBox(height: 16),
            // Temperature History Chart
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Temperature History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomPaint(
                                painter: TemperatureChartPainter(
                                  data: temperatureHistory,
                                ),
                                child: Container(),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Save Temperature Section
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Temperature saved!')),
                );
              },
              icon: const Icon(Icons.save),
              label: const Text('Save Current Temperature'),
            ),
          ],
        ),
      ),
    );
  }
}

class TemperatureChartPainter extends CustomPainter {
  final List<double> data;

  TemperatureChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final double spacing = size.width / (data.length - 1);
    for (int i = 0; i < data.length; i++) {
      final x = i * spacing;
      final y =
          size.height - (data[i] / 50 * size.height); // Normalize to height
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    for (int i = 0; i < data.length; i++) {
      final x = i * spacing;
      final y = size.height - (data[i] / 50 * size.height);
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
