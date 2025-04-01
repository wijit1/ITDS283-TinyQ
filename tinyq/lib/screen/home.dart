import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tinyq/data/model/user_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserProfile> userProfile = [];
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
              padding: EdgeInsets.only(right: 320, top: 10,bottom: 10),
              child: Text(
                "New!!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,color: Colors.redAccent),
              ),
            ),
            Container(
                height: 130,
                child: ListView.builder(
                  itemCount: userProfile.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          InkWell(
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor:
                                  const Color.fromARGB(255, 136, 184, 255),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage: userProfile[index].image,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(userProfile[index].username,
                          style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      ),
                    );
                  },
                ))
          ],
        ));
  }
}
