import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store/common/base/widgets/common/hearder_widget.dart';
import 'package:multi_store/common/base/widgets/details/category/subcategory_tile_widget.dart';
import 'package:multi_store/common/base/widgets/details/products/subcategory_product_screen.dart';
import 'package:multi_store/data/model/category_model.dart';
import 'package:multi_store/provider/category_provider.dart';
import 'package:multi_store/resource/theme/app_colors.dart';
import 'package:multi_store/resource/theme/app_style.dart';

class CategoryPage extends ConsumerStatefulWidget {
  const CategoryPage({super.key});

  @override
  ConsumerState<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends ConsumerState<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.2),
        child: const HeaderWidget(),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: AppColors.white40,
              child: categoryState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : categoryState.categories.isEmpty
                  ? const Center(child: Text("Không có danh mục"))
                  : ListView.builder(
                itemCount: categoryState.categories.length,
                itemBuilder: (context, index) {
                  final category = categoryState.categories[index];
                  return ListTile(
                    onTap: () async {
                      ref.read(categoryProvider.notifier).selectCategory(category);
                      await ref
                          .read(categoryProvider.notifier)
                          .refreshSubCategories(category.name);
                    },
                    title: Text(
                      category.name,
                      style: AppStyles.STYLE_12_BOLD.copyWith(
                        color: categoryState.selectedCategory == category
                            ? AppColors.bluePrimary
                            : AppColors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: categoryState.selectedCategory == null
                ? const Center(child: Text("Please select a category"))
                : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryState.selectedCategory!.name,
                      style: AppStyles.STYLE_20_BOLD.copyWith(color: AppColors.blackFont),
                    ),
                    if (categoryState.selectedCategory!.banner.isNotEmpty)
                      Container(
                        height: 130,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(categoryState.selectedCategory!.banner),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    categoryState.isLoadingSubcategories
                        ? const Center(child: CircularProgressIndicator())
                        : categoryState.subcategories.isEmpty
                        ? const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Center(child: Text("No subcategories available")),
                    )
                        : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categoryState.subcategories.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 4,
                        childAspectRatio: 2 / 3,
                      ),
                      itemBuilder: (context, index) {
                        final subcategory =
                        categoryState.subcategories[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return SubcategoryProductScreen(
                                    subcategory: subcategory);
                              }),
                            );
                          },
                          child: SubcategoryTileWidget(
                            image: subcategory.image,
                            title: subcategory.subCategoryName,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}