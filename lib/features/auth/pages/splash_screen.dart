import 'package:flutter/material.dart';
import '../../../core/helpers.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Svvg.asset("main_logo"),
            const Box(h: 20),
            Svvg.asset("timixhr"),
            const Box(h: 30),
          ],
        ),
      ),
    );
  }
}
