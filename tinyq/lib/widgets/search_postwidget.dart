import 'package:flutter/material.dart';
import 'package:tinyq/util/image_cached.dart';
import 'package:date_format/date_format.dart';


class SearchPostwidget extends StatefulWidget {
  final snapshot;
  const SearchPostwidget(this.snapshot,{super.key});

  @override
  State<SearchPostwidget> createState() => _SearchPostwidgetState();
}

class _SearchPostwidgetState extends State<SearchPostwidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border:
              Border.all(color: Color.fromARGB(255, 219, 225, 240), width: 2)),
      child: Column(
        children: [
          Column(
            children: [
              Head(widget.snapshot), // User Profile,
              SizedBox(
                height: 6,
              ),
              Title(widget.snapshot), // Title and Detail
              SizedBox(
                height: 9,
              ),
            ],
          ),
          Divider(
            thickness: 1, // ความหนา
            color: const Color.fromARGB(255, 207, 206, 206), // สีเส้น
          ),
          Action()
        ],
      ),
    );
  }

  Padding Action() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Icon(Icons.chat_bubble_outline, color: Colors.grey),
                ),
                SizedBox(
                  width: 5,
                ),
                Text("10"),
              ],
            ),
          ),
          SizedBox(
            width: 25,
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Icon(Icons.favorite_border, color: Colors.grey),
                ),
                SizedBox(
                  width: 5,
                ),
                Text("10"),
              ],
            ),
          ),
          SizedBox(
            width: 25,
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Icon(Icons.bookmark_border, color: Colors.grey),
                ),
                SizedBox(
                  width: 5,
                ),
                Text("10"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column Title(final snapshot) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              snapshot['topic'],
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Padding Head(final snapshot) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Row(
        children: [
          InkWell(
              child: ClipOval(
            child: SizedBox(
              width: 75,
              height: 75,
              child: CachedImage(snapshot['profileImage']),
            ),
          )),
          SizedBox(
            width: 13,
          ),
          Column(
            children: [
              Text(
                snapshot['username'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                snapshot['time'] != null
                    ? formatDate(
                        snapshot['time'].toDate(), [yyyy, '-', mm, '-', dd])
                    : '',
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
          SizedBox(
            width: 30,
          ),
          Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 67, 120, 255),
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(color: Colors.transparent, width: 1)),
                  child: Text(
                    '# ' + snapshot['category'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white),
                  )),
              SizedBox(
                height: 20,
              )
            ],
          )
        ],
      ),
    );
  }
}
