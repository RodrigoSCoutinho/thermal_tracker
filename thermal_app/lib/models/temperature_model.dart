class TemperatureData {
  final double temperature;
  final DateTime timestamp;

  TemperatureData({
    required this.temperature,
    required this.timestamp,
  });

  factory TemperatureData.fromJson(Map<String, dynamic> json) {
    return TemperatureData(
      temperature: double.tryParse(json['field1'] ?? '0') ?? 0.0,
      timestamp: DateTime.tryParse(json['created_at'] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
