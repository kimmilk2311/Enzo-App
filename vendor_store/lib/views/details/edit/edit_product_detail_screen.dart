import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor_store/common/widgets/app_button.dart';
import 'package:vendor_store/controllers/product_controller.dart';
import 'package:vendor_store/resource/theme/app_colors.dart';
import 'package:vendor_store/resource/theme/app_styles.dart';

import '../../../models/product.dart';

class EditProductDetailScreen extends StatefulWidget {
  final Product product;

  const EditProductDetailScreen({super.key, required this.product});

  @override
  State<EditProductDetailScreen> createState() => _EditProductDetailScreenState();
}

class _EditProductDetailScreenState extends State<EditProductDetailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController productNameController;
  late TextEditingController productPriceController;
  late TextEditingController quantityController;
  late TextEditingController descriptionController;
  final ProductController _productController = ProductController();
  List<File>? pickedImages;

  bool _isUpdating = false; // 👈 Thêm biến này

  @override
  void initState() {
    super.initState();
    productNameController = TextEditingController(text: widget.product.productName);
    productPriceController = TextEditingController(text: widget.product.productPrice.toString());
    quantityController = TextEditingController(text: widget.product.quantity.toString());
    descriptionController = TextEditingController(text: widget.product.description);
  }

  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    setState(() {
      pickedImages = pickedFiles.map((file) => File(file.path)).toList();
    });
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUpdating = true; // 👈 Bắt đầu loading
      });

      try {
        List<String> uploadImages = pickedImages != null && pickedImages!.isNotEmpty
            ? await _productController.uploadImagesToCloudinary(pickedImages, widget.product)
            : widget.product.images;

        final updateProduct = Product(
          id: widget.product.id,
          productName: productNameController.text,
          productPrice: int.parse(productPriceController.text),
          quantity: int.parse(quantityController.text),
          description: descriptionController.text,
          category: widget.product.category,
          vendorId: widget.product.vendorId,
          fullName: widget.product.fullName,
          subCategory: widget.product.subCategory,
          images: uploadImages,
          averageRating: widget.product.averageRating,
          totalRatings: widget.product.totalRatings,
        );

        await _productController.updateProduct(
          product: updateProduct,
          pickedImages: pickedImages,
          context: context,
        );
      } finally {
        setState(() {
          _isUpdating = false; // 👈 Kết thúc loading
        });
      }
    } else {
      print('Lỗi');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chỉnh sửa sản phẩm",
          style: AppStyles.STYLE_20_BOLD.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.bluePrimary,
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: productNameController,
                  validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên sản phẩm' : null,
                  decoration: InputDecoration(
                    labelText: 'Tên sản phẩm',
                    labelStyle: AppStyles.STYLE_14_BOLD.copyWith(color: AppColors.greyDark),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: productPriceController,
                  validator: (value) => value!.isEmpty ? 'Vui lòng nhập giá sản phẩm' : null,
                  decoration: InputDecoration(
                    labelText: 'Giá sản phẩm',
                    labelStyle: AppStyles.STYLE_14_BOLD.copyWith(color: AppColors.greyDark),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: quantityController,
                  validator: (value) => value!.isEmpty ? 'Vui lòng nhập số lượng sản phẩm' : null,
                  decoration: InputDecoration(
                    labelText: 'Số lượng sản phẩm',
                    labelStyle: AppStyles.STYLE_14_BOLD.copyWith(color: AppColors.greyDark),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  maxLength: 500,
                  maxLines: 5,
                  controller: descriptionController,
                  validator: (value) => value!.isEmpty ? 'Vui lòng nhập mô tả sản phẩm' : null,
                  decoration: InputDecoration(
                    labelText: 'Mô tả sản phẩm',
                    labelStyle: AppStyles.STYLE_14_BOLD.copyWith(color: AppColors.greyDark),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 20),

                // Display existing images if available
                if (widget.product.images.isNotEmpty)
                  Wrap(
                    spacing: 10,
                    children: widget.product.images.map((imageUrl) {
                      return GestureDetector(
                        onTap: _pickImages,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 15),

                // Display picked images
                if (pickedImages != null)
                  Wrap(
                    spacing: 10,
                    children: pickedImages!.map((image) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 20),

                // Update button
                AppButton(
                  text: "Cập nhật",
                  onPressed: _updateProduct,
                  color: AppColors.bluePrimary,
                  isLoading: _isUpdating,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
