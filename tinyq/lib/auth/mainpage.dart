import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tinyq/screen/get_started_screen.dart';
import 'package:tinyq/screen/home.dart';

class Mainpage extends StatelessWidget {
  const Mainpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context , snapshot){
          if(snapshot.hasData){
            return HomeScreen();
          }else{
            return GetStartedScreen();
          }
        })
    );
  }
}