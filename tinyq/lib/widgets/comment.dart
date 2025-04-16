import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser!.uid;
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
                padding: EdgeInsets.only(top: 20, left: 10),
                child: Head(snapshot)),
            Detail(snapshot),
            Action(),
            Divider(color: Colors.grey.shade300, thickness: 2.0),
            Write_comment(),
            Divider(color: Colors.grey.shade300, thickness: 2.0),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.topLeft,
                child: Text(
                  "other",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ));
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
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
              ClipOval(
                child: SizedBox(
                  height: 60,
                  width: 60,
                  child: CachedImage(
                    csnapshot['profileImage'],
                  ),
                ),
              ),
              SizedBox(width: 25),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      csnapshot['username'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      csnapshot['comment'],
                      style: TextStyle(
                        fontSize: 15,
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
          padding: EdgeInsets.only(left: 30, top: 10),
          alignment: Alignment.topLeft,
          child: Text(
            "comment here",
            style: TextStyle(
                fontSize: 15,
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
                          width: 70,
                          height: 70,
                          child: CachedImage(snapshot.data!.profile),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                width: 300,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Color(0xFFD9D9D9), width: 2),
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
                      padding: EdgeInsets.only(right: 10),
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

  Padding Action() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Icon(Icons.chat_bubble_outline, color: Colors.grey),
                ),
                SizedBox(
                  width: 5,
                ),
                Text("10"),
              ],
            ),
          ),
          SizedBox(
            width: 25,
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
                      width: 30,
                      height: 30,
                      child: Icon(
                        likes.contains(user)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: likes.contains(user) ? Colors.red : Colors.black,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(likes.length.toString()),
                  ],
                ),
              );
            },
          ),
          SizedBox(
            width: 25,
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Icon(Icons.bookmark_border, color: Colors.grey),
                ),
                SizedBox(
                  width: 5,
                ),
                Text("10"),
              ],
            ),
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                snapshot['topic'],
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              snapshot['detail'],
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding Head(snapshot) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Row(
        children: [
          InkWell(
              child: ClipOval(
            child: SizedBox(
              width: 75,
              height: 75,
              child: CachedImage(snapshot['profileImage']),
            ),
          )),
          SizedBox(
            width: 13,
          ),
          Column(
            children: [
              Text(
                snapshot['username'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                snapshot['time'] != null
                    ? formatDate(
                        snapshot['time'].toDate(), [yyyy, '-', mm, '-', dd])
                    : '',
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
          SizedBox(
            width: 30,
          ),
          Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 67, 120, 255),
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(color: Colors.transparent, width: 1)),
                  child: Text(
                    '# ' + snapshot['category'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white),
                  )),
              SizedBox(
                height: 20,
              )
            ],
          )
        ],
      ),
    );
  }
}
