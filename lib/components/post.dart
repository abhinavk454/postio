import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  final List<dynamic> data;
  const Post({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final post = data[index];
        return Card(
          child: ListTile(
            title: Text(
              post["title"].toString(),
            ),
            subtitle: Text(
              post["content"].toString(),
            ),
            trailing: Text(
              post["author"].toString(),
            ),
          ),
        );
      },
    );
  }
}
