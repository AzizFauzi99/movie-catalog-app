import 'package:flutter/material.dart';
import 'detail_page/konversi_uang.dart';
import 'detail_page/konversi_waktu.dart';
import 'detail_page/kesan_pesan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  final String imageUrl =
      "https://media.licdn.com/dms/image/D5603AQERg2hCFqemzg/profile-displayphoto-shrink_200_200/0/1665727788766?e=1689811200&v=beta&t=c-PyixxJT83jPxZrJMFrAMEfi7VpfklnhR9Ia4CDq64";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          SizedBox(height: 24),
          CircleAvatar(
            radius: 80,
            backgroundImage: NetworkImage(imageUrl),
          ),
          SizedBox(height: 16),
          Text(
            'Aziz Fatih Fauzi',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 14),
          Text(
            '123200070',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 24),
          ListTile(
            leading: Icon(Icons.monetization_on, color: Colors.white),
            title: Text(
              'Konversi Mata Uang',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CurrencyConversionPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.language, color: Colors.white),
            title: Text(
              'Konversi Jam Dunia',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimeConversionPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.mail, color: Colors.white),
            title: Text(
              'Kesan Pesan',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
