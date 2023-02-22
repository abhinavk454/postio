// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:postio/components/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';

class AddPost extends StatefulWidget {
  final id;
  const AddPost({super.key, required this.id});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String title = "";
  String description = "";
  var logger = Logger();

  Future<void> createPost() async {
    Dio dio = Dio();
    final prefS = await SharedPreferences.getInstance();
    String? auth_token = prefS.getString("auth_token");
    try {
      Response response = await dio.post(
        "http://192.168.29.191:8000/api/post/",
        data: {
          "title": title,
          "author": widget.id,
          "content": description,
        },
        options: Options(
          headers: {'Authorization': 'Token $auth_token'},
        ),
      );
      if (response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: "Successfully created",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        setState(
          () {
            title = "";
            description = "";
          },
        );
      }
    } on DioError catch (e) {
      logger.e(e);
      Fluttertoast.showToast(
        msg: "Failed to create the post.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 100.0,
            ),
            const Icon(
              CupertinoIcons.heart_circle_fill,
              size: 50.0,
              color: Colors.red,
            ),
            Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Enter your title",
                    labelText: "Title",
                    icon: Icon(
                      CupertinoIcons.pencil,
                    ),
                  ),
                  onChanged: (value) => {
                    title = value,
                    setState(
                      () {},
                    ),
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Write your description",
                    labelText: "Description",
                    icon: Icon(
                      CupertinoIcons.doc_append,
                    ),
                  ),
                  onChanged: (value) => {
                    description = value,
                    setState(
                      () {},
                    ),
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 200.0,
            ),
            ElevatedButton(
              onPressed: () {
                createPost();
              },
              child: const Text("Add Post"),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Dashboard(),
                    ),
                  );
                },
                child: const Icon(
                  CupertinoIcons.return_icon,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
