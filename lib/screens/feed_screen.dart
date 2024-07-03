import 'package:climate/utils/colors.dart';
import 'package:climate/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:climate/utils/dimensions.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:
          width > WebScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > WebScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 32,
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.messenger_outline,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
      //DISPLAYING THE POSTS
      //StreamBuilder is a widget that builds itself based on the latest snapshot of interaction with a stream. This is mainly used in applications like chat application clock applications where the widget needs to rebuild itself to show the current snapshot of data.
      body: StreamBuilder(
        //cant use get here because it will return in future and we are not using async await future here in stream builder.
        stream: FirebaseFirestore.instance
            .collection('posts')
            .snapshots(), //if we want to display a specific post we can call with the help of document id.
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > WebScreenSize ? width * 0.3 : 0,
                vertical: width > WebScreenSize ? 15 : 0,
              ),
              child: PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        },
      ),
    );
  }
}
