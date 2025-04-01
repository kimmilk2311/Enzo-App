import 'dart:convert';


import 'package:http/http.dart' as http;

import '../../../data/model/banner_model.dart';
import '../../../global_variables.dart';

class BannerController {


  // fetch banners
  Future<List<BannerModel>> loadBanners() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/banner'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        List<BannerModel> banners = data.map((banner) {
          return BannerModel.fromJson(banner);
        }).toList();

        return banners;
      } else {
        throw Exception('Failed to load banners. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Error loading banners: ${e.toString()}");
    }
  }
}
