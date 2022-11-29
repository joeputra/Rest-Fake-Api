import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rest_api/model/Post.dart';

class JsonParsingMap extends StatefulWidget {
  const JsonParsingMap({super.key});

  @override
  State<JsonParsingMap> createState() => _JsonParsingMapState();
}

class _JsonParsingMapState extends State<JsonParsingMap> {
  late Future<PostList> data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Network network =
        Network(url: "https://jsonplaceholder.typicode.com/posts");
    data = network.loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PODO"),
      ),
      body: Center(
          child: Container(
        child: FutureBuilder(
            future: data,
            builder: ((context, AsyncSnapshot<PostList> snapshot) {
              List<Post> allPost;
              if (snapshot.hasData) {
                allPost = snapshot.data!.posts;
                return createListView(allPost, context);
              } else {
                return CircularProgressIndicator();
              }
            })),
      )),
    );
  }

  Widget createListView(List<Post> data, BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, int index) {
            return Column(
              children: [
                Divider(
                  height: 5.0,
                ),
                ListTile(
                  title: Text("${data[index].title}"),
                  subtitle: Text("${data[index].body}"),
                  leading: Column(children: [
                    CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 23,
                      child: Text('${data[index].id}'),
                    )
                  ]),
                )
              ],
            );
          }),
    );
  }
}

class Network {
  final String url;
  Network({
    required this.url,
  });

  Future<PostList> loadPosts() async {
    final Response response = await get(Uri.parse(Uri.encodeFull(url)));

    if (response.statusCode == 200) {
      return PostList.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to get post");
    }
  }
}
