import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:store_app_web/global_variable.dart';
import 'package:store_app_web/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:store_app_web/services/http_handler.dart';

class CategoryController {
  // upload image
  uploadCategory({
    required String name,
    required dynamic pickedImage,
    required dynamic pickedBanner,
    required context,
  }) async {
    try {
      final cloudinary = CloudinaryPublic('dp4cxycud', "bpucants");

      // upload the image
      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedImage,
          identifier: 'pickedImage',
          folder: 'categoryImages',
        ),
      );

      String imageUrl = imageResponse.secureUrl;

      // upload the banner
      CloudinaryResponse bannerResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedBanner,
          identifier: "pickedBanner",
          folder: 'categoryImages',
        ),
      );

      String bannerUrl = bannerResponse.secureUrl;

      Category category = Category(
        id: "",
        name: name,
        image: imageUrl,
        banner: bannerUrl,
      );

      http.Response response = await http.post(
        Uri.parse("$uri/api/categories"),
        body: category.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      handlerHttp(
        response: response,
        context: context,
        onSuccess: () {
          showBar(context, 'Uploaded Category');
          print("Uploaded");
        },
      );
    } catch (e) {
      print('Error uploading to cloudinary: $e');
      showBar(context, 'error : $e');
    }
  }

  // fetch category
  Future<List<Category>> fetchCategory() async {
    try {
      // send http get request to fetch data
      http.Response response = await http.get(
        Uri.parse('$uri/api/categories'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      print(response.body);
      // check the response status code data
      if (response.statusCode == 200) {
        // convert response json to dart object
        final List<dynamic> categoryData = jsonDecode(response.body);

        // convert to category object
        List<Category> categories =
            categoryData
                .map((category) => Category.fromJson(category))
                .toList();
        return categories;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
