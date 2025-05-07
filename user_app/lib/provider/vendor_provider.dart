import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/controller/vendor_controller.dart';
import 'package:multi_store/data/model/vendor.dart';

class VendorProvider extends StateNotifier<VendorState> {
  VendorProvider() : super(VendorState()) {
    _loadVendors();
  }

  Future<void> _loadVendors({bool forceRefresh = false}) async {
    // Chỉ tải lại nếu chưa có dữ liệu hoặc được yêu cầu làm mới
    if (state.vendors.isNotEmpty && !forceRefresh) {
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);
      final controller = VendorController();
      final vendors = await controller.loadVendors();
      state = state.copyWith(vendors: vendors, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Không thể tải danh sách cửa hàng: $e',
      );
    }
  }

  Future<void> refreshVendors() async {
    await _loadVendors(forceRefresh: true);
  }

  void setVendors(List<Vendor> vendors) {
    state = state.copyWith(vendors: vendors, isLoading: false, error: null);
  }
}

class VendorState {
  final List<Vendor> vendors;
  final bool isLoading;
  final String? error;

  VendorState({
    this.vendors = const [],
    this.isLoading = false,
    this.error,
  });

  VendorState copyWith({
    List<Vendor>? vendors,
    bool? isLoading,
    String? error,
  }) {
    return VendorState(
      vendors: vendors ?? this.vendors,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final vendorProvider = StateNotifierProvider<VendorProvider, VendorState>((ref) {
  return VendorProvider();
});