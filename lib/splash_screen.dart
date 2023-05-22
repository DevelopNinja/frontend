import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/Login/login.dart';
import 'package:frontend/Screens/CET.dart';
import 'package:frontend/Screens/Instructions.dart';
import 'package:frontend/Screens/jeemain.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: const Center(
          child: Image(
        image: AssetImage('lib/logo.png'),
        filterQuality: FilterQuality.high,
      )),
    ));
  }
}
