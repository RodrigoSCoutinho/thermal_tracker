import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final ApiService apiService;

  Map<String, dynamic>? channelData;
  List<dynamic>? feedsData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    final channelId = dotenv.env['CHANNEL_ID'];
    final apiKey = dotenv.env['API_KEY'];

    if (channelId == null || apiKey == null) {
      setState(() {
        errorMessage = 'Missing CHANNEL_ID or API_KEY in .env file';
        isLoading = false;
      });
      return;
    }

    apiService = ApiService(
      baseUrl: 'https://api.thingspeak.com/channels/$channelId',
      apiKey: apiKey,
    );
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await apiService.fetchDataWithResults(30);
      setState(() {
        channelData = data['channel'];
        feedsData = data['feeds'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  List<double> getValidTemperatures() {
    if (feedsData == null || feedsData!.isEmpty) {
      return [];
    }
    return feedsData!
        .map((feed) => double.tryParse((feed['field1'] ?? '').toString()))
        .where((temp) => temp != null)
        .cast<double>()
        .toList();
  }

  double calculateAverageTemperature(List<double> temperatures) {
    if (temperatures.isEmpty) {
      return 0.0;
    }
    return temperatures.reduce((a, b) => a + b) / temperatures.length;
  }

  double calculateMaxTemperature(List<double> temperatures) {
    if (temperatures.isEmpty) {
      return 0.0;
    }
    return temperatures.reduce((a, b) => a > b ? a : b);
  }

  double calculateMinTemperature(List<double> temperatures) {
    if (temperatures.isEmpty) {
      return 0.0;
    }
    return temperatures.reduce((a, b) => a < b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final validTemperatures = getValidTemperatures();
    final averageTemperature = calculateAverageTemperature(validTemperatures);
    final maxTemperature = calculateMaxTemperature(validTemperatures);
    final minTemperature = calculateMinTemperature(validTemperatures);

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text('Error: $errorMessage'))
              : channelData != null && feedsData != null
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24.0, horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Histórico Completo',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            _CardContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Estatísticas',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  _StatRow('Temperatura Média',
                                      '${averageTemperature.toStringAsFixed(2)}°C'),
                                  _StatRow('Máxima Registrada',
                                      '${maxTemperature.toStringAsFixed(2)}°C'),
                                  _StatRow('Mínima Registrada',
                                      '${minTemperature.toStringAsFixed(2)}°C'),
                                  _StatRow('Leituras Hoje',
                                      '${validTemperatures.length}'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            _CardContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Média Semanal',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 130,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: _FakeBarChart(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Center(child: Text('No data available')),
    );
  }
}

class _CardContainer extends StatelessWidget {
  final Widget child;
  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: child,
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _FakeBarChart extends StatelessWidget {
  const _FakeBarChart();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _BarSegment(label: 'Seg', value: 20),
        _BarSegment(label: 'Ter', value: 35),
        _BarSegment(label: 'Qua', value: 30),
        _BarSegment(label: 'Qui', value: 50),
        _BarSegment(label: 'Sex', value: 45),
        _BarSegment(label: 'Sáb', value: 60),
        _BarSegment(label: 'Dom', value: 55),
      ],
    );
  }
}

class _BarSegment extends StatelessWidget {
  final String label;
  final double value;
  const _BarSegment({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: value,
          width: 20,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
