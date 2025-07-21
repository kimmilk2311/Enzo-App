import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor_store/controllers/vendor_auth_controller.dart';
import 'package:vendor_store/provider/vendor_provider.dart';
import 'package:vendor_store/views/screens/nav_screen/orders_page.dart';

import '../../../common/widgets/confirm_dialog.dart';
import '../../../resource/asset/app_images.dart';
import '../../../resource/theme/app_colors.dart';
import '../../../resource/theme/app_styles.dart';
import '../../../services/manage_http_response.dart';

class VendorProfilePage extends ConsumerStatefulWidget {
  const VendorProfilePage({super.key});

  @override
  ConsumerState<VendorProfilePage> createState() => _VendorProfilePageState();
}

class _VendorProfilePageState extends ConsumerState<VendorProfilePage> {
  final VendorAuthController _vendorAuthController = VendorAuthController();
  final ImagePicker picker = ImagePicker();

  final ValueNotifier<File?> imageNotifier = ValueNotifier<File?>(null);

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageNotifier.value = File(pickedFile.path);
    } else {
      showSnackBar(context, "Không lấy được ảnh");
    }
  }

  void showEditProfileDialog(BuildContext context) {
    final user = ref.read(vendorProvider);
    final TextEditingController storeDescriptionController = TextEditingController();

    storeDescriptionController.text = user?.storeDescription ?? "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              "Sủa thông tin",
              style: AppStyles.STYLE_20_BOLD.copyWith(color: AppColors.blackFont),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder(
                    valueListenable: imageNotifier,
                    builder: (context, value, child) {
                      return InkWell(
                        onTap: () {
                          pickImage();
                        },
                        child: value != null
                            ? CircleAvatar(
                                radius: 40,
                                backgroundImage: FileImage(value),
                              )
                            : const CircleAvatar(
                                radius: 40,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    CupertinoIcons.photo,
                                    size: 30,
                                  ),
                                ),
                              ),
                      );
                    }),
                const SizedBox(height: 10),
                TextFormField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Mô tả cửa hàng",
                    border: OutlineInputBorder(),
                  ),
                  controller: storeDescriptionController,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Hủy",
                  style: AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.greyDark),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _vendorAuthController.updateVendorData(
                    context: context,
                    id: ref.read(vendorProvider)!.id,
                    ref: ref,
                    storeImage: imageNotifier.value,
                    storeDescription: storeDescriptionController.text,
                  );
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bluePrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                child: Text(
                  "Lưu",
                  style: AppStyles.STYLE_16_BOLD.copyWith(color: AppColors.white),
                ),
              ),
            ],
          );
        });
  }

  ImageProvider _buildUserImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const AssetImage(AppImages.imgDefaultAvatar);
    } else if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else {
      final file = File(imagePath);
      if (file.existsSync()) {
        return FileImage(file);
      } else {
        return const AssetImage(AppImages.imgDefaultAvatar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(vendorProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.bluePrimary,
        elevation: 0,
        title: const Text(
          'Thông tin cửa hàng',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Avatar và thông tin cửa hàng
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.grey, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: _buildUserImage(user?.storeImage),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.fullName ?? 'Tên cửa hàng',
                    style: AppStyles.STYLE_28_BOLD.copyWith(color: AppColors.blackFont),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      user?.storeDescription ?? 'Chưa có mô tả',
                      style: AppStyles.STYLE_16.copyWith(color: AppColors.greyDark),
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text("Cập nhật thông tin", style: AppStyles.STYLE_14_BOLD),
                  onTap: () => showEditProfileDialog(context),
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text("Lịch sử đơn hàng", style: AppStyles.STYLE_14_BOLD),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OrdersPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Đăng xuất", style: AppStyles.STYLE_14_BOLD),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        content: "Bạn có chắc chắn muốn đăng xuất không?",
                        onConfirm: () => _vendorAuthController.signOutVendor(context: context),
                        onCancel: () {},
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
