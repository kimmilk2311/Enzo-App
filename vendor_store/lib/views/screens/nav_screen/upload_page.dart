import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  chooseImage() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        images.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
      });
    } else {
      print("Không chọn ảnh nào");
    }
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tải lên sản phẩm"),
        backgroundColor: AppColors.bluePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GridView.builder(
                itemCount: images.length + 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return index == 0
                      ? IconButton(
                    onPressed: chooseImage,
                    icon: const Icon(Icons.camera_alt, size: 30),
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      images[index - 1],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: "Tên sản phẩm",
                hint: "Nhập tên sản phẩm",
                onChanged: (value) => productName = value,
              ),
              CustomTextField(
                label: "Giá",
                hint: "Nhập giá sản phẩm",
                onChanged: (value) => productPrice = int.tryParse(value) ?? 0,
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                label: "Số lượng",
                hint: "Nhập số lượng",
                onChanged: (value) => quantity = int.tryParse(value) ?? 0,
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                label: "Mô tả",
                hint: "Nhập mô tả sản phẩm",
                onChanged: (value) => description = value,
                maxLine: 4,
              ),
              const SizedBox(height: 20),

              FutureBuilder<List<Category>>(
                future: futureCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Lỗi: ${snapshot.error}');
                  }
                  return DropdownButtonFormField<Category>(
                    decoration: const InputDecoration(labelText: "Chọn danh mục"),
                    value: selectedCategory,
                    items: snapshot.data!.map((Category category) {
                      return DropdownMenuItem(value: category, child: Text(category.name));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                        selectedSubcategory = null;
                      });
                      getSubcategoryByCategory(value);
                    },
                  );
                },
              ),
              const SizedBox(height: 20),

              FutureBuilder<List<SubCategory>>(
                future: futureSubcategories,
                builder: (context, snapshot) {
                  if (selectedCategory == null) return const Text("Chọn danh mục trước");

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return DropdownButtonFormField<SubCategory>(
                    decoration: const InputDecoration(labelText: "Chọn danh mục con"),
                    value: selectedSubcategory,
                    items: snapshot.data?.map((sub) {
                      return DropdownMenuItem(value: sub, child: Text(sub.subCategoryName));
                    }).toList(),
                    onChanged: (value) => setState(() => selectedSubcategory = value),
                  );
                },
              ),
              const SizedBox(height: 20),

              AppButton(
                text: "Tải lên",
                isLoading: isLoading,
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  final vendorId = prefs.getString('vendorId') ?? '';

                  if (vendorId.isEmpty || images.isEmpty) {
                    print("Vendor ID hoặc hình ảnh không hợp lệ.");
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
                    fullName: vendor?.fullName ?? "Unknown Vendor",
                    subCategory: selectedSubcategory!.subCategoryName,
                    pickedImages: images,
                    context: context,
                  );
                  setState(() => isLoading = false);
                },
                color: AppColors.bluePrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
