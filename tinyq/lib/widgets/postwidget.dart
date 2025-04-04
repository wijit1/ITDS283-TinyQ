import 'package:flutter/material.dart';

class Postwidget extends StatefulWidget {
  const Postwidget({super.key});

  @override
  State<Postwidget> createState() => _PostwidgetState();
}

class _PostwidgetState extends State<Postwidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Color.fromARGB(255, 219, 225, 240), width: 2)),
      child: Column(
        children: [
          Column(
            children: [
              Head(), // User Profile,
              SizedBox(
                height: 6,
              ),
              Title(), // Title and Detail
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
                  width: 30, height: 30, 
                  child: Icon(Icons.chat_bubble_outline, color: Colors.grey),
                ),
                SizedBox(width: 5,),
                Text("10"),
              ],
            ),
          ),
          SizedBox(width: 25,),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                SizedBox(
                  width: 30, height: 30, 
                  child: Icon(Icons.favorite_border, color: Colors.grey),
                ),
                SizedBox(width: 5,),
                Text("10"),
              ],
            ),
          ),
          SizedBox(width: 25,),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                SizedBox(
                  width: 30, height: 30, 
                  child: Icon(Icons.bookmark_border, color: Colors.grey),
                ),
                SizedBox(width: 5,),
                Text("10"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column Title() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 29),
          child: Text(
            "What is The Great Question? ",
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Have ever heard something like You must ask the right question But How can I make sure that is the correct question not bad one?",
            style: TextStyle(
              fontSize: 15,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Padding Head() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Row(
        children: [
          InkWell(
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/Mr.A.jpg'),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Text(
                "Mr.A",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "3 days ago",
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
                    "# Com Sci",
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
