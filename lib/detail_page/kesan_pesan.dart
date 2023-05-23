import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        title: Text('Kesan Pesan'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Kesannya buat Mata Kuliah ini lumayan menantang, karena tanpa basic dart, langsung diarahkan untuk terjun di flutter. Pak Bagus ngajarnya santai dan menekankan untuk banyak-banyak belajar mandiri, dan semoga dapat nilai A di akhir semester.',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
