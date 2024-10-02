import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedCurrency = 'USD'; // Standardwert für die Währung

  List<String> availableCurrencies = [
    'USD', 'EUR', 'GBP', 'CHF', 'SEK', 'NOK', 'DKK', 'PLN', 'HUF', 'CZK', 'RUB', 'ISK',
    'BGN', 'HRK', 'RON', 'TRY', 'UAH', 'MKD', 'ALL', 'GIP', 'MDL'
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Lade die Einstellungen
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCurrency = prefs.getString('default_currency') ?? 'USD'; // Standardwert
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Standardwährung',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedCurrency,
              items: availableCurrencies.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) async {
                setState(() {
                  _selectedCurrency = newValue!;
                });
                // Speichere die Währung in SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('default_currency', _selectedCurrency);
              },
              dropdownColor: Colors.grey[850],
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
