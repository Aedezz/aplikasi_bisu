// import 'package:aplikasi_bisu/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aplikasi_bisu/page/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoOpacity;
  late AnimationController _progressController;
  late Animation<double> _progressOpacity;
  late Animation<double> _progressWidth;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(_logoController)
      ..addListener(() {
        setState(() {});
      });

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressOpacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(_progressController)
      ..addListener(() {
        setState(() {});
      });

    _progressWidth = Tween<double>(begin: 0.0, end: 100.0) // Final width of the progress indicator
        .animate(CurvedAnimation(parent: _progressController, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {});
      });

    _logoController.forward().whenComplete(() {
      _progressController.forward().whenComplete(() {
        Future.delayed(const Duration(seconds: 1), () {
          _progressController.reverse().whenComplete(() {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => HomePage()),
            );
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [Color(0xff042434), Color(0xff063248), Colors.blueGrey],
          //   begin: Alignment.topRight,
          //   end: Alignment.bottomLeft,
          // ),
          color: Colors.blueGrey
        ),
        child: Center(
          child: Opacity(
            opacity: _logoOpacity.value,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/sleepy.png', width: 100, height: 80), // Your logo
                Opacity(
                  opacity: _progressOpacity.value,
                  child: Container(
                    width: _progressWidth.value,
                    height: 4,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white.withOpacity(0.5),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
