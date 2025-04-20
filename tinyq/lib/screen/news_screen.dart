import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final List<String> categories = [
    'business',
    'general',
    'health',
    'science',
    'technology',
  ];

  Future<List<Map<String, dynamic>>> fetchNews(String category) async {
    final url =
        'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=92a938b6e5b940bbb934f733838f3dea'; 
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List articles = json.decode(response.body)['articles'];

      
      final filteredArticles = articles.where((article) =>
          article['urlToImage'] != null &&
          article['urlToImage'].toString().isNotEmpty).toList();

      return filteredArticles
          .map((article) => {
                'title': article['title'],
                'urlToImage': article['urlToImage'],
                'publishedAt': article['publishedAt'],
                'url': article['url'],
              })
          .toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  Widget buildNewsCard(Map<String, dynamic> article) {
    DateTime dateTime = DateTime.tryParse(article['publishedAt'] ?? '') ?? DateTime.now();
    String date = DateFormat('dd-MM-yyyy').format(dateTime);
    String time = DateFormat('h:mm a').format(dateTime);

    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.symmetric(vertical: 10.h),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                article['urlToImage'],
                height: 200.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                article['title'] ?? '',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0, left: 8.0, right: 8.0),
              child: Text('$date         $time',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13.sp)),
            ),
          ],
        ));
  }

  Widget buildCategorySection(String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Row(
          children: [
            Icon(Icons.label_important_outline, size: 28, color: Colors.blueAccent),
            SizedBox(width: 10.w),
            Text(
              category[0].toUpperCase() + category.substring(1),
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            )
          ],
        ),
        SizedBox(height: 10.h),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchNews(category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            if (snapshot.hasError)
              return Text('Error loading $category news');
            final articles = snapshot.data!;
            return Column(
              children: articles
                  .take(1) // แสดงข่าวล่าสุด 1 ข่าวต่อหมวด
                  .map(buildNewsCard)
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Text(
                  "News",
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue,
                    decorationThickness: 2,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.campaign_outlined,
                size: 50,)
              ],
            ),
            for (var category in categories) buildCategorySection(category),
          ],
        ),
      ),
    );
  }
}
