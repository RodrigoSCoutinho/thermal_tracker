import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:thermal_app/services/api_service.dart';

void main() {
  const baseUrl = "https://api.thingspeak.com/channels/12345";
  const apiKey = "ABC123";

  group("ApiService Tests", () {
    test("fetchLatestData retorna Map válido quando resposta é 200", () async {
      final mockClient = MockClient((request) async {
        return http.Response('''
        {
          "feeds": [{
            "field1": "30.5",
            "created_at": "2025-11-23T18:00:00Z"
          }]
        }
        ''', 200);
      });

      final api = ApiService(
        baseUrl: baseUrl,
        apiKey: apiKey,
        httpClient: mockClient,
      );

      final data = await api.fetchLatestData();

      expect(data, isA<Map>());
      expect(data["feeds"][0]["field1"], "30.5");
    });

    test("fetchLatestData lança exceção quando API retorna erro", () async {
      final mockClient = MockClient((request) async {
        return http.Response("Erro", 500);
      });

      final api = ApiService(
        baseUrl: baseUrl,
        apiKey: apiKey,
        httpClient: mockClient,
      );

      expect(api.fetchLatestData(), throwsException);
    });

    test("fetchHistoricalData retorna lista de feeds quando resposta é 200", () async {
      final mockClient = MockClient((request) async {
        return http.Response('''
        {
          "feeds": [
            {"field1": "28"},
            {"field1": "29"}
          ]
        }
        ''', 200);
      });

      final api = ApiService(
        baseUrl: baseUrl,
        apiKey: apiKey,
        httpClient: mockClient,
      );

      final feeds = await api.fetchHistoricalData();

      expect(feeds, isA<List>());
      expect(feeds.length, 2);
    });

    test("fetchDataWithResults retorna dados com número personalizado de resultados", () async {
      final mockClient = MockClient((request) async {
        return http.Response('''
        {
          "feeds": [
            {"field1": "25"},
            {"field1": "27"},
            {"field1": "29"}
          ]
        }
        ''', 200);
      });

      final api = ApiService(
        baseUrl: baseUrl,
        apiKey: apiKey,
        httpClient: mockClient,
      );

      final data = await api.fetchDataWithResults(3);

      expect(data["feeds"], isA<List>());
      expect(data["feeds"].length, 3);
    });

    test("fetchDataWithResults lança exceção em caso de erro", () async {
      final mockClient = MockClient((request) async {
        return http.Response("Erro", 400);
      });

      final api = ApiService(
        baseUrl: baseUrl,
        apiKey: apiKey,
        httpClient: mockClient,
      );

      expect(api.fetchDataWithResults(5), throwsException);
    });
  });
}
