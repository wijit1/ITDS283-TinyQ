import 'package:flutter/material.dart';

class UserProfile {
  String username;
  AssetImage image;
  UserProfile(this.username,this.image);

  static List<UserProfile> getUserProfile(){

    List<UserProfile> LstUser = [];

    LstUser.add(UserProfile("Mr.A", AssetImage('assets/images/Mr.A.jpg')));
    LstUser.add(UserProfile("Mr.R", AssetImage('assets/images/Mr.R.jpg')));
    LstUser.add(UserProfile("MR.Sun", AssetImage('assets/images/Mr.Sun.jpg')));
    LstUser.add(UserProfile("Mr.G", AssetImage('assets/images/Mr.G.jpg')));
    return LstUser; 
  } 
}