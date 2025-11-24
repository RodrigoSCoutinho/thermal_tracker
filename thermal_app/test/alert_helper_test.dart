import 'package:flutter_test/flutter_test.dart';
import 'package:thermal_app/utils/alert_helper.dart';

void main() {
  group("Alert Helper", () {
    test("isHigh retorna true para temperatura >= 38", () {
      expect(AlertHelper.isHigh(38), true);
      expect(AlertHelper.isHigh(40), true);
    });

    test("isNormal retorna true para temperatura < 38", () {
      expect(AlertHelper.isNormal(25), true);
      expect(AlertHelper.isNormal(37.9), true);
    });
  });
}
