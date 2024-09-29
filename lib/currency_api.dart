import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyApi {
  static final String _baseUrl = 'https://open.er-api.com/v6/latest/';

  static Future<Map<String, double>> fetchExchangeRates(String baseCurrency) async {
    final response = await http.get(Uri.parse('$_baseUrl$baseCurrency'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

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
}
