import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _feedbackController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Bitte geben Sie Ihr Feedback oder Ihre Probleme an:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Geben Sie Ihr Feedback hier ein...',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Hier kannst du die Logik für das Speichern oder Senden des Feedbacks hinzufügen
                String feedback = _feedbackController.text;
                if (feedback.isNotEmpty) {
                  // Beispiel: Feedback speichern oder senden
                  print('Feedback: $feedback'); // Temporäre Ausgabe in die Konsole
                  _feedbackController.clear(); // Eingabefeld leeren
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Danke für Ihr Feedback!')),
                  );
                }
              },
              child: const Text('Feedback senden'),
            ),
          ],
        ),
      ),
    );
  }
}
