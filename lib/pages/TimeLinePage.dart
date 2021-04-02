import 'package:buddiesgram/models/user.dart';
import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/widgets/HeaderWidget.dart';
import 'package:buddiesgram/widgets/PostWidget.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimeLinePage extends StatefulWidget {
  final User gCurrentUser;

  TimeLinePage({this.gCurrentUser});

  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  List<Post> posts;
  List<String> followingsList = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  retrieveTimeLine() async {
    QuerySnapshot querySnapshot = await timelineRefrence
        .doc(widget.gCurrentUser.id)
        .collection("timelinePosts")
        .orderBy("timestamp", descending: true)
        .get();

    List<Post> allPosts = querySnapshot.docs
        .map((document) => Post.fromDocument(document))
        .toList();

    setState(() {
      this.posts = allPosts;
    });
  }

  retrieveFollowings() async {
    QuerySnapshot querySnapshot = await followingRefrence
        .doc(currentUser.id)
        .collection("userFollowing")
        .get();

    setState(() {
      followingsList =
          querySnapshot.docs.map((document) => document.id).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    retrieveTimeLine();
    retrieveFollowings();
  }

  createUserTimeLine() {
    if (posts == null) {
      return circularProgress();
    } else {
      //return ListView(children: posts,);
      return SingleChildScrollView(
        // Beispiel aus https://medium.com/flutterfly-tech/flutter-listview-gridview-ce7177812b1d
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: posts,
                ),
              ),
              Container(
                height: 200,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 100,
                      color: Colors.yellowAccent,
                    ),
                    Container(
                      width: 50,
                      height: 100,
                      color: Colors.blue,
                    ),
                    Container(
                      width: 50,
                      height: 100,
                      color: Colors.green,
                    ),
                    Container(
                      width: 50,
                      height: 100,
                      color: Colors.red,
                    ),
                    Container(
                      width: 50,
                      height: 100,
                      color: Colors.yellowAccent,
                    ),
                    Container(
                      width: 50,
                      height: 100,
                      color: Colors.blue,
                    ),
                    Container(
                      width: 50,
                      height: 100,
                      color: Colors.green,
                    ),
                    Container(
                      width: 50,
                      height: 100,
                      color: Colors.red,
                    )
                  ],
                ),
              ),
              Container(
                height: 200,
                child: GridView.count(
                  scrollDirection: Axis.horizontal,
                  crossAxisCount: 2,
                  children: List.generate(50, (index) {
                    return Container(
                      child: Card(
                        color: Colors.amber,
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      key: _scaffoldKey,

      //appBar: header(context, isAppTitle: true,),
      appBar: header(
        context,
        strTitle: "Deine TimeLine",
      ),

      body: RefreshIndicator(
          child: createUserTimeLine(), onRefresh: () => retrieveTimeLine()),
    );
  }
}
