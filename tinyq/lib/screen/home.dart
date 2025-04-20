import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinyq/data/firebase_service/firestor.dart';
import 'package:tinyq/data/model/user_profile.dart';
import 'package:tinyq/screen/profile_screen.dart';
import 'package:tinyq/util/image_cached.dart';
import 'package:tinyq/widgets/postwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserProfile> userProfile = [];
  FirebaseFirestore _firebaseFireStore = FirebaseFirestore.instance;

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
  }

  void loadUserProfile() {
    setState(() {
      userProfile = UserProfile.getUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    loadUserProfile();
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 320, top: 10, bottom: 10),
              child: Text(
                "New!!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp,
                    color: Colors.redAccent),
              ),
            ),
            Container(
                height: 130.h,
                child: StreamBuilder(
                    stream: _firebaseFireStore
                        .collection('users')
                        .limit(5)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final users = snapshot.data!.docs;
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index].data();
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return ProfileScreen(user['uid']);
                                      }));
                                    },
                                    child: CircleAvatar(
                                        radius: 40,
                                        backgroundColor: const Color.fromARGB(255, 64, 47, 218),
                                        child: ClipOval(
                                          child: SizedBox(
                                            width: 60.w,
                                            height: 60.h,
                                            child: CachedImage(user['profile']),
                                          ),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 10.w,
                                  ),
                                  Text(
                                    
                                    user['username'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            );
                          });
                    })),
            Expanded(
              child: StreamBuilder(
                stream: _firebaseFireStore
                    .collection('posts')
                    .orderBy('time', descending: true)
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
                    padding: EdgeInsets.all(20),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final data = posts[index].data();
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 15.0,
                        ),
                        child: Postwidget(data),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ));
  }
}
