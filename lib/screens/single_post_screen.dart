import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart ' as http;
import '../models/post_model.dart';

class SinglePostScreen extends StatefulWidget {
  const SinglePostScreen({super.key});

  @override
  State<SinglePostScreen> createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  Future<PostModel> getPostFromApi() async{
    try{
      String url = 'https://jsonplaceholder.typicode.com/posts/1';

      http.Response response = await http.get(Uri.parse(url));

      if( response.statusCode == 200){

        var jsonResponse = jsonDecode(response.body);

        PostModel postModel = PostModel.fromJson(jsonResponse);

        await Future.delayed(const Duration(seconds: 3));
        return postModel;

      }else{
        throw Exception('Something went wrong');
      }
    }catch(e){
      print(e.toString());

      return PostModel();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Single Post Screen')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
            future: getPostFromApi(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                PostModel posts = snapshot.data!;
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    PostModel post = posts ;
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
              } else if (snapshot.hasError) {
                return const Text('something working');
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
