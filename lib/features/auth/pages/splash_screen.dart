import 'package:flutter/material.dart';
import '../../../core/helpers.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("assets/images/splashscreen.png"),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Svvg.asset("meninki_big_transparent"),
              Text(
                lg.splashTitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          Align(alignment: Alignment.bottomCenter, child: Svvg.asset("meninki_letter")),
        ],
      ),
    );
  }
}
