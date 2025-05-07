import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/provider/banner_provider.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'inner_banner_widget.dart';

class BannerWidget extends ConsumerStatefulWidget {
  const BannerWidget({super.key});

  @override
  ConsumerState<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends ConsumerState<BannerWidget> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Thiết lập timer để tự động chuyển banner mỗi 5 giây
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        final banners = ref.read(bannerProvider).banners;
        if (banners.isNotEmpty) {
          _currentPage = (_currentPage + 1) % banners.length;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bannerState = ref.watch(bannerProvider);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(bannerProvider.notifier).refreshBanners();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: 180,
              child: bannerState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : bannerState.error != null
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.pink,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bannerState.error!,
                      style: const TextStyle(color: AppColors.pink),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
                  : bannerState.banners.isEmpty
                  ? const Center(child: Text("Không có banner"))
                  : PageView.builder(
                controller: _pageController,
                reverse: false,
                itemCount: bannerState.banners.length,
                itemBuilder: (context, index) {
                  final banner = bannerState.banners[index];
                  return InnerBannerWidget(image: banner.image);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}