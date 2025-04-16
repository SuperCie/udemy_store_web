import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:store_app_web/global_variable.dart';
import 'package:store_app_web/models/subcategory.dart';
import 'package:http/http.dart' as http;
import 'package:store_app_web/services/http_handler.dart';

class SubcategoryController {
  //post
  uploadSubcategory({
    required categoryId,
    required categoryName,
    required pickedImage,
    required subCategoryName,
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

      String image = imageResponse.secureUrl;
      Subcategory subcategory = Subcategory(
        id: "",
        categoryId: categoryId,
        categoryName: categoryName,
        image: image,
        subCategoryName: subCategoryName,
      );

      http.Response response = await http.post(
        Uri.parse("$uri/api/subcategories"),
        body: subcategory.toJson(),
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

  // fetch data
  Future<List<Subcategory>> fetchSubcategory() async {
    try {
      // send http get request to fetch data
      http.Response response = await http.get(
        Uri.parse('$uri/api/subcategories'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );
      print(response.body);
      // check the response status code data
      if (response.statusCode == 200) {
        // convert response json to dart object
        final List<dynamic> subcategoriesData = jsonDecode(response.body);
        // convert to category object
        List<Subcategory> subcategory =
            subcategoriesData
                .map((subcat) => Subcategory.fromJson(subcat))
                .toList();
        return subcategory;
      } else {
        throw Exception('Failed to get Data');
      }
    } catch (e) {
      throw Exception('Failed to load data : $e');
    }
  }
}
