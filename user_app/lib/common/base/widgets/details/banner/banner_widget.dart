import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/controller/banner_controller.dart';
import 'package:multi_store/data/model/banner_model.dart';
import 'package:multi_store/provider/banner_provider.dart';
import 'package:multi_store/resource/theme/app_colors.dart';

class BannerWidget extends ConsumerStatefulWidget {
  const BannerWidget({super.key});

  @override
  ConsumerState<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends ConsumerState<BannerWidget> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBanners();
  }

  Future<void> _loadBanners() async {
    try {
      final controller = BannerController();
      final banners = await controller.loadBanners();
      ref.read(bannerProvider.notifier).setBanners(banners);
    } catch (e) {
      print("Error loading banners: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final banners = ref.watch(bannerProvider);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : banners.isEmpty
            ? const Center(child: Text("Không có banner"))
            : PageView.builder(
          itemCount: banners.length,
          itemBuilder: (context, index) {
            final BannerModel banner = banners[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  banner.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
