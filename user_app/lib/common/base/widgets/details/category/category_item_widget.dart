import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/provider/category_provider.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';
import 'package:multi_store/common/base/widgets/details/category/inner_category_content_widget.dart';

class CategoryItemWidget extends ConsumerStatefulWidget {
  const CategoryItemWidget({super.key});

  @override
  ConsumerState<CategoryItemWidget> createState() => _CategoryItemWidgetState();
}

class _CategoryItemWidgetState extends ConsumerState<CategoryItemWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryProvider);
    final visibleCategories = categoryState.categories.where((cat) => cat.id != 'all').toList();
    const int itemsPerPage = 8;
    final int totalPages = (visibleCategories.length / itemsPerPage).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RefreshIndicator(
          onRefresh: () async {
            await ref.read(categoryProvider.notifier).refreshCategories();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 12),
                categoryState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : categoryState.error != null
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.pink, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        categoryState.error!,
                        style: const TextStyle(color: AppColors.pink),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
                    : visibleCategories.isEmpty
                    ? const Center(child: Text("Không có danh mục"))
                    : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 180,
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            itemCount: totalPages,
                            itemBuilder: (context, pageIndex) {
                              final start = pageIndex * itemsPerPage;
                              final end = (start + itemsPerPage) > visibleCategories.length
                                  ? visibleCategories.length
                                  : (start + itemsPerPage);
                              final items = visibleCategories.sublist(start, end);

                              return GridView.builder(
                                padding: const EdgeInsets.only(top: 15),
                                itemCount: items.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                  childAspectRatio: 1,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final category = items[index];
                                  return InkWell(
                                    onTap: () async {
                                      final notifier = ref.read(categoryProvider.notifier);
                                      notifier.selectCategory(category);
                                      await notifier.refreshSubCategories(category.name);

                                      if (!mounted) return;

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => InnerCategoryContentWidget(
                                            category: category,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(
                                            category.image,
                                            height: 47,
                                            width: 47,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.broken_image,
                                                size: 50,
                                                color: Colors.grey,
                                              );
                                            },
                                          ),
                                        ),
                                        Text(
                                          category.name,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.STYLE_12.copyWith(color: AppColors.blackFont),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(totalPages, (index) {
                            return Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == index
                                    ? AppColors.bluePrimary
                                    : AppColors.blue200,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
