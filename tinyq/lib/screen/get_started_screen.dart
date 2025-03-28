import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinyq/screen/login_screen.dart';
import 'package:tinyq/screen/signup_screen.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Color(0xFF225AEB),
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "TinyQ?",
                      style: GoogleFonts.pacifico(
                          fontSize: 80,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(vertical: 3),
                    child: Image(
                      image: AssetImage('assets/images/app_icon.png'),
                      height: 360,
                      width: 360,
                    ),
                  ),
                  SizedBox(height: 50,),
                  SizedBox(
                    width: 275,
                    height: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60)
                        )
                      ) ,
                      onPressed: (){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context)=>SignupScreen()));
                      }, 
                      child: Container(
                        child: Text("Get Start",
                        style: TextStyle(
                          fontSize: 25
                        ),),
                      )),
                  ),
                  SizedBox(height: 30,),
                  SizedBox(
                    width: 275,
                    height: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60)
                        )
                      ) ,
                      onPressed: (){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context)=> LoginScreen()));
                      }, 
                      child: Container(
                        child: Text("Log in",
                        style: TextStyle(
                          fontSize: 25
                        ),),
                      )),
                  )
                ],
              ),
            ),
          ),
        );
  }
}