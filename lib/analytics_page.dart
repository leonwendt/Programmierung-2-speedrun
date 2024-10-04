import 'package:flutter/material.dart';
import 'currency_api.dart'; // Importiere deine CurrencyApi-Klasse

class AnalyticsPage extends StatefulWidget {
  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  Map<String, double>? _Analytics; // Typanpassung
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAnalytics();
  }

  Future<void> _fetchAnalytics() async {
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
        _Analytics = rates.map((key, value) => MapEntry(key, value.toDouble())); // Typkonvertierung
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
          title: Text('Analytics'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
      ),
      body: _Analytics != null
          ? ListView.builder(
        itemCount: _Analytics!.length,
        itemBuilder: (context, index) {
          String date = _Analytics!.keys.elementAt(index);
          double rate = _Analytics![date]!;
          return ListTile(
            title: Text('$date: $rate'),
          );
        },
      )
          : Center(
        child: Text('Keine Analytics gefunden.'),
      ),
    );
  }
}
