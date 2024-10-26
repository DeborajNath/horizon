import 'package:flutter/material.dart';
import 'package:horizon/constants/index.dart';
import 'package:horizon/main_screens/index.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      RoutingService.gotoWithoutBack(context, const LoginPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.transparent,
        child: Image.asset(
          "assets/splashScreen.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
