import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tinyq/widgets/postwidget.dart';
import 'package:tinyq/widgets/search_postwidget.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final search_val = TextEditingController();
  FirebaseFirestore _firebaseFireStore = FirebaseFirestore.instance;
  
  @override
  Widget build(BuildContext context) {
    List items = [
      {'image':'','topic':'AI'},
      {'image':'','topic':'AI'},
      {'image':'','topic':'AI'},
      {'image':'','topic':'AI'},
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SearchBox(),
            Category_Topic(items),
            Expanded(
              child: StreamBuilder(
                stream: _firebaseFireStore
                    .collection('posts')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No posts yet"));
                  }
                  final posts = snapshot.data!.docs;

                  return ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final data = posts[index].data();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0,),
                        child: SearchPostwidget(data),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ));
  }

  Widget Category_Topic(List items) {
    return SizedBox(
            height: 180,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 3 columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 245, 216)
                    ),
                    child: Row(
                      children: [
                        Text(item['topic'])
                      ],
                    ),
                  );
                },
              ),
            ),
          );
  }

  Padding SearchBox() {
    return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 29),
            child: Container(
              width: double.infinity,
              height: 36,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  border: Border.all(color: Colors.grey)),
              child: Padding(
                padding: EdgeInsets.all(1.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.search,
                      color: const Color.fromARGB(255, 133, 131, 131),
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        child: TextField(
                            onChanged: (value) {},
                            controller: search_val,
                            decoration: const InputDecoration(
                              hintText: 'What Topic are you looking for?',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 182, 173, 173)),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            )))
                  ],
                ),
              ),
            ),
          );
  }
}
