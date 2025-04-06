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
                                Column(
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
                                SizedBox(
                                  width: 50,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color(0xFFFFF7D9), // สีเหลืองอ่อน
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(
                                        color: Colors.lightBlue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                    color:
                                         const Color.fromARGB(255, 236, 117, 117), // สีเหลืองอ่อน
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
}
