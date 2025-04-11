import 'package:multi_store/data/model/product_review.dart';
import 'package:http/http.dart' as http;

import '../global_variables.dart';
import '../services/manage_http_response.dart';

class ProductReviewController {
  get order => null;

  uploadReview({
    required String buyerId,
    required String fullName,
    required String email,
    required String productId,
    required double rating,
    required String review,
    required context,
  }) async {
    try {
      final ProductReview productReview = ProductReview(
        id: '',
        buyerId: buyerId,
        email: email,
        fullName: fullName,
        productId: productId,
        rating: rating,
        review: review,
      );
      http.Response response = await http.post(
        Uri.parse("$uri/api/product-review"),
        body: productReview.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Đánh giá thành công");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
