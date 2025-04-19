import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinyq/screen/add_post.dart';
import 'package:tinyq/screen/home.dart';
import 'package:tinyq/screen/news_screen.dart';
import 'package:tinyq/screen/notification_screen.dart';
import 'package:tinyq/screen/profile_screen.dart';
import 'package:tinyq/screen/search_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Navigation_Screen extends StatefulWidget {
  const Navigation_Screen({super.key});

  @override
  State<Navigation_Screen> createState() => _Navigation_ScreenState();
}

int _currentIndex = 0;

class _Navigation_ScreenState extends State<Navigation_Screen> {
  late PageController pageController;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text("TinyQ?",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Pacifico",
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w200)),
          backgroundColor: Color(0xFF225AEB),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                );
              },
              child: ImageIcon(
                AssetImage(
                  'assets/images/notification_bell.png',
                ),
                color: Colors.amberAccent,
                size: 28,
              ),
            ),
            SizedBox(width: 10.w),
            IconButton(
              onPressed: () => _signOut(context),
              icon: Icon(
                Icons.logout,
                color: Colors.white,
                size: 30,
              ),
            )
          ]),
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
            backgroundColor: const Color.fromARGB(255, 241, 240, 240),
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Color(0xFF225AEB),
            unselectedItemColor: Colors.grey,
            onTap: navigationTapped,
            items: [
              BottomNavigationBarItem(
                activeIcon: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.home, size: 30, color: Color(0xFF225AEB)),
                      SizedBox(height: 4), // ระยะห่างระหว่าง icon กับ เส้น
                      Container(
                        height: 3,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Color(0xFF225AEB), // สีของเส้น
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                  icon: Icon(
                    Icons.home,
                    size: 30,
                  ),
                  label: 'Home'),
              BottomNavigationBarItem(
                  activeIcon: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search, size: 30, color: Color(0xFF225AEB)),
                      SizedBox(height: 4), // ระยะห่างระหว่าง icon กับ เส้น
                      Container(
                        height: 3,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Color(0xFF225AEB), // สีของเส้น
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                  icon: Icon(
                    Icons.search,
                    size: 30,
                  ),
                  label: 'Search'),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/nav_addpost.png',
                    width: 50,
                    height: 50,
                  ),
                  label: ''),
              BottomNavigationBarItem(
                activeIcon: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.newspaper_sharp, size: 30, color: Color(0xFF225AEB)),
                      SizedBox(height: 4), // ระยะห่างระหว่าง icon กับ เส้น
                      Container(
                        height: 3,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Color(0xFF225AEB), // สีของเส้น
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                  icon: Icon(
                    Icons.newspaper,
                    size: 30,
                  ),
                  label: 'News'),
              BottomNavigationBarItem(
                activeIcon: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person, size: 30, color: Color(0xFF225AEB)),
                      SizedBox(height: 4), // ระยะห่างระหว่าง icon กับ เส้น
                      Container(
                        height: 3,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Color(0xFF225AEB), // สีของเส้น
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                  icon: Icon(
                    Icons.person,
                    size: 30,
                  ),
                  label: 'Profile'),
            ]),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          HomeScreen(),
          SearchScreen(),
          AddPost_Screen(),
          NewsScreen(),
          ProfileScreen(_auth.currentUser!.uid),
        ],
      ),
    );
  }
}
