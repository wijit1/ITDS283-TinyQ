import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: Column(
        children: [
          Head(),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              "Login",
              style: TextStyle(
                  color: Color(0xFF225AEB),
                  fontSize: 50,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Textfield(),
        ],
      )),
    );
  }

  Padding Textfield() {
    return Padding(
          padding: EdgeInsets.symmetric(horizontal: 25,vertical: 15),
          child: Container(
            height: 55,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: TextField(
              style: TextStyle(fontSize: 18, color: Colors.black),
              controller: null,
              focusNode: null,
              decoration: InputDecoration(
                  hintText: "username",
                  hintStyle: TextStyle(color:  Color.fromARGB(255, 145, 144, 144)),
                  prefixIcon: Image(
                    width: 80,
                    image: AssetImage('assets/images/mail_icon.png')),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color:  Color.fromARGB(255, 199, 193, 193), width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Colors.pinkAccent, width: 2))),
            ),
          ),
        );
  }

  Container Head() {
    return Container(
      color: Color(0xFF225AEB),
      child: SizedBox(
        width: double.infinity,
        height: 370,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 30, top: 70),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Welcome",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 65,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Back",
                  style: TextStyle(
                      height: 1.0,
                      color: Colors.white,
                      fontSize: 65,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 50),
              child: Container(
                alignment: Alignment.centerRight,
                child: Image(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      "assets/images/login_book.png",
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
