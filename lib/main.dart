import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pocket_planner/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:pocket_planner/screen/splash_screen.dart';
import 'package:pocket_planner/services/db.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Create an instance of your Db class
  Db db = Db();

  // Get an instance of shared_preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check if the user ID exists in shared_preferences
  String? userId = prefs.getString('userId');

  // If the user ID doesn't exist, create a new user and store the generated user ID in shared_preferences
  if (userId == null) {
    userId = await db.addUser();
    await prefs.setString('userId', userId);
  }

  // Pass the generated user ID to the MyApp widget
  runApp(MyApp(userId: userId));
}

class MyApp extends StatelessWidget {
  final String userId;
  const MyApp({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Planner',
      builder: (context, child){
        return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!);
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade600),
        useMaterial3: true,
      ),
      home: SplashScreen(userId: userId), // Pass the userId to HomeScreen
    );
  }
}