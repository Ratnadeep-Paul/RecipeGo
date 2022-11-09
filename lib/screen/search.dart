import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart";

import 'package:recipe_go/handler/constant.dart';
import '../handler/RecipeModal.dart';
import 'package:recipe_go/screen/recipeView.dart';

class Search extends StatefulWidget {
  String query;
  String searchType;
  Search(this.query, this.searchType);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String username = constant.name;
  bool isLoading = true;
  String searchQuery = "";

  List<RecipeModal> recipeList = <RecipeModal>[];
  TextEditingController searchController = TextEditingController();

  getRecipe(String query) async {
    setState(() {
      isLoading = true;
    });

    String url = "";

    if (widget.searchType == "q") {
      url =
          "https://api.edamam.com/search?q=$query&=app_id=6628de0c&app_key=87d2e4d5b5a4e6aec2b60300ee5d5cac&from=0&to=100";
    } else {
      String searchTypeStr = widget.searchType;

      url =
          "https://api.edamam.com/api/recipes/v2?type=public&app_id=6628de0c&app_key=87d2e4d5b5a4e6aec2b60300ee5d5cac&$searchTypeStr=$query&random=true";
    }

    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);

    recipeList.clear();
    data['hits'].forEach((element) {
      RecipeModal recipeModal = RecipeModal.fromMap(element['recipe']);
      recipeList.add(recipeModal);
    });

    for (var recipes in recipeList) {
      print(recipes.appLabel);
    }

    setState(() {
      searchQuery = query;
      isLoading = false;
    });
  }

  @override
  void initState() {
    getRecipe(widget.query);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 255, 196, 0),
              Color.fromARGB(255, 255, 240, 152)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SafeArea(
                    child: Container(
                      // Search Container
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(211, 255, 255, 255),
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if ((searchController.text.replaceAll(" ", "")) !=
                                  "") {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Search(
                                            searchController.text, "q")));
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(3, 0, 8, 0),
                              child: Icon(
                                Icons.search,
                                color: Color.fromARGB(255, 255, 102, 0),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              textInputAction: TextInputAction.search,
                              onSubmitted: ((value) async {
                                if ((value.replaceAll(" ", "")) != "") {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Search(
                                              searchController.text, "q")));
                                }
                              }),
                              controller: searchController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Lets Cook Something...",
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 255, 102, 0))),
                            ),
                          ),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                constant.img,
                                height: 35,
                                width: 35,
                              ))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: isLoading
                        ? Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Card(
                              color: Color.fromARGB(220, 255, 252, 54),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(
                                  backgroundColor:
                                      Color.fromARGB(255, 37, 37, 37),
                                  color: Color.fromARGB(255, 255, 51, 0),
                                ),
                              ),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                 textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    "Showing Results For ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(169, 22, 21, 26)),
                                  ), 
                                  Text(
                                    "$searchQuery",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 22, 21, 26)),
                                  )
                                ],
                              ),
                              Container(
                                transform:
                                    Matrix4.translationValues(0.0, -20.0, 0.0),
                                child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: recipeList.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => RecipeView(
                                                  recipeList[index].appUrl,
                                                  recipeList[index].appLabel,
                                                  recipeList[index].appImgUrl),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          margin: const EdgeInsets.only(
                                              bottom: 20.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          elevation: 0.0,
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Image.network(
                                                    recipeList[index].appImgUrl,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: 200,
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Center(
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(0, 80,
                                                                  0, 110),
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      );
                                                    },
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Center(
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 50,
                                                                horizontal: 0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => Search(
                                                                        widget
                                                                            .query,
                                                                        widget
                                                                            .searchType)));
                                                          },
                                                          child: Column(
                                                            children: [
                                                              CircularProgressIndicator(),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                  "Tap To Load",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontFamily:
                                                                          "Ribik"))
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                              Positioned(
                                                  left: 0,
                                                  right: 0,
                                                  bottom: 0,
                                                  child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5,
                                                          horizontal: 10),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.black26,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            10)),
                                                      ),
                                                      child: Text(
                                                        recipeList[index]
                                                            .appLabel,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontFamily: 'Rubik',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ))),
                                              Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  width: 80,
                                                  height: 30,
                                                  child: Container(
                                                      decoration: const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomLeft:
                                                                      Radius.circular(
                                                                          10))),
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Icon(Icons
                                                                .local_fire_department),
                                                            Text(
                                                              recipeList[index]
                                                                          .appCalories
                                                                          .length >
                                                                      6
                                                                  ? recipeList[
                                                                          index]
                                                                      .appCalories
                                                                      .substring(
                                                                          0, 6)
                                                                  : recipeList[
                                                                          index]
                                                                      .appCalories,
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      'Rubik',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ],
                                                        ),
                                                      )))
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
