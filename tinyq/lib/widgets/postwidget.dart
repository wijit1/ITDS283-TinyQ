import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinyq/data/firebase_service/firestor.dart';
import 'package:tinyq/screen/profile_screen.dart';
import 'package:tinyq/util/image_cached.dart';
import 'package:date_format/date_format.dart';
import 'package:tinyq/widgets/comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Postwidget extends StatefulWidget {
  final search_bool; 
  final snapshot;
  const Postwidget(this.snapshot,{this.search_bool = false,super.key});

  @override
  State<Postwidget> createState() => _PostwidgetState();
}

class _PostwidgetState extends State<Postwidget> {
  String user = ''; 
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  int comment_count = 0;

  void get_comment_count()async{
     QuerySnapshot comment_snapshot = await FirebaseFirestore.instance
      .collection('posts')
      .doc(widget.snapshot['postId'])
      .collection('comments')
      .get();

      if (mounted){
      setState(() {
        comment_count = comment_snapshot.docs.length;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    user = _auth.currentUser!.uid; 
    get_comment_count();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=> Comment('posts',widget.snapshot)));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border:
                Border.all(color: Color.fromARGB(255, 219, 225, 240), width: 2)),
        child: Column(
          children: [
            Column(
              children: [
                Head(widget.snapshot), // User Profile,
                SizedBox(
                  height: 6.h,
                ),
                Title(widget.snapshot), // Title and Detail
                SizedBox(
                  height: 9.h,
                ),
              ],
            ),
            Divider(
              thickness: 1, // ความหนา
              color: const Color.fromARGB(255, 207, 206, 206), // สีเส้น
            ),
            Action( comment_count)
          ],
        ),
      ),
    );
  }

  Padding Action(int comment_count) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,MaterialPageRoute(builder: (context)=> Comment('posts',widget.snapshot)));
            },
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
          GestureDetector(
            onTap: () {

              Firebase_Firestor().like(
                like: widget.snapshot['like'], 
                type: 'posts', 
                uid: user, 
                postId: widget.snapshot['postId']);
            },
            child: Row(
              children: [
                SizedBox(
                  width: 30.w,
                  height: 30.h,
                  child: Icon(
                  widget.snapshot['like'].contains(user)
                  ?Icons.favorite
                  :Icons.favorite_border, 
                  color: widget.snapshot['like'].contains(user)
                        ? Colors.red
                        : Colors.black),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(widget.snapshot['like'].length.toString()),
              ],
            ),
          ),
          SizedBox(
            width: 25.w,
          ),
          GestureDetector(
            onTap: () {
              Firebase_Firestor().bookmark(
                bookmark: widget.snapshot['bookmark'], 
                type: 'posts', 
                uid: user, 
                postId: widget.snapshot['postId']);
            },
            child: Row(
              children: [
                SizedBox(
                  width: 30.w,
                  height: 30.h,
                  child: Icon(
                  widget.snapshot['bookmark'].contains(user)
                  ?Icons.bookmark
                  :Icons.bookmark_border, 
                  color: widget.snapshot['bookmark'].contains(user)
                        ? Colors.amberAccent
                        : Colors.black),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(widget.snapshot['bookmark'].length.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column Title(final snapshot) {
    return Column(
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

        if (!widget.search_bool)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                snapshot['detail'],
                style: TextStyle(
                  fontSize: 15.sp,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
      ],
    );
  }

  Padding Head(final snapshot) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context){
                    return ProfileScreen(snapshot['uid']);
                  })
              );
            },
            child: ClipOval(
            child: SizedBox(
              width: 75.w,
              height: 75.h,
              child: CachedImage(snapshot['profileImage']),
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
            width: 30.w,
          ),
          Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.h),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 67, 120, 255),
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(color: Colors.transparent, width: 1.w)),
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
