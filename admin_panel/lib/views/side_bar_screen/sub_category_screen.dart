import 'package:admin_panel_app_web/controllers/category_controller.dart';
import 'package:admin_panel_app_web/controllers/subcategory_controller.dart';
import 'package:admin_panel_app_web/views/side_bar_screen/widgets/subcategory_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../models/category.dart';

class SubCategoryScreen extends StatefulWidget {
  static const String id = 'subcategoryScreen';

  const SubCategoryScreen({super.key});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  late Future<List<Category>> futureCategories;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SubcategoryController subcategoryController = SubcategoryController();
  Category? selectedCategory;
  dynamic _image;
  late String name;

    @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }


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


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Tải danh mục con",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const Divider(color: Colors.grey, thickness: 1),
              const SizedBox(height: 12),
              FutureBuilder<List<Category>>(
                future: futureCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("No category available");
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        width: 350, // Thu hẹp dropdown
                        child: DropdownButtonFormField<Category>(
                          decoration: const InputDecoration(
                            labelText: "Nhập danh mục con",
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
                            });
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 350,
                child: TextFormField(
                  onChanged: (value) => name = value,
                  validator: (value) => value!.isNotEmpty ? null : "Nhập danh mục con",
                  decoration: const InputDecoration(
                    labelText: "Nhập danh mục con",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: _image != null
                        ? Image.memory(_image, fit: BoxFit.cover)
                        : const Center(child: Text("Hình ảnh", textAlign: TextAlign.center)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      backgroundColor: Colors.white,
                      elevation: 1,
                      side: const BorderSide(color: Colors.grey),
                    ),
                    onPressed: pickImage,
                    icon: const Icon(Icons.upload, size: 14, color: Colors.purple),
                    label: const Text("Chọn ảnh", style: TextStyle(fontSize: 12, color: Colors.purple)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 130,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onPressed: () async{
                    if (_formKey.currentState!.validate()) {
                   await   subcategoryController.uploadSubcategory(
                        categoryId: selectedCategory!.id,
                        categoryName: selectedCategory!.name,
                        pickedImage: _image,
                        subCategoryName: name,
                        context: context,
                      );
                   setState(() {
                     _formKey.currentState!.reset();
                     _image = null;
                   });
                    }
                  },
                  child: const Text("Lưu", style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),
              const Divider(color: Colors.grey,),
          
          const    SubcategoryWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
