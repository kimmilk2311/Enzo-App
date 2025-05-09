import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/common/base/widgets/common/hearder_widget.dart';
import 'package:multi_store/data/model/category_model.dart';
import 'package:multi_store/provider/category_provider.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';
import '../banner/inner_banner_widget.dart';
import '../products/subcategory_product_screen.dart';

class InnerCategoryContentWidget extends ConsumerStatefulWidget {
  final Category category;

  const InnerCategoryContentWidget({super.key, required this.category});

  @override
  ConsumerState<InnerCategoryContentWidget> createState() =>
      _InnerCategoryContentWidgetState();
}

class _InnerCategoryContentWidgetState
    extends ConsumerState<InnerCategoryContentWidget> {
  @override
  void initState() {
    super.initState();
    // Tải subcategories cho danh mục hiện tại
    ref
        .read(categoryProvider.notifier)
        .refreshSubCategories(widget.category.name);
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryProvider);

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: HeaderWidget(),
      ),
      backgroundColor: AppColors.white40,
      body: Column(
        children: [
          InnerBannerWidget(image: widget.category.banner),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Text(
                "Danh mục sản phẩm",
                style: AppStyles.STYLE_20_BOLD.copyWith(
                  color: AppColors.blackFont,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
          Expanded(
            child: categoryState.isLoadingSubcategories
                ? const Center(child: CircularProgressIndicator())
                : categoryState.subcategories.isEmpty
                ? const Center(child: Text("Không có danh mục phụ."))
                : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: categoryState.subcategories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final sub = categoryState.subcategories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SubcategoryProductScreen(subcategory: sub),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            sub.image,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            sub.subCategoryName,
                            style: AppStyles.STYLE_16_BOLD,
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}