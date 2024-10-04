import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _feedbackController = TextEditingController();

    // Funktion zur Anzeige eines Bewertungsdialogs
    Future<void> _showRatingDialog(BuildContext context) async {
      double rating = 0;

      return showDialog<void>(
        context: context,
        barrierDismissible: false, // Benutzer kann Dialog nicht schließen, ohne zu bewerten
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Bewertung abgeben'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Bitte bewerten Sie die App:'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        rating = index + 1.0;
                        // Aktualisiere das Widget, um die gewählte Bewertung anzuzeigen
                        (context as Element).markNeedsBuild();
                      },
                    );
                  }),
                ),
                const SizedBox(height: 10),
                Text('Ihre Bewertung: ${rating.toStringAsFixed(1)}'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  // Hier kannst du die Logik für das Speichern oder Senden der Bewertung hinzufügen
                  print('Bewertung: $rating'); // Temporäre Ausgabe in die Konsole
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

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
                // Zeige den Bewertungsdialog an
                _showRatingDialog(context);
              },
              child: const Text('Bewertung abgeben'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
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
