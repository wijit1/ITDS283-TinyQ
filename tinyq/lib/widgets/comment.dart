import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinyq/data/firebase_service/firestor.dart';
import 'package:tinyq/util/image_cached.dart';
import 'package:date_format/date_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Comment extends StatefulWidget {
  String type;
  final snapshot;

  Comment(this.type, this.snapshot, {super.key});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final comment = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool islodaing = false;

  String user = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int comment_count = 0;
  void get_comment_count() async {
    QuerySnapshot comment_snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snapshot['postId'])
        .collection('comments')
        .get();
    setState(() {
      comment_count = comment_snapshot.docs.length;
    });
  }

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser!.uid;
    get_comment_count();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = widget.snapshot;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF225AEB),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 20.h, left: 10.w),
                child: Head(snapshot)),
            Detail(snapshot),
            Action(comment_count),
            Divider(color: Colors.grey.shade300, thickness: 2.0),
            Write_comment(),
            Divider(color: Colors.grey.shade300, thickness: 2.0),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                alignment: Alignment.topLeft,
                child: Text(
                  "other",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                )),
            Expanded(
              child: StreamBuilder(
                  stream: _firestore
                      .collection(widget.type)
                      .doc(snapshot['postId'])
                      .collection('comments')
                      .snapshots(),
                  builder: (context, csnapshot) {
                    if (!csnapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final comments = csnapshot.data!.docs;
                    if (comments.isEmpty) {
                      return Center(
                          child: Text(
                        "No comment here",
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ));
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: ListView.builder(
                          itemCount: csnapshot.data == null
                              ? 0
                              : csnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            if (!csnapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            return comment_item(csnapshot.data!.docs[index]);
                          }),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget comment_item(final csnapshot) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 188, 30, 255),
                      const Color.fromARGB(255, 27, 111, 255),
                      const Color.fromARGB(255, 34, 185, 255),
                      Colors.lightBlueAccent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: ClipOval(
                    child: CachedImage(csnapshot['profileImage']),
                  ),
                ),
              ),
              SizedBox(width: 25.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      csnapshot['username'],
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      csnapshot['comment'],
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey.shade300,
          thickness: 2,
        ),
      ],
    );
  }

  Column Write_comment() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 30.w, top: 10.h),
          alignment: Alignment.topLeft,
          child: Text(
            "comment here",
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              FutureBuilder(
                future: Firebase_Firestor().getUser(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 70.w,
                          height: 70.h,
                          child: CachedImage(snapshot.data!.profile),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(
                width: 20.w,
              ),
              Container(
                width: 260.w,
                height: 100.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Color(0xFFD9D9D9), width: 2.w),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: comment,
                        maxLines: 2,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "What do you think?"),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10.w),
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            islodaing = true;
                          });
                          if (comment.text.isNotEmpty) {
                            Firebase_Firestor().Comments(
                              comment: comment.text,
                              type: widget.type,
                              uidd: widget.snapshot['postId'],
                            );

                            Firebase_Firestor().CreateNotification(
                              title: comment.text,
                              postId: widget.snapshot['postId'],
                              ownerId: widget.snapshot['uid'],
                            );
                          }
                          setState(() {
                            islodaing = false;
                            comment.clear();
                          });
                        },
                        child: Image(
                            image: AssetImage(
                                'assets/images/addpost_page_send.png')),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Padding Action(int comment_count) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                SizedBox(
                  width: 30.w,
                  height: 30.h,
                  child: Icon(Icons.chat_bubble_outline, color: Colors.grey),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text("$comment_count"),
              ],
            ),
          ),
          SizedBox(
            width: 25.w,
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection(widget.type)
                .doc(widget.snapshot['postId'])
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              final post = snapshot.data!;
              final likes = List<String>.from(post['like'] ?? []);

              return GestureDetector(
                onTap: () {
                  Firebase_Firestor().like(
                    like: likes,
                    type: widget.type,
                    uid: user,
                    postId: widget.snapshot['postId'],
                  );
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 30.w,
                      height: 30.h,
                      child: Icon(
                        likes.contains(user)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: likes.contains(user) ? Colors.red : Colors.black,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(likes.length.toString()),
                  ],
                ),
              );
            },
          ),
          SizedBox(
            width: 25.w,
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection(widget.type)
                .doc(widget.snapshot['postId'])
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              final post = snapshot.data!;
              final bookmarks = List<String>.from(post['bookmark'] ?? []);

              return GestureDetector(
                onTap: () {
                  Firebase_Firestor().bookmark(
                    bookmark: bookmarks,
                    type: widget.type,
                    uid: user,
                    postId: widget.snapshot['postId'],
                  );
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 30.w,
                      height: 30.h,
                      child: Icon(
                        bookmarks.contains(user)
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: bookmarks.contains(user)
                            ? Colors.amberAccent
                            : Colors.black,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(bookmarks.length.toString()),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Padding Detail(snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                snapshot['topic'],
                style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              snapshot['detail'],
              style: TextStyle(
                fontSize: 15.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding Head(snapshot) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      child: Row(
        children: [
          InkWell(
              child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 188, 30, 255),
                  const Color.fromARGB(255, 27, 111, 255),
                  const Color.fromARGB(255, 34, 185, 255),
                  Colors.lightBlueAccent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: ClipOval(
                child: CachedImage(snapshot['profileImage']),
              ),
            ),
          )),
          SizedBox(
            width: 13.w,
          ),
          Column(
            children: [
              Text(
                snapshot['username'],
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                snapshot['time'] != null
                    ? formatDate(
                        snapshot['time'].toDate(), [yyyy, '-', mm, '-', dd])
                    : '',
                style: TextStyle(fontSize: 10.sp),
              ),
            ],
          ),
          SizedBox(
            width: 13.w,
          ),
          Column(
            children: [
              Container(
                  constraints: BoxConstraints(
                    maxWidth: 100.w,
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.h),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 67, 120, 255),
                      borderRadius: BorderRadius.circular(60),
                      border:
                          Border.all(color: Colors.transparent, width: 1.w)),
                  child: Text(
                    '# ' + snapshot['category'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                        color: Colors.white),
                  )),
              SizedBox(
                height: 20.h,
              )
            ],
          )
        ],
      ),
    );
  }
}
