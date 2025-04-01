import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_store/models/vendor.dart';

// StateNotifier: quan ly trang thai vendor
// StateNotifier la mot class duoc cung cap boi Riverpod de giup quan ly trang thai,
// no cung duoc thiet ke de thong bao cho cac listener ve su thay doi trang thai
class VendorProvider extends StateNotifier<Vendor?> {
  VendorProvider()
      : super(Vendor(
    id: '',
    fullName: '',
    email: '',
    state: '',
    city: '',
    locality: '',
    role: '',
    password: '',
  ));

  // Getter lay thong tin vendor hien tai
  Vendor? get vendor => state;

  // Phuong thuc cap nhat state tu JSON
  // Muc dich: Cap nhat trang thai vendor dua tren chuoi JSON dai dien cho doi tuong vendor
  void setVendor(String vendorJson) {
    state = Vendor.fromJson(vendorJson);
  }

  // Phuong thuc xoa trang thai vendor khi dang xuat
  void signOut() {
    state = null;
  }
}

// Provider cho VendorProvider
final vendorProvider = StateNotifierProvider<VendorProvider, Vendor?>((ref) {
  return VendorProvider();
});
