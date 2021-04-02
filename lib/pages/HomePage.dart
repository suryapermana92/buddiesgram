import 'dart:io';
import 'package:buddiesgram/models/user.dart';
import 'package:buddiesgram/pages/CreateAccountPage.dart';
import 'package:buddiesgram/pages/NotificationsPage.dart';
import 'package:buddiesgram/pages/ProfilePage.dart';
import 'package:buddiesgram/pages/SearchPage.dart';
import 'package:buddiesgram/pages/TimeLinePage.dart';
import 'package:buddiesgram/pages/GameScorePage.dart';
import 'package:buddiesgram/pages/UploadPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn gSignIn = GoogleSignIn();

CollectionReference usersReference =
    FirebaseFirestore.instance.collection("users");
final firebase_storage.Reference storageReference =
    firebase_storage.FirebaseStorage.instance.ref().child("Posts Pictures");
final postsReference = FirebaseFirestore.instance.collection("posts");
final activityFeedReference = FirebaseFirestore.instance.collection("feed");
final commentsRefrence = FirebaseFirestore.instance.collection("comments");
final followersRefrence = FirebaseFirestore.instance.collection("followers");
final followingRefrence = FirebaseFirestore.instance.collection("following");
final timelineRefrence = FirebaseFirestore.instance.collection("timeline");
final gamescoreRefrence = FirebaseFirestore.instance.collection("gamescore");

final DateTime timestamp = DateTime.now();
User currentUser;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSignedIn = false;
  PageController pageController;
  int getPageIndex = 0;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();

    pageController = PageController();

    gSignIn.onCurrentUserChanged.listen((gSigninAccount) {
      controlSignIn(gSigninAccount);
    }, onError: (gError) {
      print("Error Message: " + gError);
    });

    gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }).catchError((gError) {
      print("Error Message: " + gError);
    });
  }

  saveUserInfoToFireStore() async {
    final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
    DocumentSnapshot documentSnapshot =
        await usersReference.doc(gCurrentUser.id).get();

    if (!documentSnapshot.exists) {
      final username = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => CreateAccountPage()));

      usersReference.doc(gCurrentUser.id).set({
        "id": gCurrentUser.id,
        "profileName": gCurrentUser.displayName,
        "username": username,
        "url": gCurrentUser.photoUrl,
        "email": gCurrentUser.email,
        "bio": "",
        "timestamp": timestamp,
      });

      await followersRefrence
          .doc(gCurrentUser.id)
          .collection("userFollowers")
          .doc(gCurrentUser.id)
          .set({});

      documentSnapshot = await usersReference.doc(gCurrentUser.id).get();
    }

    currentUser = User.fromDocument(documentSnapshot);
  }

  controlSignIn(GoogleSignInAccount signInAccount) async {
    if (signInAccount != null) {
      await saveUserInfoToFireStore();

      setState(() {
        isSignedIn = true;
      });

      configureRealTimePushNotifications();
    } else {
      setState(() {
        isSignedIn = false;
      });
    }
  }

  getIOSPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print("Settings Registered :  $settings");
  }

  configureRealTimePushNotifications() {
    final GoogleSignInAccount gUser = gSignIn.currentUser;

    if (Platform.isIOS) {
      getIOSPermissions();
    }

    _firebaseMessaging.getToken().then((token) {
      usersReference.doc(gUser.id).update({"androidNotificationToken": token});
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final String recipientId = message.data["recipient"];
      final String body = message.data["body"];

      if (recipientId == gUser.id) {
        SnackBar snackBar = SnackBar(
          backgroundColor: Colors.grey,
          content: Text(
            body,
            style: TextStyle(color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }

  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  loginUser() {
    gSignIn.signIn();
  }

  logoutUser() {
    gSignIn.signOut();
  }

  whenPageChanges(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  onTapChangePage(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 400),
      curve: Curves.bounceInOut,
    );
  }

  Scaffold buildHomeScreen() {
    return Scaffold(
      key: _scaffoldKey,
      body: PageView(
        children: <Widget>[
          TimeLinePage(
            gCurrentUser: currentUser,
          ),
          SearchPage(),
          UploadPage(
            gCurrentUser: currentUser,
          ),
          NotificationsPage(),
          GameScorePage(),
          ProfilePage(userProfileId: currentUser?.id),
        ],
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap: onTapChangePage,
        backgroundColor: Theme.of(context).accentColor,
        activeColor: Colors.white,
        inactiveColor: Colors.blueGrey,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
            Icons.home,
            color: Colors.white,
            size: 28.0,
          )),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.search,
            color: Colors.white,
            size: 28.0,
          )),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.photo_camera,
            color: Colors.white,
            size: 36.0,
          )),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.favorite,
            color: Colors.white,
            size: 28.0,
          )),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.gamepad,
            color: Colors.white,
            size: 28.0,
          )),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.person,
            color: Colors.white,
            size: 28.0,
          )),
        ],
      ),
    );
  }

  Scaffold buildSignInScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "funnet.online",
              style: TextStyle(
                  fontSize: 48.0,
                  color: Colors.white,
                  fontFamily: "Fira Sans Condensed"),
            ),
            GestureDetector(
              onTap: loginUser,
              child: Container(
                width: 270.0,
                height: 56.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/google_signin_button.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isSignedIn) {
      return buildHomeScreen();
    } else {
      return buildSignInScreen();
    }
  }
}
