import 'package:flutter/material.dart';
import 'detail_page/konversi_uang.dart';
import 'detail_page/konversi_waktu.dart';
import 'detail_page/kesan_pesan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String user = '';
  final String imageUrl =
      "https://akcdn.detik.net.id/community/media/visual/2018/05/23/6a879489-dfd2-4913-9208-0f2c590a9b83_169.jpeg?w=700&q=90";

  void getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    String stringValue = prefs.getString('username') ?? "";

    print(user);
    setState(() {
      user = stringValue;
    });
  }


  @override
  void initState() {
    super.initState();
    getValue();

  }

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.grey[200],
      ),
        body: ListView(
      children: [
        Container(
          height: screenHeight,
          color: Colors.black,
          child: Column(
            children: [
              SizedBox(height: 40),
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage("https://akcdn.detik.net.id/community/media/visual/2018/05/23/6a879489-dfd2-4913-9208-0f2c590a9b83_169.jpeg?w=700&q=90"),
              ),
              SizedBox(height: 16),
              Text(
                user,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 14),
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
                    MaterialPageRoute(
                        builder: (context) => TimeConversionPage()),
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
        )
      ],
    ));
  }
}
