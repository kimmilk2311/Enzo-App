import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/banner_model.dart';
import '../controller/banner_controller.dart';

class BannerProvider extends StateNotifier<BannerState> {
  BannerProvider() : super(BannerState()) {
    _loadBanners();
  }

  Future<void> _loadBanners({bool forceRefresh = false}) async {
    // Chỉ tải lại nếu chưa có dữ liệu hoặc được yêu cầu làm mới
    if (state.banners.isNotEmpty && !forceRefresh) {
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);
      final controller = BannerController();
      final banners = await controller.loadBanners();
      state = state.copyWith(banners: banners, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Không thể tải banner: $e',
      );
    }
  }

  Future<void> refreshBanners() async {
    await _loadBanners(forceRefresh: true);
  }

  void setBanners(List<BannerModel> banners) {
    state = state.copyWith(banners: banners, isLoading: false, error: null);
  }
}

class BannerState {
  final List<BannerModel> banners;
  final bool isLoading;
  final String? error;

  BannerState({
    this.banners = const [],
    this.isLoading = false,
    this.error,
  });

  BannerState copyWith({
    List<BannerModel>? banners,
    bool? isLoading,
    String? error,
  }) {
    return BannerState(
      banners: banners ?? this.banners,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final bannerProvider = StateNotifierProvider<BannerProvider, BannerState>((ref) {
  return BannerProvider();
});