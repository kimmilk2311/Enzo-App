import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor_store/common/widgets/app_button.dart';
import 'package:vendor_store/controllers/product_controller.dart';
import 'package:vendor_store/controllers/subcategory_controller.dart';
import 'package:vendor_store/models/subcategory.dart';
import 'package:vendor_store/provider/vendor_provider.dart';
import 'package:vendor_store/resource/theme/app_colors.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../controllers/category_controller.dart';
import '../../../models/category.dart';

class UploadPage extends ConsumerStatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends ConsumerState<UploadPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProductController _productController = ProductController();
  final ImagePicker picker = ImagePicker();

  late Future<List<Category>> futureCategories;
  Future<List<SubCategory>>? futureSubcategories;
  Category? selectedCategory;
  SubCategory? selectedSubcategory;

  String productName = '';
  int productPrice = 0;
  int quantity = 0;
  String description = '';

  List<File> images = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

  Future<void> chooseImage() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        images.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
      });
    } else {
      print("Không chọn ảnh nào");
    }
  }

  void removeImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  void getSubcategoryByCategory(Category? category) {
    if (category == null) return;
    setState(() {
      futureSubcategories = SubcategoryController().getSubCategoriesByCategoryName(category.name);
      selectedSubcategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vendor = ref.watch(vendorProvider);

    if (vendor == null) {
      return const Scaffold(
        body: Center(child: Text('Vui lòng đăng nhập để tải lên sản phẩm')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Tải sản phẩm",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.bluePrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hiển thị và chọn hình ảnh
                const Text(
                  "Hình ảnh sản phẩm",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackFont,
                  ),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  itemCount: images.length + 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return index == 0
                        ? GestureDetector(
                      onTap: chooseImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: AppColors.bluePrimary,
                          ),
                        ),
                      ),
                    )
                        : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            images[index - 1],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => removeImage(index - 1),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 25),

                // Tên sản phẩm
                CustomTextField(
                  label: "Tên sản phẩm",
                  hint: "Nhập tên sản phẩm",
                  onChanged: (value) => productName = value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 20),

                // Giá sản phẩm
                CustomTextField(
                  label: "Giá",
                  hint: "Nhập giá sản phẩm",
                  onChanged: (value) => productPrice = int.tryParse(value) ?? 0,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 20),

                // Số lượng
                CustomTextField(
                  label: "Số lượng",
                  hint: "Nhập số lượng",
                  onChanged: (value) => quantity = int.tryParse(value) ?? 0,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 20),

                // Mô tả
                CustomTextField(
                  label: "Mô tả",
                  hint: "Nhập mô tả sản phẩm",
                  onChanged: (value) => description = value,
                  maxLine: 4,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 25),

                // Chọn danh mục
                FutureBuilder<List<Category>>(
                  future: futureCategories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Lỗi: ${snapshot.error}');
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      child: DropdownButtonFormField<Category>(
                        decoration: const InputDecoration(
                          labelText: "Chọn danh mục",
                          border: InputBorder.none,
                        ),
                        value: selectedCategory,
                        items: snapshot.data!.map((Category category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(
                              category.name,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.blackFont,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                            selectedSubcategory = null;
                          });
                          getSubcategoryByCategory(value);
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Chọn danh mục con
                FutureBuilder<List<SubCategory>>(
                  future: futureSubcategories,
                  builder: (context, snapshot) {
                    if (selectedCategory == null) {
                      return const Text(
                        "Chọn danh mục trước",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      child: DropdownButtonFormField<SubCategory>(
                        decoration: const InputDecoration(
                          labelText: "Chọn danh mục con",
                          border: InputBorder.none,
                        ),
                        value: selectedSubcategory,
                        items: snapshot.data?.map((sub) {
                          return DropdownMenuItem(
                            value: sub,
                            child: Text(
                              sub.subCategoryName,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.blackFont,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => selectedSubcategory = value),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),

                // Nút tải lên
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.bluePrimary, AppColors.blue600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.bluePrimary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: AppButton(
                    text: "Tải lên",
                    isLoading: isLoading,
                    onPressed: () async {
                      final vendorId = vendor.id;

                      if (vendorId.isEmpty || images.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Vendor ID hoặc hình ảnh không hợp lệ."),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      setState(() => isLoading = true);
                      await _productController.uploadProduct(
                        productName: productName,
                        productPrice: productPrice,
                        quantity: quantity,
                        description: description,
                        category: selectedCategory!.name,
                        vendorId: vendorId,
                        fullName: vendor.fullName ?? "Unknown Vendor",
                        subCategory: selectedSubcategory!.subCategoryName,
                        pickedImages: images,
                        context: context,
                      );
                      setState(() => isLoading = false);
                    },
                    color: Colors.transparent,

                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}