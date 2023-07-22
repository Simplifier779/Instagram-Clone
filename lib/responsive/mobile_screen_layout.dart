import 'package:climate/providers/user_provider.dart';
import 'package:climate/screens/feed_screen.dart';
import 'package:climate/screens/profile_screen.dart';
import 'package:climate/screens/search_screen.dart';
import 'package:climate/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:climate/models/user.dart' as model;
import 'package:climate/utils/dimensions.dart';
import 'package:climate/screens/add_post_screen.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  /* One way to display username of the user as soon as he logs in. not using this because we will have to copy this entire code to another screen if we wish to do the same there also. Not a efficient way of coding.
  String username = "";

  @override //runs at the start of the application to show the username.Ths method is called only once.
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsername();
  }

  void getUsername() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get(); //this is one time view like a snapshot /. gets the entire data of the user

    setState(() {
      username = (snap.data() as Map<String, dynamic>)[
          'username']; //object over here is a map and can access the username property
    });
  }
  */

  @override
  Widget build(BuildContext context) {
    /*model.User user = Provider.of<UserProvider>(context).getUser;*/
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home,
                color: _page == 0 ? primaryColor : secondaryColor,
              ),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.search,
                color: _page == 1 ? primaryColor : secondaryColor,
              ),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.add_circle,
                color: _page == 2 ? primaryColor : secondaryColor,
              ),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.favorite,
                color: _page == 3 ? primaryColor : secondaryColor,
              ),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.person,
                color: _page == 4 ? primaryColor : secondaryColor,
              ),
              label: '',
            ),
          ],
          selectedIndex: _page,
          onDestinationSelected: (int index) {
            //this updates the selectedIndex
            setState(() {
              _page = index;
            });
          },
          backgroundColor: mobileBackgroundColor,
        ),
        /*body: Center(child: Text(user.username)),*/
        body: [
          FeedScreen(),
          SearchScreen(),
          AddPostScreen(),
          Text('notif'),
          ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
        ][_page]);
  }
}
