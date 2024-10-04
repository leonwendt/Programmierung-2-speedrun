import 'package:flutter/material.dart';

class MeasuresPage extends StatelessWidget {
  const MeasuresPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Measures'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Measures Page',
              style: TextStyle(fontSize: 24),
            ),
            // Hier kannst du weitere Widgets hinzufügen
          ],
        ),
      ),
    );
  }
}
