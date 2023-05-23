import 'package:flutter/material.dart';
import 'package:flutter_project_akhir_1/favorite_page.dart';
import 'login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'favorite_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MovieListPage(),
    FavoritePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black.withOpacity(0.5),
        selectedIconTheme: IconThemeData(color: Colors.black),
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 3) {
      _logout();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _logout() async {
    final SharedPreferences logindata = await SharedPreferences.getInstance();
    logindata.remove('login');
    logindata.remove('username');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
