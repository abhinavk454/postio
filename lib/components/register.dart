// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email = "";
  String username = "";
  String password = "";
  bool isClicked = false;
  var logger = Logger();

  Future<void> _Register() async {
    Dio dio = Dio();
    try {
      Response response = await dio.post(
        "http://192.168.29.191:8000/api/auth/users/",
        data: {
          "email": email,
          "username": username,
          "password": password,
        },
      );

      if (response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: "Successfully Registered",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(
        msg: e.response.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 25.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 200.0,
              ),
              const Text("Register to PostIO"),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email Address",
                  hintText: "Please enter your email address",
                ),
                validator: (value) {
                  if (value != null) {
                    if (value.isEmpty) {
                      return "Please enter a valid email";
                    }
                    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return "Please enter a valid email";
                  } else {
                    return "Please enter a valid email";
                  }
                },
                onChanged: (value) {
                  email = value;
                  setState(
                    () {},
                  );
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Username",
                  hintText: "Please enter username",
                ),
                onChanged: (value) {
                  username = value;
                  setState(
                    () {},
                  );
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Please enter password",
                ),
                onChanged: (value) {
                  password = value;
                  setState(
                    () {},
                  );
                },
              ),
              const SizedBox(
                height: 130.0,
              ),
              InkWell(
                onTap: () {
                  _Register().then(
                    (value) => {
                      Navigator.pop(context),
                    },
                  );
                  setState(() {
                    isClicked = true;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(seconds: 2),
                  width: 150,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.lime[600],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: !isClicked
                      ? const Text(
                          "Register",
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
            ],
          ),
        ),
      ),
    );
  }
}
