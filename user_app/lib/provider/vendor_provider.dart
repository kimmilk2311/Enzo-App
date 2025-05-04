import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/data/model/vendor.dart';

class VendorProvider extends StateNotifier<List<Vendor>>{
  VendorProvider(): super([]);

  void setVendors(List<Vendor> vendors){
    state = vendors;
  }
}

final vendorProvider = StateNotifierProvider<VendorProvider, List<Vendor>>((ref){
  return VendorProvider();
});