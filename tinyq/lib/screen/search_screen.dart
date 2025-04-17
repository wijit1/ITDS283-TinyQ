import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinyq/widgets/postwidget.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final search_val = TextEditingController();
  FirebaseFirestore _firebaseFireStore = FirebaseFirestore.instance;
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    List items = [
      {
        'image': 'assets/images/search_page_ML.png',
        'topic': 'Machine learning'
      },
      {'image': 'assets/images/search_page_Math.png', 'topic': 'Math'},
      {'image': 'assets/images/search_page_Com_Sci.png', 'topic': 'Com sci'},
      {'image': 'assets/images/search_page_Sc.png', 'topic': 'Science'},
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
                  final posts = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final title = data['title']?.toString().toLowerCase() ?? '';
                    final category =
                        data['category']?.toString().toLowerCase() ?? '';
                    final query = searchQuery.toLowerCase();

                    return query.isEmpty ||
                        title.contains(query) ||
                        category.contains(query);
                  }).toList();

                  return ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final data = posts[index].data();
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 15.0,
                        ),
                        child: Postwidget(data,search_bool: true,),
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
    height: 180.h,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 3.5,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                search_val.text = item['topic'];
                searchQuery = item['topic'];
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFF225AEB),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      item['image'],
                      width: 30.w,
                      height: 30.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item['topic'],
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}


  Padding SearchBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      child: Container(
        width: double.infinity,
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            const SizedBox(width: 15),
            const Icon(
              Icons.search,
              color: Color.fromARGB(255, 133, 131, 131),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: search_val,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'What Topic are you looking for?',
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 182, 173, 173)),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.clear, size: 18),
              onPressed: () {
                setState(() {
                  search_val.clear();
                  searchQuery = "";
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
