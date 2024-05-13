import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket_planner/screen/dashboard.dart';

class SplashScreen extends StatefulWidget {
 final String userId; // Add userId as a parameter

  SplashScreen({Key? key, required this.userId}) : super(key: key);


  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
 with SingleTickerProviderStateMixin {

  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => Dashboard(userId: widget.userId))
      );
    });
  }

    @override
    void dispose(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.pink],
            begin: Alignment.topRight,
            end:  Alignment.bottomLeft )),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Splash Screen',
          style: TextStyle(color: Colors.green, fontSize: 35),)
        ],
      ),
      ),
    );
  }
}