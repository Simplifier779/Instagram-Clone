import 'package:climate/models/user.dart';
import 'package:climate/resources/firestore_methods.dart';
import 'package:climate/screens/comments_screen.dart';
import 'package:climate/utils/colors.dart';
import 'package:climate/utils/dimensions.dart';
import 'package:climate/utils/utils.dart';
import 'package:climate/widgets/like_animation.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostCard extends StatefulWidget {
  final snap; //if snap is declared in _PostCard it will directly be called as snap.   but since it is declared here with the constructor, in the main and it is not private we have to call it with the widget.snap
  const PostCard({
    super.key,
    required this.snap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;
//INIT: Called when this object is inserted into the tree.The framework will call this method exactly once for each State object it creates.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      //could have used stream builder also here
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

//document snapshot is used after we put get on doc and query snapshot is used after we put get on collection.
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: width > WebScreenSize ? secondaryColor : mobileBackgroundColor,
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          //Header Section
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(
              right: 0,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    widget.snap['profImage'].toString(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          shrinkWrap: true,
                          children: [
                            'Delete',
                          ]
                              .map(
                                (e) => InkWell(
                                  onTap: () async {
                                    FirestoreMethods()
                                        .deletePost(widget.snap['postId']);
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    child: Text(e),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.more_vert,
                  ),
                ),
              ],
            ),
          ),
          //Image Section
          //If you just want to display the image as a widget on screen use Image.network and use NetworkImage wherever an ImageProvider is expected.
          //NetworkImage class creates an object the provides an image from the src URL passed to it. It is not a widget and does not output an image to the screen. Image.network creates a widget that displays an image on the screen.
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                widget.snap['postId'],
                user.uid,
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    //'data:image/jpeg;base64,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',
                    fit: BoxFit.cover,
                  ),
                  //BoxFit. fill shrinks the image,while BoxFit. Cover leads to hide some parts of the image BoxFit. fill shrinks the image,while BoxFit. Cover leads to hide some parts of the image
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(Icons.favorite,
                        color: Colors.white, size: 120),
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          //Like Comment Section
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(
                      widget.snap['postId'],
                      user.uid,
                      widget.snap['likes'],
                    );
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(
                      snap: widget.snap,
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          //Description and comments
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyText2,
                    //textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    //rich text is like a row widget for the texts.
                    text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                            text: widget.snap['username'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: widget.snap['description'].toString(),
                          ),
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all ${commentLen} comments',
                      style:
                          const TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '2002',
                    /* DateFormat.yMMMd().format(
                      widget.snap['datePublished'].toDate(),
                    ),*/
                    style: const TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
