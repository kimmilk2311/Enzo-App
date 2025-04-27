import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert'; // Import thêm để hỗ trợ chuyển đổi từ JSON String
import 'package:vendor_store/models/vendor.dart';

// StateNotifier: Quản lý trạng thái vendor
class VendorProvider extends StateNotifier<Vendor?> {
  VendorProvider()
      : super(Vendor(
    id: '',
    fullName: '',
    email: '',
    phone: '',
    address: '',
    image: '',
    role: '',
    password: '',
    token: '',
  ));

  // Getter lấy thông tin vendor hiện tại
  Vendor? get vendor => state;

  // Phương thức cập nhật state từ JSON String
  // Mục đích: Cập nhật trạng thái vendor dựa trên chuỗi JSON đại diện cho đối tượng vendor
  void setVendor(String vendorJson) {
    final Map<String, dynamic> vendorMap = jsonDecode(vendorJson);
    state = Vendor.fromJson(vendorMap);
  }

  // Phương thức cập nhật state từ Object Vendor
  void setVendorFromObject(Vendor vendor) {
    state = vendor;
  }

  // Phương thức chuyển trạng thái vendor về null khi đăng xuất
  void signOut() {
    state = Vendor(
      id: '',
      fullName: '',
      email: '',
      phone: '',
      address: '',
      image: '',
      role: '',
      password: '',
      token: '',
    );
  }

}

// Provider cho VendorProvider
final vendorProvider = StateNotifierProvider<VendorProvider, Vendor?>((ref) {
  return VendorProvider();
});
