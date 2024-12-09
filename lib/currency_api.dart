import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyApi {
  static final String _baseUrl = 'https://open.er-api.com/v6/';

  static Future<Map<String, double>> fetchExchangeRates(String baseCurrency) async {
    print('Starte API-Aufruf für Basiswährung: $baseCurrency');
    try {
      final response = await http.get(Uri.parse('https://open.er-api.com/v6/latest/$baseCurrency')).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Timeout: Anfrage hat zu lange gedauert');
        },
      );
      print('API-Antwort erhalten: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Daten erfolgreich dekodiert: $data');

        // Konvertiere Werte zu `double`
        final rates = (data['rates'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, (value as num).toDouble()),
        );

        return rates;
      } else {
        throw Exception('Fehlerhafte Antwort vom Server: ${response.statusCode}');
      }
    } catch (e) {
      print('Fehler während des API-Aufrufs: $e');
      return {};
    }
  }

  // Neue Methode zum Abrufen historischer Wechselkurse
  static Future<Map<String, double>?> fetchHistoricalRates(String baseCurrency, DateTime startDate, DateTime endDate) async {
    // Formatieren der Daten für die URL
    String startDateStr = startDate.toIso8601String().split('T').first; // Nur das Datum ohne Zeit
    String endDateStr = endDate.toIso8601String().split('T').first; // Nur das Datum ohne Zeit

    // API-URL für historische Daten (passe sie gemäß deiner API-Dokumentation an)
    final String url = 'https://open.er-api.com/v6/history/$baseCurrency?start_at=$startDateStr&end_at=$endDateStr';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Historische API-Daten: $data'); // Vollständige historische Daten ausgeben

      // Hier anpassen, wie die historischen Daten zurückgegeben werden
      final Map<String, dynamic> rawRates = data['rates'];
      final Map<String, double> rates = rawRates.map((key, value) {
        return MapEntry(key, (value is int) ? value.toDouble() : value as double);
      });

      return rates;
    } else {
      print('Fehler beim Abrufen historischer Wechselkurse: ${response.statusCode}');
      return null; // Keine Daten zurückgeben, wenn der Abruf fehlschlägt
    }
  }
}
