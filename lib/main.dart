// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:postio/components/home.dart';
import 'package:postio/components/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

Future<String> getAuthToken() async {
  final prefS = await SharedPreferences.getInstance();
  return prefS.getString("auth_token") ?? "";
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  String authToken = await getAuthToken();
  runApp(MyApp(
    auth_token: authToken,
  ));
}

class MyApp extends StatelessWidget {
  final String auth_token;
  const MyApp({super.key, required this.auth_token});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          background: Colors.white,
        ),
        textTheme: GoogleFonts.caveatTextTheme(
          textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: "PostIO",
      home: auth_token.isEmpty ? const HomePage() : const Dashboard(),
    );
  }
}
