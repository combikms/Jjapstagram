import 'package:flutter/material.dart';
import './style.dart' as style;

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
        ListView(
          children: [
            Home(),
            Home(),
            Home(),
          ],
        ),
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

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/car1.png'),
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('좋아요 100', style: TextStyle(fontWeight: FontWeight.bold,),),
                  Text('글쓴이'),
                  Text('글내용'),
              ]
            )
          )
        ],
      ),
    );
  }
}
