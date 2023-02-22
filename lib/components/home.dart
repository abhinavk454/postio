import 'package:flutter/cupertino.dart';
import 'package:postio/components/dashboard.dart';
import 'package:postio/components/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "";
  String password = "";
  String token = "";
  bool isClicked = false;
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  Future<void> _login() async {
    Dio dio = Dio();
    try {
      Response response = await dio.post(
        "http://192.168.29.191:8000/api/auth/token/login",
        data: {
          "username": username,
          "password": password,
        },
      );
      if (response.statusCode == 200) {
        final prefS = await SharedPreferences.getInstance();
        try {
          token = response.data["auth_token"];
          await prefS.setString("auth_token", token);
        } catch (e) {
          logger.e("Error: $e");
        }
      } else {
        logger.d(response.statusCode);
        if (response.statusCode == 400) {
          // toast message for invalid credentials
          Fluttertoast.showToast(
            msg: "Invalid username or password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          logger.e("Error: ${response.statusCode}");
        }
      }
    } on DioError catch (e) {
      setState(() {
        isClicked = false;
      });
      if (e.response != null) {
        logger.e("Error response: ${e.response}");
        Fluttertoast.showToast(
          msg: "Invalid username or password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Network error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 100.0,
            ),
            const Icon(
              CupertinoIcons.heart_fill,
              color: Colors.red,
              size: 30.0,
            ),
            const Text(
              "PostIO",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 100.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 17.0,
                horizontal: 34.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Username",
                      hintText: "Enter your username",
                      icon: Icon(
                        CupertinoIcons.person,
                      ),
                    ),
                    onChanged: (value) => {
                      username = value,
                      setState(
                        () {},
                      ),
                    },
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      icon: Icon(
                        CupertinoIcons.gear,
                      ),
                    ),
                    onChanged: (value) => {
                      password = value,
                      setState(
                        () {},
                      ),
                    },
                  ),
                  const SizedBox(
                    height: 120.0,
                  ),
                  InkWell(
                    onTap: () {
                      _login().then(
                        (value) => {
                          if (token.isNotEmpty)
                            {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Dashboard(),
                                ),
                              ),
                            }
                        },
                      );
                      setState(
                        () {
                          isClicked = true;
                        },
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      width: 150,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: !isClicked
                          ? const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          : const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the register page here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Register(),
                        ),
                      );
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: 'Don\'t have an account? ',
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Register',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
