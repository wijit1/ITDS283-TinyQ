import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinyq/screen/profile_screen.dart';
import 'package:tinyq/util/image_cached.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot> getNotificationsStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('notification')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  String timeAgo(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) return '${difference.inSeconds}s ago';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, size: 29),
        backgroundColor: Color(0xFF225AEB),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 50, top: 30, bottom: 30),
            child: Row(
              children: [
                Container(
                  child: Text(
                    "Noification",
                    style:
                        TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                ImageIcon(
                  AssetImage(
                    'assets/images/notification_bell.png',
                  ),
                  color: Colors.amberAccent,
                  size: 28,
                )
              ],
            ),
          ),
          Expanded(
              child: StreamBuilder(
                  stream: getNotificationsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("No notifications"));
                    }
                    final notification = snapshot.data!.docs;
                    return ListView.builder(
                        itemCount: notification.length,
                        itemBuilder: (context, index) {
                          final data = notification[index].data()
                              as Map<String, dynamic>;
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: 25, right: 25, top: 10),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ProfileScreen(data['triggeredByUserId']);
                                        }));
                                      },
                                      child: ClipOval(
                                        child: SizedBox(
                                          width: 70.w,
                                          height: 70.h,
                                          child: CachedImage(
                                              data['triggeredByUserAvatar']),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${data['triggeredByUserName']}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            data['title'] ?? '',
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 65, 65, 65),
                                                fontSize: 15.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      timeAgo(data['createdAt']),
                                      style: TextStyle(
                                          fontSize: 13.sp, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.black12,
                                thickness: 2,
                              )
                            ],
                          );
                        });
                  }))
        ],
      ),
    );
  }
}
