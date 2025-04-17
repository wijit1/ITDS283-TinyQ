
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:tinyq/data/firebase_service/firestor.dart';
import 'package:tinyq/data/firebase_service/storage.dart';
import 'package:tinyq/util/exception.dart';

class Authentication{
  FirebaseAuth _auth = FirebaseAuth.instance; 

  Future<void> Login({
    required String email,
    required String password,}) async {
    
    try{
      await _auth.signInWithEmailAndPassword(
        email: email.trim(), 
        password: password.trim());
    }on FirebaseAuthException catch(e){
      throw exceptions("Login failed: ${e.message}");
    }
  }


  Future<void> Signup({
    required String email,
    required String password,
    required String passwordConfirme,
    required String username,
    required String major,
    required File profile,

  })async {
    String URL;
    try{
      if(email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          major.isNotEmpty){
            if(password == passwordConfirme){
              await _auth.createUserWithEmailAndPassword(
                email: email.trim(),
                password: password.trim(),
            );

            if (profile != File('')) {
            URL =
                await StorageMethod().uploadImageToStorage('Profile', profile);
          } else {
            URL = '';
          }

          await Firebase_Firestor().CreateUser(
            email: email, 
            username: username, 
            major: major, 
            profile: URL == ''
                ? 'https://firebasestorage.googleapis.com/v0/b/instagram-8a227.appspot.com/o/person.png?alt=media&token=c6fcbe9d-f502-4aa1-8b4b-ec37339e78ab'
                : URL,
          );
            }else{
              throw exceptions('password and confirm password should be same');
            }
      }
    }on FirebaseException catch(e){
      throw exceptions(e.message.toString());
    }
  }
}