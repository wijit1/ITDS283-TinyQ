import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tinyq/data/firebase_service/firebase_auth.dart';
import 'package:tinyq/screen/home.dart';
import 'package:tinyq/util/dialog.dart';
import 'package:tinyq/util/exception.dart';
import 'package:tinyq/util/imagepicker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final email = TextEditingController();
  FocusNode email_F = FocusNode();
  final password = TextEditingController();
  FocusNode password_F = FocusNode();
  final passwordConfirme = TextEditingController();
  FocusNode passwordConfirme_F = FocusNode();
  final username = TextEditingController();
  FocusNode username_F = FocusNode();

  final major = TextEditingController();
  FocusNode major_F = FocusNode();

  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: Container(
          child: Column(
        children: [
          Head(context),
          SizedBox(
            height: 10,
          ),
          Center(
            child: InkWell(
              onTap: () async {
                File? _imagefilee = await ImagePickerr().uploadImage('gallery');
                if (_imagefilee == null) {
                    return;
                }
                setState(() {
                  _imageFile = _imagefilee;
                });
              },
              child: CircleAvatar(
                  radius: 43,
                  backgroundColor: const Color.fromARGB(255, 239, 241, 252),
                  child: _imageFile == null
                      ? ClipOval(
                          child: Image.asset(
                            'assets/images/sign_up_human.png',
                            width: double.infinity,
                            height: 70,
                          ),
                        )
                      : CircleAvatar(
                          radius: 43,
                          backgroundImage: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          ).image,
                          backgroundColor: Colors.grey.shade200,
                        ),
                    ),
            ),
          ),
          Textfield(username, AssetImage("assets/images/mail_icon.png"),
              "Username", username_F),
          Textfield(email, AssetImage("assets/images/mail_icon.png"), "Email",
              email_F),
          Textfield(major, AssetImage("assets/images/mail_icon.png"), "Major",
              major_F),
          Textfield(password, AssetImage("assets/images/mail_icon.png"),
              "Password", password_F),
          Textfield(passwordConfirme, AssetImage("assets/images/mail_icon.png"),
              "Password Confirm", passwordConfirme_F),
          Signup_Button(),
          Have(),
        ],
      )),
    );
  }

  Padding Signup_Button() {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 0),
      child: InkWell(
        onTap: () async {
          try {
            await Authentication().Signup(
                email: email.text,
                password: password.text,
                passwordConfirme: passwordConfirme.text,
                username: username.text,
                major: major.text,
                profile: _imageFile ?? File(''));
              Navigator.pushReplacement(
              context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
      );
          } on exceptions catch (e) {
            dialogBuilder(context, e.message);
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: 200,
          height: 60,
          decoration: BoxDecoration(
              color: Color(0xFF225AEB),
              borderRadius: BorderRadius.circular(20)),
          child: Text(
            "Sign up ",
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Container Head(context) {
    return Container(
      color: Color(0xFF225AEB),
      child: SizedBox(
        width: double.infinity,
        height: 280,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30, bottom: 7),
              child: Container(
                height: 10,
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      iconColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent, // ทำให้เงาหายไป
                      shape: CircleBorder(), // รูปทรงปุ่มเป็นวงกลม
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 24,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 30,
              ),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Create",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Your Account",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
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
                      "assets/images/sign_up_id_card.png",
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding Have() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Already have an account ?",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          GestureDetector(
            onTap: null,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Login",
                style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 23, 99, 240),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding Textfield(TextEditingController controller, AssetImage icon,
      String type, FocusNode focusNode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Container(
        width: 320,
        height: 55,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: TextField(
          style: TextStyle(fontSize: 18, color: Colors.black),
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
              hintText: type,
              hintStyle: TextStyle(
                  color: Color.fromARGB(255, 187, 186, 186), fontSize: 15),
              prefixIcon: Image(width: 70, image: icon),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 199, 193, 193), width: 1)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.pinkAccent, width: 2))),
        ),
      ),
    );
  }
}
