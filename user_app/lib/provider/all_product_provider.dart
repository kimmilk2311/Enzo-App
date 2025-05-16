import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/data/model/product.dart';

class AllProductProvider extends StateNotifier<List<Product>>{
  AllProductProvider():super([]);

  void setProducts(List<Product> products){
    state = products;
  }
}
final allProductProvider = StateNotifierProvider<AllProductProvider,List<Product>>(
        (ref){
      return AllProductProvider();
    }
);