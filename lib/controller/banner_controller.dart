import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;
import 'package:store_app_web/global_variable.dart';
import 'package:store_app_web/models/banner.dart';
import 'package:store_app_web/services/http_handler.dart';

class BannerController {
  // upload banner
  uploadBanner({required dynamic pickedImage, required context}) async {
    try {
      final cloudinary = CloudinaryPublic('dp4cxycud', "bpucants");

      //upload the image
      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedImage,
          identifier: 'pickedImage',
          folder: 'banners',
        ),
      );

      String imageUrl = imageResponse.secureUrl;

      BannerModel bannerModel = BannerModel(id: "", image: imageUrl);

      http.Response response = await http.post(
        Uri.parse('$uri/api/banner'),
        body: bannerModel.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      handlerHttp(
        response: response,
        context: context,
        onSuccess: () {
          showBar(context, 'Uploaded banner');
          print('Data successfully uploaded');
        },
      );
    } catch (e) {
      print('Error uploading to cloudinary: $e');
      showBar(context, 'error : $e');
    }
  }

  // fetch banner
  Future<List<BannerModel>> fetchBanner() async {
    try {
      // send http get request to fetch banner
      http.Response response = await http.get(
        Uri.parse('$uri/api/banner'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> bannerData = jsonDecode(response.body);

        List<BannerModel> banners =
            bannerData.map((banner) => BannerModel.fromJson(banner)).toList();
        return banners;
      } else {
        // throw an execption if the server responded with an error status code
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Error loading banner $e');
    }
  }
}
