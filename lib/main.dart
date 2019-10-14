import 'package:flutter/material.dart';
import 'package:kurzprojekt/about_us/about_us_page.dart';
import 'package:kurzprojekt/favourites/favourites_page.dart';
import 'package:kurzprojekt/home/home_page.dart';

main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kurzprojekt',
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (_) => RootPage());
      },
    );
  }
}

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final List<BottomNavigationBarItem> _barItems =
      List.unmodifiable(<BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Home'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.star_border),
      activeIcon: Icon(Icons.star),
      title: Text('Favoriten'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.group),
      title: Text('Über uns'),
    ),
  ]);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kurzprojekt'),
      ),
      body: _selectPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: _barItems,
        onTap: (int index) => setState(() => _currentPage = index),
        currentIndex: _currentPage,
      ),
    );
  }

  Widget _selectPage() {
    switch (_currentPage) {
      case 0:
        return HomePage();
      case 1:
        return FavouritesPage();
      case 2:
        return AboutUsPage();
      default:
        return HomePage();
    }
  }
}
