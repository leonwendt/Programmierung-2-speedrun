import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'currency_api.dart';
import 'historical_rates_page.dart'; // Importiere die neue Seite
import 'settings_page.dart'; // Importiere die neue Settings-Seite
import 'feedback_page.dart';
import 'info_page.dart';
import 'analytics_page.dart';
import 'measures_page.dart';


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
        scaffoldBackgroundColor: Colors.grey[950], // Dunkelgrauer Hintergrund
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black, // Schwarzer Hintergrund für die AppBar
        ),
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
  final TextEditingController _milesController = TextEditingController();
  final TextEditingController _kilometersController = TextEditingController();
  final TextEditingController _inchesController = TextEditingController();
  final TextEditingController _centimetersController = TextEditingController();
  final TextEditingController _yardsController = TextEditingController();
  final TextEditingController _metersController = TextEditingController();
  final TextEditingController _ouncesController = TextEditingController();
  final TextEditingController _gramsController = TextEditingController();

  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _result = 0.0;
  DateTime? _lastUpdateTime; // Variable für die letzte Aktualisierungszeit
  final Duration _updateInterval = Duration(hours: 6); // Zeitgrenze für die Aktualisierung
  bool _isLoading = true; // Ladezustand

  List<String> europeanCurrencies = [
    'USD', 'EUR', 'GBP', 'CHF', 'SEK', 'NOK', 'DKK', 'PLN', 'HUF', 'CZK', 'RUB', 'ISK',
    'BGN', 'HRK', 'RON', 'TRY', 'UAH', 'MKD', 'ALL', 'GIP', 'MDL'
  ];

  int _currentIndex = 1;
  List<Widget> widgetList = const [
    MeasuresPage(),
    HomePage(),
    InfoPage(),
  ];

  Map<String, double> exchangeRates = {
    'USD': 1.0,
    'EUR': 0.85,
    'GBP': 0.75,
    'INR': 74.0,
  };

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Neue Methode zum Laden der Einstellungen
    _fetchExchangeRates();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fromCurrency = prefs.getString('default_currency') ?? 'USD'; // Standardwert
    });
  }

  Future<void> _fetchExchangeRates() async {
    setState(() {
      _isLoading = true; // Ladezustand aktivieren
    });

    try {
      final rates = await CurrencyApi.fetchExchangeRates(_fromCurrency);

      if (rates != null && rates.isNotEmpty) {
        // Filtere nur europäische Währungen
        Map<String, double> europeanRates = {};
        for (String currency in europeanCurrencies) {
          if (rates.containsKey(currency)) {
            europeanRates[currency] = rates[currency]!;
          }
        }

        setState(() {
          exchangeRates.clear();
          exchangeRates.addAll(europeanRates);
          _lastUpdateTime = DateTime.now();
        });
      }
    } catch (e) {
      print('Fehler beim Abrufen der Wechselkurse: $e');
    } finally {
      setState(() {
        _isLoading = false; // Ladezustand beenden
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFFE4B5), // Cremefarbener Ladeindikator
          ),
        ),
      );
    }

    double exchangeRate = (exchangeRates[_toCurrency] ?? 0.0) / (exchangeRates[_fromCurrency] ?? 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CurrenC',
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: Color(0xFFFFE4B5), // Cremefarbene Farbe
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: Icon(Icons.info, color: Color(0xFFFFE4B5)),
            onPressed: () {
              _showInfo(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.menu, color: Color(0xFFFFE4B5)), // Menu-Icon
            onPressed: () {
              _showMenu(context);
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[900], // Dunkelgrauer Hintergrund
        child: Padding(
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: Text(
                      '=',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: TextField(
                      controller: _milesController,
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
                        _convertMilesToKilometers(false);
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: TextField(
                      controller: _kilometersController,
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
                        _convertMilesToKilometers(true);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'miles',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '1 Meile',
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: Text(
                      '=',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '1,609344 km',
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    'km',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: TextField(
                      controller: _inchesController,
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
                        _convertInchesToCentimeters(false);
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: TextField(
                      controller: _centimetersController,
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
                        _convertInchesToCentimeters(true);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'inches',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '1 inch',
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: Text(
                      '=',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '2,54 cm',
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    'cm',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: TextField(
                      controller: _yardsController,
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
                        _convertYardsToMeters(false);
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: TextField(
                      controller: _metersController,
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
                        _convertYardsToMeters(true);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'yards',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '1 yard',
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: Text(
                      '=',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '0,9144 m',
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    'm',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: TextField(
                      controller: _ouncesController,
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
                        _convertOuncesToGrams(false);
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: TextField(
                      controller: _gramsController,
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
                        _convertOuncesToGrams(true);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'ounces',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '1 ounce',
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: Text(
                      '=',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '28,349523125 g',
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    'g',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HistoricalRatesPage()), // Navigation zur historischen Seite
          );
        },
        child: Icon(Icons.history, color: Color(0xFFFFE4B5)), // History Icon
        backgroundColor: Colors.black,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_numbered),
              label: 'Measures',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
            ),
          ],
      ),
    );
  }

  void _convertCurrency(bool isToCurrency) {
    double fromAmount = double.tryParse(_fromAmountController.text) ?? 0.0;
    double toAmount = double.tryParse(_toAmountController.text) ?? 0.0;

    if (isToCurrency) {
      // Wenn der Benutzer den Zielbetrag ändert
      double newFromAmount = toAmount * (exchangeRates[_fromCurrency] ?? 1.0) / (exchangeRates[_toCurrency] ?? 1.0);
      if (newFromAmount != fromAmount) {
        _fromAmountController.text = newFromAmount.toStringAsFixed(2);
      }
    } else {
      // Wenn der Benutzer den Ausgangsbetrag ändert
      double newToAmount = fromAmount * (exchangeRates[_toCurrency] ?? 1.0) / (exchangeRates[_fromCurrency] ?? 1.0);
      if (newToAmount != toAmount) {
        _toAmountController.text = newToAmount.toStringAsFixed(2);
      }
    }
  }

  void _convertMilesToKilometers(bool isToMiles) {
    double fromAmount = double.tryParse(_milesController.text) ?? 0.0;
    double toAmount = double.tryParse(_kilometersController.text) ?? 0.0;

    if (isToMiles) {
      // Wenn der Benutzer den Zielbetrag ändert
      toAmount = fromAmount * 1.609344; // Umrechnung von Meilen in Kilometer
      _kilometersController.text = toAmount.toStringAsFixed(2);
    } else {
      // Wenn der Benutzer den Ausgangsbetrag ändert
      toAmount = fromAmount / 1.609344; // Umrechnung von Kilometer in Meilen
      _milesController.text = toAmount.toStringAsFixed(2);
    }
  }

  void _convertInchesToCentimeters(bool isToInches) {
    double fromAmount = double.tryParse(_inchesController.text) ?? 0.0;
    double toAmount = double.tryParse(_centimetersController.text) ?? 0.0;

    if (isToInches) {
      // Wenn der Benutzer den Zielbetrag ändert
      toAmount = fromAmount * 2.54; // Umrechnung von Zoll in Zentimeter
      _centimetersController.text = toAmount.toStringAsFixed(2);
    } else {
      // Wenn der Benutzer den Ausgangsbetrag ändert
      toAmount = fromAmount / 2.54; // Umrechnung von Zentimeter in Zoll
      _inchesController.text = toAmount.toStringAsFixed(2);
    }
  }

  void _convertYardsToMeters(bool isToYards) {
    double fromAmount = double.tryParse(_yardsController.text) ?? 0.0;
    double toAmount = double.tryParse(_metersController.text) ?? 0.0;

    if (isToYards) {
      // Wenn der Benutzer den Zielbetrag ändert
      toAmount = fromAmount * 0.9144; // Umrechnung von Yards in Meter
      _yardsController.text = toAmount.toStringAsFixed(2);
    } else {
      // Wenn der Benutzer den Ausgangsbetrag ändert
      toAmount = fromAmount / 0.9144; // Umrechnung von Meter in Yards
      _metersController.text = toAmount.toStringAsFixed(2);
    }
  }

  void _convertOuncesToGrams(bool isToOunces) {
    double fromAmount = double.tryParse(_ouncesController.text) ?? 0.0;
    double toAmount = double.tryParse(_gramsController.text) ?? 0.0;

    if (isToOunces) {
      // Wenn der Benutzer den Zielbetrag ändert
      toAmount = fromAmount * 28.349523125; // Umrechnung von Unzen in Gramm
      _gramsController.text = toAmount.toStringAsFixed(2);
    } else {
      // Wenn der Benutzer den Ausgangsbetrag ändert
      toAmount = fromAmount / 28.349523125; // Umrechnung von Gramm in Unzen
      _ouncesController.text = toAmount.toStringAsFixed(2);
    }
  }


  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.grey[850],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Einstellungen', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                },
              ),
              ListTile(
                title: const Text('Feedback', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FeedbackPage()), // Hier FeedbackPage hinzufügen
                  );
                },
              ),
              // Weitere Menüeinträge...
            ],
          ),
        );
      },
    );
  }
  void _showInfo(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.grey[850],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Analytics', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AnalyticsPage()), // Hier AnalyticsPage hinzufügen
                    );
                  },
                ),
                ListTile(
                  title: const Text('Information', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const InfoPage()), // Hier InfoPage hinzufügen
                    );
                  },
                ),
                // Weitere Menüeinträge...
              ]
            ),
          );
        },
    );
  }
}
