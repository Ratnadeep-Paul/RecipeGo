import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:recipe_go/handler/constant.dart';

class RecipeView extends StatefulWidget {
  String url;
  String name;
  String img;
  RecipeView(this.url, this.name, this.img);

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  final Completer<WebViewController> controller =
      Completer<WebViewController>();

  late String finalUrl;
  late String recipeName;

  Future<void> recentSet(
      String recipe_name, String recipe_img, String recipe_link) async {
    String user_email = constant.email.toString();
    String apiUrl =
        "https://sharpwebtechnologies.com/RecipeGo/recent-recipe.php";

    Response response = await post(
      Uri.parse(apiUrl), body: {
        'user-mail': user_email,
        'recipe-name' : recipe_name,
        'recipe-img' : recipe_img,
        'recipe-link' : recipe_link,
      },
    );
  }

  @override
  void initState() {
    if (widget.url.toString().contains("http://")) {
      finalUrl = widget.url.toString().replaceAll("http://", "https://");
    } else {
      finalUrl = widget.url.toString();
    }

    recipeName = widget.name;
    recentSet(
        widget.name.toString(), widget.img, widget.url.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
            color: Color.fromARGB(255, 235, 176, 0),
            fontFamily: "Rubik",
            fontWeight: FontWeight.bold),
        title: Text(
          "$recipeName",
        ),
        iconTheme:
            IconThemeData(color: Color.fromARGB(255, 235, 176, 0), size: 25),
        centerTitle: true,
      ),
      body: Container(
          child: WebView(
              initialUrl: "$finalUrl",
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                setState(() {
                  controller.complete(webViewController);
                });
              })),
    );
  }
}
