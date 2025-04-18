import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinyq/data/firebase_service/firestor.dart';
import 'package:tinyq/util/image_cached.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tinyq/widgets/comment.dart';

class ProfileScreen extends StatefulWidget {
  String Uid;
  ProfileScreen(this.Uid, {super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int post_length = 0;
  bool yours = false;
  List following = [];
  bool isfollow = false;
  Future<void> _signOut(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
  }
  @override
  void initState() {
    super.initState();
    getdata();
    if (_auth.currentUser!.uid == widget.Uid) {
      setState(() {
        yours = true;
      });
    }
  }

  getdata() async {
    DocumentSnapshot snap = await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    following = (snap.data()! as dynamic)['following'];
    if (following.contains(widget.Uid)) {
      setState(() {
        isfollow = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF5590FF),
        ),
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: FutureBuilder(
                  future: Firebase_Firestor().getUser(UID: widget.Uid),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          // Profile image and Name
                          Padding(
                            padding: EdgeInsets.all(28.0),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: SizedBox(
                                    width: 70.w,
                                    height: 70.h,
                                    child: CachedImage(snapshot.data!.profile),
                                  ),
                                ),
                                SizedBox(
                                  width: 35.w,
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.data!.username,
                                        style: TextStyle(
                                            fontSize: 19.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        snapshot.data!.major,
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            color: const Color.fromARGB(
                                                255, 172, 169, 169)),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 30.w,
                                ),
                                Visibility(
                                  visible: !isfollow,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (yours == false) {
                                        Firebase_Firestor()
                                            .flollow(uid: widget.Uid);
                                        setState(() {
                                          isfollow = true;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 236, 117, 117), // สีเหลืองอ่อน
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: yours
                                          ? GestureDetector(
                                            onTap: () {
                                              _signOut(context);
                                            },
                                            child: Text(
                                                "Log out",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                          )
                                          : Text(
                                              'Follow',
                                              style: TextStyle(
                                                  color: Colors.amber),
                                            ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: isfollow,
                                  child: GestureDetector(
                                    onTap: () {
                                      Firebase_Firestor()
                                          .flollow(uid: widget.Uid);
                                      setState(() {
                                        isfollow = false;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color:
                                                  Colors.blueAccent.shade700)),
                                      child: Text(
                                        "Unfollow",
                                        style: TextStyle(
                                            color: Color(0xFF5590FF),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(color: Color(0xFF5590FF)),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 40.w,
                                ),
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('posts')
                                      .where('uid', isEqualTo: widget.Uid)
                                      .snapshots(),
                                  builder: (context, postSnapshot) {
                                    if (!postSnapshot.hasData) {
                                      return Count('0', 'Posts');
                                    }
                                    final postCount =
                                        postSnapshot.data!.docs.length;
                                    return Count(postCount.toString(), 'Posts');
                                  },
                                ),
                                SizedBox(
                                  width: 50.w,
                                ),
                                Count(
                                    snapshot.data!.followers.length.toString(),
                                    "Followers"),
                                SizedBox(
                                  width: 50.w,
                                ),
                                Count(
                                    snapshot.data!.following.length.toString(),
                                    "Following"),
                                SizedBox(
                                  width: 20.w,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 18),
                              child: TabBar(
                                  unselectedLabelColor: Colors.grey,
                                  labelColor: Color(0xFF225AEB),
                                  indicatorColor: Color(0xFF225AEB),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicatorWeight: 4.0,
                                  tabs: [
                                    Icon(
                                      Icons.comment,
                                      size: 30,
                                    ),
                                    Icon(
                                      Icons.favorite,
                                      size: 30,
                                    ),
                                    Icon(Icons.bookmark, size: 30),
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: TabBarView(children: [
                              Post_Stream(),
                              like_Stream(),
                              Bookmark_Stream(),
                            ]),
                          )
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> Bookmark_Stream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('bookmark', arrayContains: widget.Uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No bookmarked posts"));
        }

        final bookmarkedPosts = snapshot.data!.docs;

        return ListView.builder(
          itemCount: bookmarkedPosts.length,
          itemBuilder: (context, index) {
            final data = bookmarkedPosts[index].data() as Map<String, dynamic>;
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Comment('posts', data)),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 20, top: 5),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ProfileScreen(data['uid']);
                              }));
                            },
                            child: ClipOval(
                              child: SizedBox(
                                width: 70.w,
                                height: 70.h,
                                child: CachedImage(data['profileImage']),
                              ),
                            )),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['topic'],
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                data['detail'],
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(color: Colors.grey.shade300, thickness: 2.0),
              ],
            );
          },
        );
      },
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> Post_Stream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.Uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No posts yet"));
        }

        final posts = snapshot.data!.docs;

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final data = posts[index].data() as Map<String, dynamic>;
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Comment('posts', data)));
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 20, top: 5),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        Icon(Icons.library_books_outlined),
                        SizedBox(
                          width: 20.w,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['topic'],
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data['detail'],
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(color: Colors.grey.shade300, thickness: 2.0),
              ],
            );
          },
        );
      },
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> like_Stream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('like', arrayContains: widget.Uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No liked posts"));
        }

        final likedPosts = snapshot.data!.docs;

        return ListView.builder(
          itemCount: likedPosts.length,
          itemBuilder: (context, index) {
            final data = likedPosts[index].data() as Map<String, dynamic>;
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Comment('posts', data)),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 20, top: 5),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ProfileScreen(data['uid']);
                              }));
                            },
                            child: ClipOval(
                              child: SizedBox(
                                width: 70.w,
                                height: 70.h,
                                child: CachedImage(data['profileImage']),
                              ),
                            )),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['topic'],
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                data['detail'],
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(color: Colors.grey.shade300, thickness: 2.0),
              ],
            );
          },
        );
      },
    );
  }

  Column Count(String number, String name) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        Text(
          name,
          style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        )
      ],
    );
  }
}
