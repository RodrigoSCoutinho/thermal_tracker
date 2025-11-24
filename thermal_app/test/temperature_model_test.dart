import 'package:flutter_test/flutter_test.dart';
import 'package:thermal_app/models/temperature_model.dart';

void main() {
  group("TemperatureData Model", () {
    test("fromJson converte corretamente", () {
      final json = {
        "field1": "27.5",
        "created_at": "2025-11-23T18:00:00Z"
      };

      final model = TemperatureData.fromJson(json);

      expect(model.temperature, 27.5);
      expect(model.timestamp, DateTime.parse("2025-11-23T18:00:00Z"));
    });
  });
}
