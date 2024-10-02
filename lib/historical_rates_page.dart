import 'package:flutter/material.dart';
import 'currency_api.dart'; // Importiere deine CurrencyApi-Klasse

class HistoricalRatesPage extends StatefulWidget {
  @override
  _HistoricalRatesPageState createState() => _HistoricalRatesPageState();
}

class _HistoricalRatesPageState extends State<HistoricalRatesPage> {
  Map<String, double>? _historicalRates; // Typanpassung
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistoricalRates();
  }

  Future<void> _fetchHistoricalRates() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Hier die Basiswährung und die Datumsangaben angeben
      DateTime startDate = DateTime.now().subtract(Duration(days: 7));
      DateTime endDate = DateTime.now(); // Aktuelles Datum als Enddatum

      final rates = await CurrencyApi.fetchHistoricalRates('USD', startDate, endDate); // Übergebe Start- und Enddatum

      if (rates != null) {
        // Hier wandeln wir die Werte in double um
        _historicalRates = rates.map((key, value) => MapEntry(key, value.toDouble())); // Typkonvertierung
      }
    } catch (e) {
      print('Fehler beim Abrufen der historischen Wechselkurse: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Historische Wechselkurse'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Historische Wechselkurse'),
      ),
      body: _historicalRates != null
          ? ListView.builder(
        itemCount: _historicalRates!.length,
        itemBuilder: (context, index) {
          String date = _historicalRates!.keys.elementAt(index);
          double rate = _historicalRates![date]!;
          return ListTile(
            title: Text('$date: $rate'),
          );
        },
      )
          : Center(
        child: Text('Keine historischen Wechselkurse gefunden.'),
      ),
    );
  }
}
