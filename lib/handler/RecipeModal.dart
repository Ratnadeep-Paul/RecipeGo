import 'package:flutter/cupertino.dart';

class RecipeModal {
  late String appLabel;
  late String appImgUrl;
  late String appCalories;
  late String appUrl;

  RecipeModal({required this.appLabel, required this.appCalories, required this.appImgUrl, required this.appUrl});
  
  factory RecipeModal.fromMap(Map recipe) {
    return RecipeModal(
      appLabel: recipe["label"],
      appImgUrl: recipe["image"],
      appCalories: recipe["calories"].toString(),
      appUrl: recipe["url"],
    );
  }
}
