import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../global_variables.dart';
import '../data/model/vendor.dart';

class VendorController {
  // fetch vendor
  Future<List<Vendor>> loadVendors() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/vendors'),
        headers: <String, String>{"Content-Type": 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        List<Vendor> vendors = data.map((vendor) {
          return Vendor.fromJson(vendor);
        }).toList();

        return vendors;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Không tải được nhà cung cấp: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Lỗi tải nhà cung cấp: ${e.toString()}");
    }
  }
}
