import 'dart:convert';

import 'package:admin_panel_app_web/global_variable.dart';
import 'package:admin_panel_app_web/models/buyer.dart';
import 'package:http/http.dart' as http;

class BuyerController {
  Future<List<Buyer>> loadBuyer() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/user'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        List<Buyer> buyers = data.map((buyer) {
          return Buyer.fromMap(buyer);
        }).toList();

        return buyers;
      } else {
        throw Exception(
            'Failed to load Buyer. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Error loading Buyers: ${e.toString()}");
    }
  }
}
