import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';

class VendorProductProvider extends StateNotifier<List<Product>>{
  VendorProductProvider():super([]);

  void setProducts(List<Product> products){
    state = products;
  }
}
final vendorProductProvider = StateNotifierProvider<VendorProductProvider,List<Product>>(
        (ref){
      return VendorProductProvider();
    }
);