// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postio/components/addPost.dart';
import 'package:postio/components/home.dart';
import 'package:postio/components/post.dart';
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
  String username = "";
  var id;
  String email = "";
  var data;
  bool hasData = false;

  @override
  void initState() {
    super.initState();
    getData();
    getPost();
  }

  Future<void> getData() async {
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
        username = response.data["username"];
        id = response.data["id"];
        email = response.data["email"];
      });
    } on DioError catch (e) {
      logger.e("Error: $e");
    }
  }

  Future<void> getPost() async {
    final prefS = await SharedPreferences.getInstance();
    String? auth_token = prefS.getString("auth_token");
    logger.d("Logger :$auth_token");
    try {
      Response response = await Dio().get(
        "http://192.168.29.191:8000/api/post",
        options: Options(
          headers: {'Authorization': 'Token $auth_token'},
        ),
      );
      setState(() {
        data = response.data;
        hasData = true;
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
    if (hasData) {
      return RefreshIndicator(
        onRefresh: () async {
          await getData();
          setState(
            () {},
          );
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                Expanded(
                  child: Post(
                    data: data,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    heroTag: "btn1",
                    onPressed: () {
                      logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.exit_to_app,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    heroTag: "btn2",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPost(id: id),
                        ),
                      );
                    },
                    child: const Icon(
                      CupertinoIcons.add,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
