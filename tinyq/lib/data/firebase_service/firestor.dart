import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tinyq/data/model/user_model.dart';
import 'package:tinyq/util/exception.dart';
import 'package:uuid/uuid.dart';

class Firebase_Firestor {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> CreateUser({
    required String email,
    required String username,
    required String major,
    required String profile,
  }) async {
    await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .set({
      'email': email,
      'username': username,
      'major': major,
      'profile': profile,
      'followers': [],
      'following': [],
    });
    return true;
  }

  Future<Usermodel> getUser({String? UID}) async {
    try {
      final user = await _firebaseFirestore
          .collection('users')
          .doc(UID != null ? UID : _auth.currentUser!.uid)
          .get();
      final snapuser = user.data()!;
      return Usermodel(
        snapuser['major'],
        snapuser['email'],
        snapuser['followers'],
        snapuser['following'],
        snapuser['profile'],
        snapuser['username'],
      );
    } on FirebaseException catch (e) {
      throw exceptions(e.message.toString());
    }
  }

  Future<bool> CreatePost({
    required String topic,
    required String category,
    required String detail,
  }) async {
    var uid = Uuid().v4();
    DateTime date = new DateTime.now();
    Usermodel user = await getUser();
    await _firebaseFirestore.collection('posts').doc(uid).set({
      'username': user.username,
      'profileImage': user.profile,
      'topic': topic,
      'category': category,
      'detail': detail,
      'uid': _auth.currentUser!.uid,
      'postId': uid,
      'like': [],
      'bookmark': [],
      'time': date
    });
    return true;
  }

  Future<bool> Comments({
    required String comment,
    required String type,
    required String uidd,
  }) async {
    var uid = Uuid().v4();
    Usermodel user = await getUser();
    await _firebaseFirestore
        .collection(type)
        .doc(uidd)
        .collection('comments')
        .doc(uid)
        .set({
      'comment': comment,
      'username': user.username,
      'profileImage': user.profile,
      'CommentUid': uid,
    });
    return true;
  }

  Future<String> like({
    required List like,
    required String type,
    required String uid,
    required String postId,
  }) async {
    String res = 'some error';
    try {
      if (like.contains(uid)) {
        _firebaseFirestore.collection(type).doc(postId).update({
          'like': FieldValue.arrayRemove([uid])
        });
      } else {
        _firebaseFirestore.collection(type).doc(postId).update({
          'like': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } on Exception catch (e) {
      res = e.toString();
    }
    return res;
  }


   Future<String> bookmark({
    required List bookmark,
    required String type,
    required String uid,
    required String postId,
  }) async {
    String res = 'some error';
    try {
      if (bookmark.contains(uid)) {
        _firebaseFirestore.collection(type).doc(postId).update({
          'bookmark': FieldValue.arrayRemove([uid])
        });
      } else {
        _firebaseFirestore.collection(type).doc(postId).update({
          'bookmark': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } on Exception catch (e) {
      res = e.toString();
    }
    return res;
  }


  
  Future<void> flollow({
    required String uid,
  }) async {
    DocumentSnapshot snap = await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    List following = (snap.data()! as dynamic)['following'];
    try {
      if (following.contains(uid)) {
        _firebaseFirestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({
          'following': FieldValue.arrayRemove([uid])
        });
        await _firebaseFirestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayRemove([_auth.currentUser!.uid])
        });
      } else {
        _firebaseFirestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({
          'following': FieldValue.arrayUnion([uid])
        });
        _firebaseFirestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayUnion([_auth.currentUser!.uid])
        });
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<bool> CreateNotification({
    required String title,
    required String postId,
    required String ownerId, // Owner Post // User that comment 
  }) async {
    String notifId = Uuid().v4(); //  ID for Notification
    Usermodel commenter = await getUser();
    await _firebaseFirestore
        .collection('users')
        .doc(ownerId)
        .collection('notification')
        .doc(notifId)
        .set({
        'notificationId': notifId,
        'title': title,
        'postId': postId,
        'triggeredByUserId': _auth.currentUser!.uid,
        'triggeredByUserName': commenter.username,
        'triggeredByUserAvatar': commenter.profile,
        'createdAt': FieldValue.serverTimestamp(),
    });
    return true;
  }

  
}
