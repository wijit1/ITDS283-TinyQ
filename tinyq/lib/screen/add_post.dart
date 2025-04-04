import 'package:flutter/material.dart';
import 'package:tinyq/data/firebase_service/firestor.dart';
import 'package:tinyq/data/model/user_model.dart';
import 'package:tinyq/util/image_cached.dart';

class AddPost_Screen extends StatefulWidget {
  const AddPost_Screen({super.key});

  @override
  State<AddPost_Screen> createState() => _AddPost_ScreenState();
}

class _AddPost_ScreenState extends State<AddPost_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 300, top: 50),
            child: Text(
              "Post",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Add_Title(),
          Add_Detail()
        ],
      ),
    );
  }

  Padding Add_Detail() {
    return Padding(
          padding: EdgeInsets.all(25.0),
          child: Container(
            height: 245,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: Color(0xFFD9D9D9), width: 2),
            ),
            child: Column(
              children: [
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Description",
                    hintStyle: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: null, 
                        icon: Icon(Icons.image)),
                      SizedBox(width: 15,),
                      IconButton(
                        onPressed: null, 
                        icon: Icon(Icons.copy)),
                      SizedBox(width: 15,),
                      IconButton(
                        onPressed: null, 
                        icon: Icon(Icons.emoji_emotions)),
                      SizedBox(width: 100,),
                      IconButton(
                        onPressed: null, 
                        icon: Image(image: AssetImage('assets/images/addpost_page_send.png'))),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
  }

  Padding Add_Title() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border:
              Border.all(color: Color(0xFFD9D9D9), width: 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: Firebase_Firestor().getUser(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator(),);
                }
                return Profile_user(snapshot.data!);
              },
            ),
            SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Your Topic ?",
                        hintStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 77, 118, 221),
                        ),
                      ),
                    ),
                    SizedBox(height: 13,),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "# category",
                        hintStyle: TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Profile_user(Usermodel user) {
    return ClipOval(
      child: SizedBox(
        width: 75,
        height: 75,
        child: CachedImage(user.profile),
      ),
    );
  }
}
