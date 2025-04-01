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
import '../../../services/manage_http_response.dart';

class UploadPage extends ConsumerStatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends ConsumerState<UploadPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProductController _productController = ProductController();
  late Future<List<Category>> futureCategories;
  Future<List<SubCategory>>? futureSubcategories;
  Category? selectedCategory;
  SubCategory? selectedSubcategory;
  late String productName;
  late int productPrice;
  late int quantity;
  late String description;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

  // Tao mot instance cua ImagePicker de xu ly chon anh
  final ImagePicker picker = ImagePicker();

  // Khoi tao danh sach rong de luu tru anh duoc chon
  List<File> images = [];

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


  // Lay danh muc con theo ten danh muc cha
  void getSubcategoryByCategory(Category? category) {
    if (category == null) return;
    setState(() {
      futureSubcategories = SubcategoryController().getSubCategoriesByCategoryName(category.name);
      selectedSubcategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              GridView.builder(
                itemCount: images.length + 1,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return index == 0
                      ? Center(
                    child: IconButton(
                      onPressed: chooseImage,
                      icon: const Icon(Icons.camera_alt),
                    ),
                  )
                      : SizedBox(
                    width: 50,
                    height: 40,
                    child: Image.file(images[index - 1]),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Nhập sản phẩm";
                        } else {
                          return null;
                        }
                      },
                      label: "Nhập sản phẩm",
                      hint: "Nhập sản phẩm",
                      onChanged: (value) {
                        productName = value;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      onChanged: (value) {
                        productPrice = int.parse(value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Nhập giá sản phẩm";
                        } else {
                          return null;
                        }
                      },
                      label: "Giá",
                      hint: "Giá",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Nhập số lượng sản phẩm";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        quantity = int.parse(value);
                      },
                      label: "Số lượng",
                      hint: "Số lượng",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),

                    // Dropdown danh muc cha
                    SizedBox(
                      width: 200,
                      child: FutureBuilder<List<Category>>(
                        future: futureCategories,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Lỗi: ${snapshot.error}');
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Text("Không có danh mục nào");
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: SizedBox(
                                width: 200,
                                child: DropdownButtonFormField<Category>(
                                  decoration: const InputDecoration(
                                    labelText: "Chọn danh mục",
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  value: selectedCategory,
                                  items: snapshot.data!.map((Category category) {
                                    return DropdownMenuItem(
                                      value: category,
                                      child: Text(category.name),
                                    );
                                  }).toList(),
                                  onChanged: (Category? value) {
                                    setState(() {
                                      selectedCategory = value;
                                      selectedSubcategory = null;
                                    });
                                    getSubcategoryByCategory(value);
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),

                    // Dropdown danh muc con
                    SizedBox(
                      width: 200,
                      child: FutureBuilder<List<SubCategory>>(
                        future: futureSubcategories,
                        builder: (context, snapshot) {
                          if (selectedCategory == null) {
                            return const Text("Vui lòng chọn danh mục trước");
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Lỗi: ${snapshot.error}');
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Text("Không có danh mục con nào");
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: SizedBox(
                                width: 200,
                                child: DropdownButtonFormField<SubCategory>(
                                  decoration: const InputDecoration(
                                    labelText: "Chọn danh mục con",
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  value: selectedSubcategory,
                                  items: snapshot.data!.map((SubCategory subcategory) {
                                    return DropdownMenuItem(
                                      value: subcategory,
                                      child: Text(subcategory.subCategoryName),
                                    );
                                  }).toList(),
                                  onChanged: (SubCategory? value) {
                                    setState(() {
                                      selectedSubcategory = value;
                                    });
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),

                    CustomTextField(
                      onChanged: (value) {
                        description = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Viết mô tả..";
                        } else {
                          return null;
                        }
                      },
                      label: "Mô tả...",
                      hint: "Mô tả",
                      maxLength: 500,
                      maxLine: 3,
                    ),
                    const SizedBox(height: 20),

                    AppButton(
                      text: "Tải lên",
                      isLoading: isLoading,
                      onPressed: () async {
                        final fullName = ref.read(vendorProvider)!.fullName;
                        final vendorId = ref.read(vendorProvider)!.id;
                        print("fullName: $fullName, vendorId: $vendorId");

                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true; // Bật trạng thái loading
                          });

                          await _productController.uploadProduct(
                            productName: productName,
                            productPrice: productPrice,
                            quantity: quantity,
                            description: description,
                            category: selectedCategory!.name,
                            vendorId: vendorId,
                            fullName: fullName,
                            subCategory: selectedSubcategory!.subCategoryName,
                            pickedImages: images,
                            context: context,
                          ).whenComplete(() {
                            setState(() {
                              productName = "";
                              productPrice = 0;
                              quantity = 0;
                              description = "";
                              images.clear();
                              selectedCategory = null;
                              selectedSubcategory = null;
                              isLoading = false;
                            });

                            _formKey.currentState!.reset();
                          });
                        } else {
                          print("Điền tất cả các trường sản phẩm");
                        }
                      },
                      color: AppColors.bluePrimary,
                      width: 300,
                      height: 40,
                      textColor: AppColors.white40,
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}