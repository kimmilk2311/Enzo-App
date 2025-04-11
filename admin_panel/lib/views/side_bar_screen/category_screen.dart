import 'package:admin_panel_app_web/controllers/category_controller.dart';
import 'package:admin_panel_app_web/views/side_bar_screen/widgets/category_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = '\category-screen';
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CategoryController _categoryController = CategoryController();
  late String name;
  dynamic _image;
  dynamic _bannerImage;

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
      });
    }
  }

  pickBannerImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _bannerImage = result.files.first.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Thêm danh mục hàng",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
              ),
            const  Padding(
                padding:  EdgeInsets.all(4.0),
                child:  Divider(color: Colors.grey),
              ),

              // Category Image Picker
              Row(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: _image != null
                          ? Image.memory(_image)
                          : const Text("Hình ảnh"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) {
                        name = value;
                      },
                      validator: (value) {
                        return value!.isNotEmpty
                            ? null
                            : "Nhập danh mục hàng";
                      },
                      decoration: const InputDecoration(
                          labelText: "Nhập danh mục hàng"),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print(name);
                      }
                    },
                    child: const Text("Hủy"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _categoryController.uploadCategory(
                          pickedImage: _image,
                          pickedBanner: _bannerImage,
                          name: name,
                          context: context,
                        );
                        // setState(() {
                        //   _formKey.currentState!.reset();
                        // });
                      }
                    },
                    child: const Text(
                      "Lưu",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Pick Image Button
              ElevatedButton(
                onPressed: pickImage,
                child: const Text("Chọn ảnh"),
              ),
              const Divider(color: Colors.grey),

              // Banner Image Picker
              Row(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: _bannerImage != null
                          ? Image.memory(_bannerImage)
                          : const Text("Chọn banner ảnh"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: pickBannerImage,
                    child: const Text("Chọn ảnh"),
                  ),
                ],
              ),

              const Divider(color: Colors.grey),

              // Category List
            const  SizedBox(
                height: 500,
                child: CategoryWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
