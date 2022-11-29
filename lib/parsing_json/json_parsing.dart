// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class JsonParsingSimple extends StatefulWidget {
  @override
  State<JsonParsingSimple> createState() => _JsonParsingSimple();
}

class _JsonParsingSimple extends State<JsonParsingSimple> {
  late Future data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parsing Json"),
      ),
      body: Center(
          child: Container(
        child: FutureBuilder(
            future: getData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return createListView(snapshot.data, context);
                //return Text(snapshot.data[0]['userId'].toString());
              }
              return CircularProgressIndicator();
            }),
      )),
    );
  }

  Future getData() async {
    Future data;
    String url = "https://jsonplaceholder.typicode.com/posts";
    Network network = Network(url: url);

    data = network.featchData();
    // data.then((value) {
    // print(value);
    // });

    return data;
  }

  Widget createListView(List data, BuildContext context) {
    return Container(
      child: ListView.builder(
        
        itemCount: data.length,
        itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Divider(height: 5.0),
            ListTile(
              title: Text("${data[index]["title"]}"),
              subtitle: Text("${data[index]["body"]}"),
              leading: Column(children: [
                CircleAvatar(
                  backgroundColor: Colors.black45,
                  radius: 23,
                  child: Text("${data[index]["id"]}"),
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

  Future featchData() async {
    print("$url");
    Response response = await get(Uri.parse(Uri.encodeFull(url)));

    if (response.statusCode == 200) {
      // print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }
}
