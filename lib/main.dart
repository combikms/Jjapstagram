import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';

void main() {
  runApp(
    MaterialApp(
      theme: style.theme,
      home: MyApp()
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var post = [];
  var scroll = ScrollController();

  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    setState(() {
      post =jsonDecode(result.body);
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    scroll.addListener(() async {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        var result = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
        setState(() {
          post = [...post, jsonDecode(result.body)];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jjapstagram'),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.add_box_outlined))
        ],
      ),
      body: [
        ListView(controller: scroll, children: List.generate(post.length, (i) => Post(post: post[i]))),
        Text('Shop')
      ][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i) {
          setState(() {
            tab = i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label:'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: "Shop"),
        ],
      ),
    );
  }
}

class Post extends StatelessWidget {
  const Post({super.key, this.post});
  final post;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(post['image'].toString()),
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('좋아요 ${post['likes'].toString()}', style: TextStyle(fontWeight: FontWeight.bold,),),
                  Text(post['user'].toString()),
                  Text(post['content'].toString()),
              ]
            )
          )
        ],
      ),
    );
  }
}
