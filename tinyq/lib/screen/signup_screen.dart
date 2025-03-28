import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
            child: InkWell(
              onTap: null,
              child: CircleAvatar(
                radius: 45,
                backgroundColor: const Color.fromARGB(255, 243, 243, 243),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/sign_up_human.png',
                    width: double.infinity, 
                    height: 70,
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}

Container Head() {
  return Container(
    color: Color(0xFF225AEB),
    child: SizedBox(
      width: double.infinity,
      height: 290,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30, top: 50),
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
                    fontSize: 50,
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
          )
        ],
      ),
    ),
  );
}

Padding Have() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Already have an account ?",
            style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),),
            SizedBox(width: 15,),
            GestureDetector(
              onTap: null,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Login",
                style: TextStyle(
                fontSize: 16,
                color: const Color.fromARGB(255, 23, 99, 240),
                fontWeight: FontWeight.bold
                            ),),
              ),
            ),
          ],
        ),
      );
  }



  Padding Signup_Button() {
    return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(
            onTap: null,
            child: Container(
              alignment: Alignment.center,
              width: 265,
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFF225AEB),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Text("Signup in",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),),
            ),
          ),
        );
  }



  Padding Textfield(TextEditingController controller, AssetImage icon, String type,FocusNode focusNode) {
    return Padding(
          padding: EdgeInsets.symmetric(horizontal: 25,vertical: 15),
          child: Container(
            height: 55,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: TextField(
              style: TextStyle(fontSize: 18, color: Colors.black),
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                  hintText: type,
                  hintStyle: TextStyle(color:  Color.fromARGB(255, 145, 144, 144)),
                  prefixIcon: Image(
                    width: 70,
                    image: icon),
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