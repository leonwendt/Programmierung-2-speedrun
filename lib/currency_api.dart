import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyApi {
  static final String _baseUrl = 'https://open.er-api.com/v6/';

  static Future<Map<String, double>> fetchExchangeRates(String baseCurrency) async {
    final response = await http.get(Uri.parse('$_baseUrl/latest/$baseCurrency'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Full API Data: $data'); // Vollständige API-Daten ausgeben

      // Wir parsen die 'rates' und stellen sicher, dass alle Werte vom Typ double sind.
      final Map<String, dynamic> rawRates = data['rates'];
      final Map<String, double> rates = rawRates.map((key, value) {
        return MapEntry(key, (value is int) ? value.toDouble() : value as double);
      });

      return rates;
    } else {
      throw Exception('Failed to load exchange rates');
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
