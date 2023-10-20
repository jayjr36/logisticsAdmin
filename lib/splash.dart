// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';

import 'package:bcladmin/home.dart';
import 'package:bcladmin/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Adjust the rotation speed
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _startTimer() async {
    await Future.delayed(const Duration(seconds: 3));

    User? user = _auth.currentUser;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  const Home(itemCounts:{},)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 4, 28, 104),
      body: Center(
        child: RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
          child: CircleAvatar(
            radius: h * 0.15, // Adjust the size of the avatar
            backgroundColor: Colors.white,
            child: const Image(image: AssetImage('assets/bcl.png')),
          ),
        ),
      ),
    );
  }
}
