import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:http/http.dart';
import 'package:recipe_go/handler/constant.dart';
import 'package:recipe_go/screen/home.dart';
import 'package:recipe_go/services/auth.dart';
import 'package:recipe_go/handler/localdb.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String imageName = "asset/images/cooking.png";
  String name = "";

  void checkUser() async {
    constant.name = (await localDataSaver.getName()).toString();
    constant.email = (await localDataSaver.getEmail()).toString();
    constant.img = (await localDataSaver.getImg()).toString();

    if (constant.name != "null") {
      if (constant.email != "null") {
        if (constant.img != "null" ) {
          Navigator.pushReplacementNamed(context, "/home");
        }
      }
    }
  }

  void changeImg() async {
    Timer.periodic(new Duration(seconds: 3), (timer) {
      if (imageName == "asset/images/cooking.png") {
        imageName = "asset/images/cookings.png";
      } else if (imageName == "asset/images/cookings.png") {
        imageName = "asset/images/cookingss.png";
      } else {
        imageName = "asset/images/cooking.png";
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    checkUser();
    changeImg();
    super.initState();
  }

  void authUser(User isUser) async {
    if (!isUser.isAnonymous) {
      if (isUser.displayName != "") {
        if (isUser.uid != "") {
          constant.name = (await localDataSaver.getName()).toString();
          constant.email = (await localDataSaver.getEmail()).toString();
          constant.img = (await localDataSaver.getImg()).toString();
          Navigator.pushReplacementNamed(context, "/home");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 25, 0, 255),
          Color.fromARGB(255, 0, 41, 155)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Center(
            child: Container(
                child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Image.asset(
              "asset/images/launcher.png",
              height: 200,
              width: 200,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Recipe Go",
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 189, 46),
                  fontSize: 40,
                  fontFamily: "Lemonmilk",
                  fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 255, 196, 0),
                      Color.fromARGB(255, 255, 240, 152)
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Text(
                          "Learn How To Cook Your Favorite Dishes On The Go.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                            fontFamily: "Rubik",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 10),
                        child: Image.asset(
                          "$imageName",
                          height: 205,
                          width: 205,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: Text(
                          "Login To Your Account",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 41, 155),
                            fontSize: 20,
                            fontFamily: "Lemonmilk",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SignInButton(Buttons.Google, onPressed: () async {
                              User? isUser = await signInWithGoogle();
                              authUser(isUser!);
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ))),
      ),
    );
  }
}
