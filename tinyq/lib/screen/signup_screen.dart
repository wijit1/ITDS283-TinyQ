import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinyq/data/firebase_service/firebase_auth.dart';
import 'package:tinyq/screen/home.dart';
import 'package:tinyq/util/dialog.dart';
import 'package:tinyq/util/exception.dart';
import 'package:tinyq/util/imagepicker.dart';
import 'package:tinyq/screen/login_screen.dart';

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
      body: Column(
        children: [
          Head(context),
          SizedBox(height: 10.h),
          Center(
            child: InkWell(
              onTap: () async {
                File? _imagefilee = await ImagePickerr().uploadImage('gallery');
                if (_imagefilee == null) return;
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
                          height: 70.h,
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
          Textfield(username, AssetImage("assets/images/user_icon.png"),
              "Username", username_F),
          Textfield(email, AssetImage("assets/images/mail_icon.png"), "Email",
              email_F),
          Textfield(major, AssetImage("assets/images/major_icon.png"), "Major",
              major_F),
          Textfield(password, AssetImage("assets/images/lock_icon.png"),
              "Password", password_F,
              obscureText: true),
          Textfield(passwordConfirme, AssetImage("assets/images/lock_icon.png"),
              "Password Confirm", passwordConfirme_F,
              obscureText: true),
          Signup_Button(),
          Have(),
        ],
      ),
    );
  }

  Padding Signup_Button() {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 0),
      child: InkWell(
        onTap: () async {
          if (email.text.isEmpty ||
            password.text.isEmpty ||
            passwordConfirme.text.isEmpty ||
            username.text.isEmpty ||
            major.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("กรุณากรอกข้อมูลให้ครบถ้วน"),
              backgroundColor: Colors.red,
            ),
          );
          return; 
        }

        if(password.text != passwordConfirme){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Password ไม่ตรงกับ  PasswordConfirm"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
          try {
            await Authentication().Signup(
              email: email.text,
              password: password.text,
              passwordConfirme: passwordConfirme.text,
              username: username.text,
              major: major.text,
              profile: _imageFile ?? File(''),
            );
            Navigator.pop(context);
          } on exceptions catch (e) {
            dialogBuilder(context, e.message);
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: 200.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: Color(0xFF225AEB),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "Sign up ",
            style: TextStyle(
              fontSize: 25.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
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
        height: 250.h,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30.h, bottom: 7.h),
              child: Container(
                height: 10.h,
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    iconColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: CircleBorder(),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back, size: 24),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Create",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.sp,
                    fontWeight: FontWeight.bold,
                  ),
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
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 50),
              child: Container(
                alignment: Alignment.centerRight,
                child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/sign_up_id_card.png"),
                ),
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
              fontSize: 16.sp,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 15.w),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Color.fromARGB(255, 23, 99, 240),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  
  Padding Textfield(
    TextEditingController controller,
    AssetImage icon,
    String type,
    FocusNode focusNode, {
    bool obscureText = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Container(
        width: 320.w,
        height: 55.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          style: TextStyle(fontSize: 18.sp, color: Colors.black),
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText, // << ซ่อนรหัสผ่านตรงนี้
          decoration: InputDecoration(
            hintText: type,
            hintStyle: TextStyle(
              color: Color.fromARGB(255, 187, 186, 186),
              fontSize: 15.sp,
            ),
            prefixIcon: Image(width: 70.w, image: icon),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 100.w, vertical: 15.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Color.fromARGB(255, 199, 193, 193),
                width: 1.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.pinkAccent,
                width: 2.w,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
