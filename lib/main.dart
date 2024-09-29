import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Für custom Fonts

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
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        colorScheme: ColorScheme.dark(
          secondary: Color(0xFFFFE4B5), // Cremefarbener Akzent
        ),
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFE4B5),
            foregroundColor: Colors.black,
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
  final TextEditingController _fromAmountController = TextEditingController();
  final TextEditingController _toAmountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _result = 0.0;

  final Map<String, double> exchangeRates = {
    'USD': 1.0,
    'EUR': 0.85,
    'GBP': 0.75,
    'INR': 74.0,
  };

  void _convertCurrency(bool reverse) {
    double amount = reverse
        ? double.tryParse(_toAmountController.text) ?? 0.0
        : double.tryParse(_fromAmountController.text) ?? 0.0;

    double fromRate = reverse
        ? exchangeRates[_toCurrency]!
        : exchangeRates[_fromCurrency]!;
    double toRate = reverse
        ? exchangeRates[_fromCurrency]!
        : exchangeRates[_toCurrency]!;

    setState(() {
      _result = (amount / fromRate) * toRate;
      if (reverse) {
        _fromAmountController.text = _result.toStringAsFixed(2);
      } else {
        _toAmountController.text = _result.toStringAsFixed(2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Berechne den Wechselkurs zwischen den beiden ausgewählten Währungen
    double exchangeRate = exchangeRates[_toCurrency]! / exchangeRates[_fromCurrency]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CurrenC',
          style: GoogleFonts.montserrat( // Ändere hier zu Poppins oder einem anderen Font
            textStyle: const TextStyle(
              color: Color(0xFFFFE4B5), // Cremefarbene Farbe
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.28,
                  child: TextField(
                    controller: _fromAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[800],
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          color: Color(0xFFFFE4B5),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFFFE4B5)),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      _convertCurrency(false);
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  width: MediaQuery.of(context).size.width * 0.28,
                  child: TextField(
                    controller: _toAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[800],
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          color: Color(0xFFFFE4B5),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFFFE4B5)),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      _convertCurrency(true);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Zentriert die gesamte Row
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    _convertCurrency(false);
                  },
                  dropdownColor: Colors.grey[850],
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 15),

                // Flexible Widgets für Währungswerte
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '1 $_fromCurrency',
                        style: const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ),

                // Container für das Gleichheitszeichen mit fester Breite
                Container(
                  width: 30, // Feste Breite für das Gleichheitszeichen
                  alignment: Alignment.center,
                  child: Text(
                    '=',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),

                // Flexible Widgets für den Währungswert rechts
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${exchangeRate.toStringAsFixed(2)} $_toCurrency',
                        style: const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 15),
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
                    _convertCurrency(true);
                  },
                  dropdownColor: Colors.grey[850],
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
