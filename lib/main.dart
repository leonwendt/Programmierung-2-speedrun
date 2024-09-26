import 'package:flutter/material.dart';

void main() {
  runApp(const CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CurrenC',
      theme: ThemeData(
        brightness: Brightness.dark, // Setzt das Thema auf dunkel
        primarySwatch: Colors.blueGrey,
        colorScheme: ColorScheme.dark(
          secondary: Color(0xFFFFE4B5), // Cremefarbener Akzent
        ),
        scaffoldBackgroundColor: Colors.black, // Hintergrund der App auf schwarz
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFE4B5), // Cremefarbe für Buttons
            foregroundColor: Colors.black, // Textfarbe auf Buttons
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _result = 0.0;

  final Map<String, double> exchangeRates = {
    'USD': 1.0,
    'EUR': 0.85,
    'GBP': 0.75,
    'INR': 74.0,
  };

  void _convertCurrency() {
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    double fromRate = exchangeRates[_fromCurrency]!;
    double toRate = exchangeRates[_toCurrency]!;
    setState(() {
      _result = (amount / fromRate) * toRate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CurrenC'),
        backgroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Amount',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.grey[800], // Textfeld Hintergrund dunkel
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                DropdownButton<String>(
                  value: _fromCurrency,
                  items: exchangeRates.keys.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _fromCurrency = newValue!;
                    });
                  },
                  dropdownColor: Colors.grey[850], // Dropdown-Hintergrund dunkel
                  style: const TextStyle(color: Colors.white), // Textfarbe im Dropdown
                ),
                const Text(
                  'to',
                  style: TextStyle(color: Colors.white),
                ),
                DropdownButton<String>(
                  value: _toCurrency,
                  items: exchangeRates.keys.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _toCurrency = newValue!;
                    });
                  },
                  dropdownColor: Colors.grey[850], // Dropdown-Hintergrund dunkel
                  style: const TextStyle(color: Colors.white), // Textfarbe im Dropdown
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertCurrency,
              child: const Text('Convert'),
            ),
            const SizedBox(height: 20),
            Text(
              _result == 0.0
                  ? 'Enter amount to see the result'
                  : 'Result: $_result $_toCurrency',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
