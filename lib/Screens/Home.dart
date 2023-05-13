import 'package:flutter/material.dart';
import 'package:frontend/Screens/Filter_College.dart';
import 'package:frontend/Screens/Profile.dart';
import 'package:frontend/Screens/Instructions.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final tabs = [
    const Center(child: Instruc()),
    Center(child: Filter()),
    const Center(child: Profile_Details()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'College Recommendation',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 129, 182, 248),
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Filter College',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              label: 'Profile',
              backgroundColor: Colors.blue),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
