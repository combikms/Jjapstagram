import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jjapstagram/notification.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (c) => Store(),
      child: MaterialApp(
        theme: style.theme,
        home: MyApp()
      ),
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
  var userImage;

  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    setState(() {
      post =jsonDecode(result.body);
    });
  }

  @override
  void initState() {
    super.initState();
    initNotification(context);
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
      floatingActionButton: FloatingActionButton(onPressed: (){
        showNotification();
      }, child: Text('+'),),
      appBar: AppBar(
        title: Text('Jjapstagram'),
        actions: [
          IconButton(onPressed: () async {
            var picker = ImagePicker();
            var image = await picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              setState(() {
                userImage = File(image.path);
              });
            }

            Navigator.push(context,
              MaterialPageRoute(builder: (c) => Upload(userImage: userImage, addPost: (newPost) {
                setState(() {
                  post = [newPost, ...post];
                });
              }))
            );
          }, icon: Icon(Icons.add_box_outlined))
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

class Store extends ChangeNotifier {
  var name = 'john kim';
  var followers = 0;
  var isFollowed = false;
  var profileImage = [];

  handleFollow() {
    isFollowed = isFollowed ? false : true;
    followers = isFollowed ? followers + 1 : followers - 1;
    notifyListeners();
  }

  getImages() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    profileImage = jsonDecode(result.body);
    notifyListeners();
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
          post['image'] is String ? Image.network(post['image'].toString()) : Image.file(post['image']),
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('좋아요 ${post['likes'].toString()}', style: TextStyle(fontWeight: FontWeight.bold,),),
                  GestureDetector(
                    child: Text(post['user'].toString()),
                    onTap: () {
                      var store = context.read<Store>();
                      if (store.profileImage.isEmpty) {
                        store.getImages();
                      }
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (c) => Profile()),
                      );
                    },
                  ),
                  Text(post['content'].toString()),
              ]
            )
          )
        ],
      ),
    );
  }
}


class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<Store>().name)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileHeader(),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
                (c, i) => Image.network(context.watch<Store>().profileImage[i]),
                childCount: context.watch<Store>().profileImage.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          )
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.circle, size: 50.0),
          Text("팔로워 ${context.watch<Store>().followers.toString()}명"),
          ElevatedButton(
              onPressed: () {
                context.read<Store>().handleFollow();
              }, child: Text('팔로우')
          )
        ],
      ),
    );
  }
}



class Upload extends StatelessWidget {
  Upload({Key? key, this.userImage, this.addPost}) : super(key: key);
  final userImage;
  final addPost;
  var content = TextEditingController();
  @override

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( actions: [
          IconButton(onPressed: (){
            var newPost = {
              'id': 100,
              'image': userImage,
              "likes": 30,
              "date": "Sept 30",
              "content": content.text,
              "liked": false,
              "user": 'Kang',
            };
            addPost(newPost);
            Navigator.pop(context);
          }, icon: Icon(Icons.send))
        ],),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(userImage),
            TextField(controller: content,),
          ],
        )
    );

  }
}