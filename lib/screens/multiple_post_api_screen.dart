import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/post_model.dart';
import 'package:http/http.dart' as http;

class MultiplePostApiScreen extends StatefulWidget {
  const MultiplePostApiScreen({super.key});

  @override
  State<MultiplePostApiScreen> createState() => _MultiplePostApiScreenState();
}

class _MultiplePostApiScreenState extends State<MultiplePostApiScreen> {
  Future<List<PostModel>> getPostFromApi() async {
    List<PostModel> posts = [];

    String url = 'https://jsonplaceholder.typicode.com/posts';
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      for (var jsonPost in jsonResponse) {
        PostModel postModel = PostModel.fromJson(jsonPost);
        posts.add(postModel);
      }

      return posts;
    } else {
      throw Exception('Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Post API')),
        ),
        body: FutureBuilder(
            future: getPostFromApi(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<PostModel> posts = snapshot.data!;

                return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      PostModel postModel = posts[index];

                      return Card(
                        color: Colors.amber,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text('User ID ${postModel.userId}'),
                              Text('ID ${postModel.id}'),
                              Text(
                                postModel.title!,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style:const  TextStyle(fontSize: 40),
                              ),
                             const Divider(),
                              Text(
                                postModel.body!,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                return const Text('something working');
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
