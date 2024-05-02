import 'package:firebase_core/firebase_core.dart';
import 'package:pocket_planner/firebase_options.dart';
import 'package:pocket_planner/screen/dashboard.dart';
import 'package:pocket_planner/screen/home_screen.dart';
// import 'package:pocket_planner/screen/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:pocket_planner/services/db.dart';

Future<void> main() async {
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  // Create an instance of your Db class
  // Db db = Db();

  // Add a user and obtain the generated user ID
  // String userId = await db.addUser();

  String userId = '354eb982-3ee2-429b-9cb7-6e1d8fb336e7';

  // Pass the generated user ID to the MyApp widget
  runApp(MyApp(userId: userId));
}

class MyApp extends StatelessWidget {
  final String userId;
  const MyApp({Key? key, required this.userId}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Planner Demo',
      builder: (context, child){
        return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
         child: child!);
      },

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
        home: Dashboard(userId: userId), // Pass the userId to HomeScreen

    );
  }
}