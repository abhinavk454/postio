// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:postio/components/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var logger = Logger();
  var _data = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  // find data from backend api using auth_token and display it on dashboard
  Future<void> getData() async {
    // fetch auth_token from shared preferences
    final prefS = await SharedPreferences.getInstance();
    String? auth_token = prefS.getString("auth_token");
    logger.d("Logger :$auth_token");
    try {
      Response response = await Dio().get(
        "http://192.168.29.191:8000/api/auth/users/me/",
        options: Options(
          headers: {'Authorization': 'Token $auth_token'},
        ),
      );

      setState(() {
        _data = response.data["username"];
      });
    } on DioError catch (e) {
      logger.e("Error: $e");
    }
  }

  // logout user and clear auth_token from shared preferences
  Future<void> logout() async {
    final prefS = await SharedPreferences.getInstance();
    prefS.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 250.0,
            ),
            Text("Welcome $_data"),
            ElevatedButton(
              onPressed: () async {
                logout().then(
                  (value) => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    ),
                  },
                );
              },
              child: const Text("Log Out"),
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   body: Center(
    //     child: Text("Welcome $_data"),
    //   ),
    //   drawer: Drawer(
    //     width: 250.0,
    //     child: ListView(
    //       children: [
    //         DrawerHeader(
    //           padding: EdgeInsets.zero,
    //           margin: EdgeInsets.zero,
    //           child: UserAccountsDrawerHeader(
    //             accountName: Text("Hello jiv $_data"),
    //             accountEmail: const Text("abc@dj.ef"),
    //           ),
    //         ),
    //         ElevatedButton(
    //           style: ButtonStyle(),
    //           onPressed: () async {
    //             logout().then(
    //               (value) => {
    //                 Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                     builder: (context) => const HomePage(),
    //                   ),
    //                 ),
    //               },
    //             );
    //           },
    //           child: const Text(
    //             "Log Out",
    //             style: TextStyle(fontWeight: FontWeight.w600),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    //   bottomNavigationBar: BottomNavigationBar(
    //     items: const <BottomNavigationBarItem>[
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.home),
    //         label: 'Home',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.business),
    //         label: 'Business',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.school),
    //         label: 'School',
    //       ),
    //     ],
    //     // currentIndex: _selectedIndex,
    //     selectedItemColor: Colors.amber[800],
    //     // onTap: _onItemTapped,
    //   ),
    // );
  }
}
