import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart";
import 'package:recipe_go/handler/constant.dart';
import 'package:recipe_go/screen/recipeView.dart';
import 'package:recipe_go/screen/search.dart';

import '../handler/RecipeModal.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String username = constant.name;
  String user_email = constant.email;
  bool isLoading = true;
  bool recentLoading = true;
  bool recentNotAvailable = true;

  List<RecipeModal> recipeList = <RecipeModal>[];
  TextEditingController searchController = TextEditingController();
  List recipeCatList = [
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1558961363-fa8fdf82db35?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8YmlzY3VpdHN8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
      "heading": "Biscuits and cookies"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1549931319-a545dcf3bc73?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8YnJlYWR8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
      "heading": "Bread"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1521483451569-e33803c0330c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8Y2VyZWFsc3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
      "heading": "Cereals"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1624353365286-3f8d62daad51?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTR8fGRlc3NlcnRzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
      "heading": "Desserts"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1563227812-0ea4c22e6cc8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fGRyaW5rc3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
      "heading": "Drinks"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1529566652340-2c41a1eb6d93?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTR8fG1haW4lMjBjb3Vyc2V8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
      "heading": "Main course"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/flagged/photo-1557609786-fd36193db6e5?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8cGFuY2FrZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
      "heading": "Pancake"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1591123220262-87ed377f7c08?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTV8fHN3ZWV0c3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
      "heading": "Sweets"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1579712267685-42da80f60aa4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8c3RhcnRlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
      "heading": "Starter"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8c2FsYWR8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
      "heading": "Salad"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1639667852145-466e29aa49fd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTR8fHNhbmR3aWNoZXN8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
      "heading": "Sandwiches"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1547592166-23ac45744acd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8c291cHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
      "heading": "Soup"
    },
  ];

  Map recentRecipeMap = {};
  List recentRecipeNames = [];
  List recentRecipeImgs = [];
  List recentRecipeLinks = [];

  void getRecent() async {
    setState(() {
      recentLoading = true;
    });

    String url =
        "https://sharpwebtechnologies.com/RecipeGo/recent-recipe.php?user-mail=$user_email";

    Response response = await get(Uri.parse(url));

    recentRecipeMap = jsonDecode(response.body);

    recentRecipeNames = recentRecipeMap['recipe_name'];
    recentRecipeImgs = recentRecipeMap['recipe_img'];
    recentRecipeLinks = recentRecipeMap['recipe_link'];

    setState(() {
      recentLoading = false;
      if (recentRecipeNames.length > 0) {
        recentNotAvailable = false;
      }
    });
  }

  getRecipe() async {
    setState(() {
      isLoading = true;
    });

    String url =
        "https://api.edamam.com/api/recipes/v2?type=public&app_id=6628de0c&app_key=87d2e4d5b5a4e6aec2b60300ee5d5cac&cuisineType=Indian&random=true";

    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);

    recipeList.clear();
    data['hits'].forEach((element) {
      RecipeModal recipeModal = RecipeModal.fromMap(element['recipe']);
      recipeList.add(recipeModal);
    });

    // for (var recipes in recipeList) {
    //   print(recipes.appLabel);
    // }

    setState(() {
      isLoading = false;
    });
  }

  List<RecipeModal> timedRecipeList = <RecipeModal>[];
  bool timedLoading = true;
  String timeName = "";
  void getTimedRecipe() async {
    setState(() {
      timedLoading = true;
    });

    var dt = DateTime.now();
    String url = "";

    if (dt.hour >= 3 && dt.hour <= 12) {
      timeName = "Breakfast";
      url =
          "https://api.edamam.com/api/recipes/v2?type=public&app_id=6628de0c&app_key=87d2e4d5b5a4e6aec2b60300ee5d5cac&mealType=Breakfast&random=true";
    } else if (dt.hour > 12 && dt.hour <= 16) {
      timeName = "Lunch";
      url =
          "https://api.edamam.com/api/recipes/v2?type=public&app_id=6628de0c&app_key=87d2e4d5b5a4e6aec2b60300ee5d5cac&mealType=Lunch&random=true";
    } else if (dt.hour > 16 && dt.hour <= 20) {
      timeName = "Snack";
      url =
          "https://api.edamam.com/api/recipes/v2?type=public&app_id=6628de0c&app_key=87d2e4d5b5a4e6aec2b60300ee5d5cac&mealType=Snack&random=true";
    } else {
      timeName = "Dinner";
      url =
          "https://api.edamam.com/api/recipes/v2?type=public&app_id=6628de0c&app_key=87d2e4d5b5a4e6aec2b60300ee5d5cac&mealType=Dinner&random=true";
    }

    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);

    timedRecipeList.clear();
    data['hits'].forEach((element) {
      RecipeModal recipeModal = RecipeModal.fromMap(element['recipe']);
      timedRecipeList.add(recipeModal);
    });

    setState(() {
      timedLoading = false;
    });
  }

  @override
  void initState() {
    getRecipe();
    getRecent();
    getTimedRecipe();
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Search(
                                            searchController.text, "q")));
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(3, 0, 8, 0),
                              child: const Icon(
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Search(
                                              searchController.text, "q")));
                                }
                              }),
                              controller: searchController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Lets Cook Something",
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 255, 102, 0))),
                            ),
                          ),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: GestureDetector(
                                onTap: (() {
                                  Navigator.pushNamed(context, '/home');
                                }),
                                child: Image.network(
                                  constant.img,
                                  height: 35,
                                  width: 35,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, 👋 $username",
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Color.fromARGB(255, 6, 4, 27),
                                fontFamily: "Rubik"),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "WHAT YOU WANT TO COOK TODAY🍳",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 25,
                                fontFamily: "Lemonmilk"),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text("Lets Cook Something New😋",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                ),
                              )),
                        ]),
                  ),
                  Column(
                    // Recent Visited Dishes
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      recentLoading
                          ? const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Card(
                                color: Color.fromARGB(220, 255, 252, 54),
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: CircularProgressIndicator(
                                    backgroundColor:
                                        Color.fromARGB(255, 37, 37, 37),
                                    color: Color.fromARGB(255, 255, 51, 0),
                                  ),
                                ),
                              ),
                            )
                          : recentNotAvailable
                              ? const SizedBox(
                                  height: 0,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 15, 0, 10),
                                      child: Text(
                                        "Recently Visited",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 22, 21, 26)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 0),
                                      child: Container(
                                        height: 180,
                                        child: ListView.builder(
                                          itemCount: recentRecipeNames.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          RecipeView(
                                                              recentRecipeLinks[
                                                                  index],
                                                              recentRecipeNames[
                                                                  index],
                                                              recentRecipeImgs[
                                                                  index]),
                                                    ));
                                              },
                                              child: Card(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 5, 15, 5),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                elevation: 0.0,
                                                child: Stack(
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: Image.network(
                                                          recentRecipeImgs[index],
                                                          height: 180,
                                                          width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width) -
                                                              100,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (context,
                                                                  error,
                                                                  stackTrace) =>
                                                              Center(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          50,
                                                                      horizontal:
                                                                          0),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  getRecent();
                                                                },
                                                                child: Column(
                                                                  children: [
                                                                    CircularProgressIndicator(),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
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
                                                        top: 0,
                                                        child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        5),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: Colors
                                                                    .black38),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  recentRecipeNames[
                                                                      index],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          "Rubik"),
                                                                ),
                                                              ],
                                                            ))),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                    ],
                  ),
                  Container(
                    // Search Dishes
                    child: isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Card(
                              color: Color.fromARGB(220, 255, 252, 54),
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(
                                  backgroundColor:
                                      Color.fromARGB(255, 37, 37, 37),
                                  color: Color.fromARGB(255, 255, 51, 0),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    "Trending Indian Dishes",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 22, 21, 26)),
                                  ),
                                  Container(
                                    transform: Matrix4.translationValues(
                                        0.0, -20.0, 0.0),
                                    child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: recipeList.length - 10,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RecipeView(
                                                            recipeList[index]
                                                                .appUrl,
                                                            recipeList[index]
                                                                .appLabel,
                                                            recipeList[index]
                                                                .appImgUrl),
                                                  ));
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
                                                        recipeList[index]
                                                            .appImgUrl,
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: 200,
                                                        errorBuilder: (context,
                                                                error,
                                                                stackTrace) =>
                                                            Center(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        50,
                                                                    horizontal:
                                                                        0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                getRecipe();
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
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      10),
                                                          decoration:
                                                              const BoxDecoration(
                                                            color:
                                                                Colors.black26,
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        10)),
                                                          ),
                                                          child: Text(
                                                            recipeList[index]
                                                                .appLabel,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    'Rubik',
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
                                                              color:
                                                                  Colors.white,
                                                              borderRadius: BorderRadius.only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomLeft: Radius
                                                                      .circular(
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
                                                                              0,
                                                                              6)
                                                                      : recipeList[
                                                                              index]
                                                                          .appCalories,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15,
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
                          ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                        child: Text(
                          "Categories",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 22, 21, 26)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        child: Container(
                          height: 180,
                          child: ListView.builder(
                            itemCount: recipeCatList.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Search(
                                              recipeCatList[index]['heading'],
                                              "dishType")));
                                },
                                child: Card(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 5, 15, 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 0.0,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.network(
                                            recipeCatList[index]['imgUrl'],
                                            height: 180,
                                            width: (MediaQuery.of(context)
                                                    .size
                                                    .width) -
                                                100,
                                            fit: BoxFit.cover,
                                          )),
                                      Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          top: 0,
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.black38),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    recipeCatList[index]
                                                        ['heading'],
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: "Rubik"),
                                                  ),
                                                ],
                                              ))),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    // Timed Dishes
                    child: timedLoading
                        ? const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Card(
                              color: Color.fromARGB(220, 255, 252, 54),
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(
                                  backgroundColor:
                                      Color.fromARGB(255, 37, 37, 37),
                                  color: Color.fromARGB(255, 255, 51, 0),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    "$timeName Dishes",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 22, 21, 26)),
                                  ),
                                  Container(
                                    transform: Matrix4.translationValues(
                                        0.0, -20.0, 0.0),
                                    child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: timedRecipeList.length - 10,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RecipeView(
                                                            timedRecipeList[index]
                                                                .appUrl,
                                                            timedRecipeList[index]
                                                                .appLabel,
                                                            timedRecipeList[index]
                                                                .appImgUrl),
                                                  ));
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
                                                        timedRecipeList[index]
                                                            .appImgUrl,
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: 200,
                                                        errorBuilder: (context,
                                                                error,
                                                                stackTrace) =>
                                                            Center(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        50,
                                                                    horizontal:
                                                                        0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                              getTimedRecipe();
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
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      10),
                                                          decoration:
                                                              const BoxDecoration(
                                                            color:
                                                                Colors.black26,
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        10)),
                                                          ),
                                                          child: Text(
                                                            timedRecipeList[index]
                                                                .appLabel,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    'Rubik',
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
                                                              color:
                                                                  Colors.white,
                                                              borderRadius: BorderRadius.only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomLeft: Radius
                                                                      .circular(
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
                                                                  timedRecipeList[index]
                                                                              .appCalories
                                                                              .length >
                                                                          6
                                                                      ? timedRecipeList[
                                                                              index]
                                                                          .appCalories
                                                                          .substring(
                                                                              0,
                                                                              6)
                                                                      : timedRecipeList[
                                                                              index]
                                                                          .appCalories,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15,
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
