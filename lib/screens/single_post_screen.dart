import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart ' as http;

import '../models/post_model.dart';

class SinglePostScreen extends StatefulWidget {
  const SinglePostScreen({super.key});

  @override
  State<SinglePostScreen> createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  Future<List<PostModel>> getJsonFromApi() async {
    List<PostModel> posts = [];
    String url = 'https://jsonplaceholder.typicode.com/posts/1';

    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      for (var jsonPost in jsonResponse) {
        PostModel postModel = PostModel.fromJson(jsonPost);
        posts.add(postModel);
      }
      return posts;
    } else {
      throw Exception('Something wrong ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getJsonFromApi(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<PostModel> posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                PostModel post = posts[index];
                return Card(
                  color: Colors.green,
                  child: Column(
                    children: [
                      Text(
                        'Post Id: ${post.id}',
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        'User Id: ${post.userId}',
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        'Title: ${post.title}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        'Body: ${post.body}',
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                );
              },
            );

          }
    else if (snapshot.hasError) {
    return const Text('something working');
    } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
