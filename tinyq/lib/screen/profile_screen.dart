import 'package:flutter/material.dart';
import 'package:tinyq/data/firebase_service/firestor.dart';
import 'package:tinyq/util/image_cached.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: FutureBuilder(
                  future: Firebase_Firestor().getUser(),
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
                                    width: 70,
                                    height: 70,
                                    child: CachedImage(snapshot.data!.profile),
                                  ),
                                ),
                                SizedBox(
                                  width: 35,
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.data!.username,
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        snapshot.data!.major,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: const Color.fromARGB(
                                                255, 172, 169, 169)),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 236, 117, 117), // สีเหลืองอ่อน
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "Log out",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
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
                                  width: 40,
                                ),
                                Count('10', 'Posts'),
                                SizedBox(
                                  width: 50,
                                ),
                                Count(
                                    snapshot.data!.followers.length.toString(),
                                    "Followers"),
                                SizedBox(
                                  width: 50,
                                ),
                                Count(
                                    snapshot.data!.following.length.toString(),
                                    "Following"),
                                SizedBox(
                                  width: 20,
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
                            child: TabBarView(children: 
                            [
                              ListView.builder(
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Icon(Icons.comment),
                                  title: Text('Comment ${index + 1}'),
                                  subtitle: Text('This is a comment.'),
                                );
                              }),
                              ListView.builder(
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Icon(Icons.comment),
                                  title: Text('Comment ${index + 1}'),
                                  subtitle: Text('This is a comment.'),
                                );
                              }),
                              ListView.builder(
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Icon(Icons.comment),
                                  title: Text('Comment ${index + 1}'),
                                  subtitle: Text('This is a comment.'),
                                );
                              }),
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

  Column Count(String number, String name) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          name,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        )
      ],
    );
  }
}
